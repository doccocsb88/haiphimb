//
//  SearchViewController.m
//  SlideMenu
//
//  Created by Apple on 5/31/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultItem.h"
#import "PlayVideoViewController.h"
#import "ColorSchemeHelper.h"
@interface SearchViewController ()
{
    NSString *searhKey;
    CGSize viewSize;
    NSMutableArray *searchResults;
    NSTimer *searchDelayer;
    NSMutableData *receivedData;
    NSInteger paramPage;
    NSInteger zCount;
}
@end

@implementation SearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    zCount = 0;
    paramPage =1;
    viewSize = self.view.frame.size;
    UIColor *color = [UIColor colorWithRed:209/255.0 green:2/255.0 blue:38/255.0 alpha:1.f];
    self.view.backgroundColor = color;
    [self initDataArray];
    [self initSearchBar];
    [self initSearchResultTable];
    [self readDataFromServer];
    // Do any additional setup after loading the view.
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.playvideoController!=nil && self.playvideoController.isFullScreen==NO) {
        [self.playvideoController removeView];
        [self.playvideoController.view removeFromSuperview];
        self.playvideoController=nil;
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initDataArray{
    searchResults = [[NSMutableArray alloc]init];
}
-(void)initSearchBar{
    _search = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 30  , viewSize.width-20, 40)];
    _search.delegate =self;
    _search.backgroundColor =[ColorSchemeHelper sharedNationHeaderColor];
    _search.barTintColor = [ColorSchemeHelper sharedNationHeaderColor];
//    _search.tintColor = [UIColor greenColor];
    _search.translucent = NO;
    _search.opaque = NO;
    _search.showsCancelButton = NO;
    _search.searchBarStyle = UISearchBarStyleMinimal;
    _search.placeholder = @"Search : title , actor , director ...";
    @try {
        for (id object in [[[_search subviews] firstObject] subviews])
        {
            if (object && [object isKindOfClass:[UITextField class]])
            {
                UITextField *textFieldObject = (UITextField *)object;
                textFieldObject.backgroundColor = [UIColor whiteColor];
                textFieldObject.borderStyle = UITextBorderStyleNone;
                textFieldObject.layer.borderColor = [UIColor blueColor].CGColor;
                textFieldObject.layer.borderWidth = 0.0;
                textFieldObject.layer.cornerRadius = 5.f;
                textFieldObject.clipsToBounds = YES;
                break;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error while customizing UISearchBar");
    }
    @finally {
        
    }
    [self.view addSubview:_search];
    //init button cancel
    _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(viewSize.width-80, 50, 70, 40)];
    [_btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [_btnCancel addTarget:self action:@selector(pressedCancel:) forControlEvents:UIControlEventTouchUpInside];
    [_btnCancel setHidden:YES];
    [self.view addSubview:_btnCancel];
}
-(void)initSearchResultTable{
    _tbSearch = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, viewSize.width , viewSize.height-100)];
    _tbSearch.dataSource = self;
    _tbSearch.delegate = self;
    
    [self.view addSubview:_tbSearch];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)pressedCancel:(id)sender{
    [self.tabBarController  setSelectedIndex:0];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //if (tableView == self.searchDisplayController.searchResultsTableView) {
    
    return [searchResults count];
        
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"sfCell";
//    RecipeTableCell *cell = (RecipeTableCell *)[self.tbSearch dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    // Configure the cell...
//    if (cell == nil) {
//        cell = [[RecipeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    // Display recipe in the table cell
//    Recipe *recipe = nil;
//        recipe = [searchResults objectAtIndex:indexPath.row];
//    
//    cell.nameLabel.text = recipe.name;
//    cell.thumbnailImageView.image = [UIImage imageNamed:recipe.image];
//    cell.prepTimeLabel.text = recipe.prepTime;
    SearchResultViewCell *cell= [self.tbSearch dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[SearchResultViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier frame : CGRectMake(0, 0, viewSize.width, 71)] ;
    }
    cell.searchCellDelegate = self;
    [cell setContentView:[searchResults objectAtIndex:indexPath.row] atIndex:indexPath.row];
    if(indexPath.row == zCount-1){
        [self readDataFromServer];
        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    playvid
    //

    SearchResultItem *item =[searchResults objectAtIndex:indexPath.row];
//
//    PlayVideoViewController *vc = [[PlayVideoViewController alloc] initWithInfo:item];
//    [vc prepareFilmData:item];
//    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    vc.view.backgroundColor = [UIColor clearColor];
//    [self presentViewController:vc animated:YES completion:nil];
    [self.view endEditing:YES];

    if(self.playvideoController==nil)
    {
        [self showSecondController:item];
    }
    else
    {
        [self.playvideoController removeView];
        [self.playvideoController.view removeFromSuperview];
        self.playvideoController=nil;
        
        [self showSecondController:item];
        
    }
}
#pragma mark -
#pragma mark -Important Methods

-(void)showSecondController:(SearchResultItem*)item
{
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    
    self.playvideoController = [[PlayVideoViewController alloc] initWithInfo:item];
    //initial frame
    self.playvideoController.view.frame=CGRectMake(self.view.frame.size.width-50, self.view.frame.size.height-50, self.view.frame.size.width, self.view.frame.size.height);
    self.playvideoController.initialFirstViewFrame=self.view.frame;
    
    
    self.playvideoController.view.alpha=0;
    self.playvideoController.view.transform=CGAffineTransformMakeScale(0.2, 0.2);
    
    
    [self.view addSubview:self.playvideoController.view];
    self.playvideoController.onView=self.view;
    
    [UIView animateWithDuration:0.9f animations:^{
        self.playvideoController.view.transform=CGAffineTransformMakeScale(1.0, 1.0);
        self.playvideoController.view.alpha=1;
        
        self.playvideoController.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished){
        [self.playvideoController prepareFilmData:item];
    }];
    
}
-(void)setImageAtIndex:(NSInteger)index image:(UIImage *)img{
    if (index< searchResults.count) {
   
    SearchResultItem *item = [searchResults objectAtIndex:index];
    item.thumbnail = img;
    [searchResults replaceObjectAtIndex:index withObject:item];
//        <#statements#>
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showRecipeDetail"]) {
//        NSIndexPath *indexPath = nil;
//        Recipe *recipe = nil;
//        indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
//            recipe = [searchResults objectAtIndex:indexPath.row];      
//        RecipeDetailViewController *destViewController = segue.destinationViewController;
//        destViewController.recipe = recipe;
    }
}

// return NO to not become first responder
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"beginInputTextToSearch");

}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
//    [self filterContentForSearchText:searchString
//                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
//                                      objectAtIndex:[self.searchDisplayController.searchBar
//                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

/**/
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [searchDelayer invalidate], searchDelayer=nil;
    if (searchText.length>=2){
        searchDelayer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                         target:self
                                                       selector:@selector(doDelayedSearch:)
                                                       userInfo:searchText
                                                        repeats:NO];
    }else{
        paramPage = 1;
        [searchResults removeAllObjects];
        [_tbSearch reloadData];
    }
}

-(void)doDelayedSearch:(NSTimer *)t
{
    assert(t == searchDelayer);
    [self request:searchDelayer.userInfo];
    searchDelayer = nil; // important because the timer is about to release and dealloc itself
}
-(void)request:(NSString *)myString
{
//    NSLog(@"%@",myString);
    paramPage = 1;
    [searchResults removeAllObjects];
    [_tbSearch reloadData];
    searhKey = [[self removeAccents:myString] stringByTrimmingCharactersInSet:
    [NSCharacterSet whitespaceCharacterSet]];
    if (![searhKey isEqualToString:@""]) {
        
    
    [self readDataFromServer];
    }
    
}
-(void)readDataFromServer{
    NSLog(@"readingData from server");

//"http://www.phimb.net/json-api/movies.php?v=538c7f456122cca4d87bf6de9dd958b5%2F839%2F1"
//    NSString *myRequestString = @"v=538c7f456122cca4d87bf6de9dd958b5%2F839%2F1";
//    
//    // Create Data from request
//    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://www.phimb.net/json-api/movies.php"]];
    NSString *WS_URL = [NSString stringWithFormat:@"http://www.phimb.net/api/list/538c7f456122cca4d87bf6de9dd958b5/search/%@/%ld",[searhKey stringByReplacingOccurrencesOfString:@" " withString:@"%20"],paramPage];

    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:WS_URL]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"API URL %@",WS_URL);
    if (connection)
    {
        
        //receivedData = nil;
    }
    else
    {
        NSLog(@"Connection could not be established");
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!receivedData)
        receivedData = [[NSMutableData alloc] initWithData:data];
    else
        [receivedData appendData:data];
    [self pareJsonToData];
}
-(void)pareJsonToData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Background work
        NSString *receivedDataString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        NSError* error;
        
        NSDictionary* json =     [NSJSONSerialization JSONObjectWithData: [receivedDataString dataUsingEncoding:NSUTF8StringEncoding]
                                                                 options: NSJSONReadingMutableContainers
                                                                   error: &error];
        NSArray *wrapper= [NSJSONSerialization JSONObjectWithData:[receivedDataString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI
            
            
            //SearchResultItem *item = [[SearchResultItem alloc] initWithData:json];
            if(json){
                //                [searchResults removeAllObjects];
                NSMutableArray *arrs = [[NSMutableArray alloc] init];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    NSLog(@"json %d  %@",json.count,json);
                    NSLog(@"json array %d",wrapper.count);
                    for(int i = 0; i < wrapper.count;i++){
                        NSDictionary *avatars = [wrapper objectAtIndex:i];
                        NSLog(@"xxx : %@",avatars);
                        SearchResultItem *item= [[SearchResultItem alloc] initWithData:avatars];
                        //                        [searchResults addObject:item ];
                        if([self filterSearchResult:item]){
                            [arrs addObject:item];
                            zCount++;;
                        }
                    }
                   
                    paramPage++;

                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                        [_tbSearch reloadData];
                        for(int i = 0; i < arrs.count;i++){
                            [searchResults addObject:[arrs objectAtIndex:i]];
                            NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:searchResults.count-1 inSection:0];
                            [_tbSearch beginUpdates];
                            [_tbSearch insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
                            [_tbSearch endUpdates];
                        }
                    });
                });
            }
            
        });
    });
}

-(BOOL)filterSearchResult:(SearchResultItem *)item{
    NSString *str1 = [[self removeAccents:searhKey] uppercaseString];
    NSString *str2 = [[self removeAccents:item.name] uppercaseString];
    NSLog(@"%@---%@",str2,str1);
    return [str2 containsString:str1];
}

- (NSString*) removeAccents:(NSString*)str
{
    str = [str stringByReplacingOccurrencesOfString:@"Đ" withString:@"D"];
    NSData *asciiEncoded = [str dataUsingEncoding:NSASCIIStringEncoding
                              allowLossyConversion:YES];
    
    NSString *accentRemoved = [[NSString alloc] initWithData:asciiEncoded
                               
                                                    encoding:NSASCIIStringEncoding];
    
    return accentRemoved;
}

@end
