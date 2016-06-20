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
}
@end

@implementation SearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    paramPage =1;
    viewSize = self.view.frame.size;
    
    self.view.backgroundColor = [ColorSchemeHelper sharedSearchHeaderColor];
    [self initDataArray];
    [self initSearchBar];
    [self initSearchResultTable];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initDataArray{
    searchResults = [[NSMutableArray alloc]init];
}
-(void)initSearchBar{
    _search = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 27  , viewSize.width-20, 30)];
//    _search.searchBarStyle = UISearchBarStyleMinimal;
    _search.delegate =self;
    _search.backgroundColor = [UIColor clearColor];
    _search.backgroundImage = [[UIImage alloc] init];
    _search.barTintColor = [UIColor clearColor];
    _search.layer.borderWidth = 0;
    _search.layer.borderColor = [UIColor clearColor].CGColor;
    [self.view addSubview:_search];
//    UITextField *searchField = [_search valueForKey:@"searchField"];
//    
//    // To change background color
//    searchField.backgroundColor = [UIColor whiteColor];
//    
//    // To change text color
//    searchField.textColor = [UIColor blackColor];
//    
//    // To change placeholder text color
//    searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Some Text"];
//    UILabel *placeholderLabel = [searchField valueForKey:@"placeholderLabel"];
//    placeholderLabel.textColor = [UIColor grayColor];
}
-(void)initSearchResultTable{
    _tbSearch = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, viewSize.width , viewSize.height-100)];
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
        cell = [[SearchResultViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier frame : CGRectMake(0, 0, viewSize.width-60, 71)] ;
    }
    cell.searchCellDelegate = self;
    [cell setContentView:[searchResults objectAtIndex:indexPath.row] atIndex:indexPath.row];
    if(indexPath.row == searchResults.count - 1 && searchResults.count %10==0){
        [self readDataFromServer];
        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    playvid
    //

    SearchResultItem *item =[searchResults objectAtIndex:indexPath.row];

    PlayVideoViewController *vc = [[PlayVideoViewController alloc] initWithInfo:item];
    [vc prepareFilmData:item];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.view.backgroundColor = [UIColor clearColor];
    [self presentViewController:vc animated:YES completion:nil];

}
-(void)setImageAtIndex:(NSInteger)index image:(UIImage *)img{
    SearchResultItem *item = [searchResults objectAtIndex:index];
    item.thumbnail = img;
    [searchResults replaceObjectAtIndex:index withObject:item];
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
    if (searchText.length>=2)
        searchDelayer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                         target:self
                                                       selector:@selector(doDelayedSearch:)
                                                       userInfo:searchText
                                                        repeats:NO];
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
    searhKey = [self removeAccent:myString];
    paramPage = 1;
    [searchResults removeAllObjects];
    [_tbSearch reloadData];
    [self readDataFromServer];

    
}
-(void)readDataFromServer{
    NSLog(@"readingData from server");

//"http://www.phimb.net/json-api/movies.php?v=538c7f456122cca4d87bf6de9dd958b5%2F839%2F1"
//    NSString *myRequestString = @"v=538c7f456122cca4d87bf6de9dd958b5%2F839%2F1";
//    
//    // Create Data from request
//    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://www.phimb.net/json-api/movies.php"]];
    NSString *urlCuoc = [NSString stringWithFormat:@"http://www.phimb.net/api/list/538c7f456122cca4d87bf6de9dd958b5/search/%@/%ld",searhKey,paramPage];

    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:urlCuoc]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        receivedData = [[NSMutableData alloc] init];
        NSString *receivedDataString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        NSLog(@"This1: %@", receivedData);
        NSLog(@"This2: %@", receivedDataString);
    } else {
        // Inform the user that the connection failed.
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [receivedData setLength:0];
    NSLog(@"This3: %@", receivedData);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
   
//    NSLog(@"This4: %@", receivedDataString);
//    NSData *data = [receivedDataString dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *jsonData = [receivedDataString dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *e;
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e]  ;
//    NSLog(@"This5: %@",dict);
//     NSLog(@"This54: %@", receivedDataString);
//    NSString *responseString = [request responseString];
  
//    NSString *jsonString = @"{\"id\":18,\"first_name\":\"Dwayne\",\"last_name\":\"Hicks\",\"email\":\"dwaynehicks@usssulaco.com\"}";
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
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSLog(@"json %d  %@",json.count,json);
                    NSLog(@"json array %d",wrapper.count);
                    for(int i = 0; i < wrapper.count;i++){
                        NSDictionary *avatars = [wrapper objectAtIndex:i];
                        NSLog(@"xxx : %@",avatars);
                        SearchResultItem *item= [[SearchResultItem alloc] initWithData:avatars];
//                        [searchResults addObject:item ];
                        NSString *title = [self removeAccent:item.name];
                        if ([title containsString:searhKey]) {
                            [arrs addObject:item];

                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [_tbSearch reloadData];
                        for(int i = 0; i < arrs.count;i++){
                            [searchResults addObject:[arrs objectAtIndex:i]];
                            NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:searchResults.count-1 inSection:0];
                            [_tbSearch beginUpdates];
                            [_tbSearch insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
                            [_tbSearch endUpdates];
                        
                        }
                        paramPage++;
                    });
                });
            }
           
        });
    });
}


-(NSString *)removeAccent:(NSString *)str{
    NSData *data = [str dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *newStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    return newStr;
}
@end
