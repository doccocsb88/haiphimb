//
//  HomeMenuViewController.m
//  phimb
//
//  Created by Apple on 6/10/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import "HomeMenuViewController.h"
#import "ColorSchemeHelper.h"
#import "SearchViewController.h"
#import "DTCustomColoredAccessory.h"
#import "HomeMenuViewCell.h"
#import "Genre.h"
#define HOME_MENU_HEIGHT 35
@interface HomeMenuViewController ()
{
    CGSize viewSize;
    NSMutableIndexSet *expandedSections;
    NSArray *genreDatas;
    NSArray *nationDatas;
}
@end

@implementation HomeMenuViewController
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor grayColor];
    [self initData];
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
        
    }
    viewSize = self.view.frame.size;
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    genreDatas = @[
                   [Genre itemWithTitle:@"Hành Động" withKey:@"hanh-dong"],
                   [Genre itemWithTitle:@"Phiêu Lưu" withKey:@"phieu-luu"],
                   [Genre itemWithTitle:@"Tình Cảm" withKey:@"tinh-cam"],
                   [Genre itemWithTitle:@"Tâm Lý" withKey:@"tam-ly"],
                   [Genre itemWithTitle:@"Võ Thuật" withKey:@"vo-thuat"],
                   [Genre itemWithTitle:@"Cổ trang" withKey:@"co-trang"],
                   [Genre itemWithTitle:@"Hài Hước" withKey:@"hai-huoc"],
                   [Genre itemWithTitle:@"Ca Nhạc" withKey:@"ca-nhac"],
                   [Genre itemWithTitle:@"Hài Kịch" withKey:@"hai-kich"],
                   [Genre itemWithTitle:@"Hình Sự" withKey:@"hinh-su"],
                   [Genre itemWithTitle:@"Chiến Tranh " withKey:@"chien-tranh"]];
    
    nationDatas = @[
                    [Genre itemWithTitle:@"Hong Kong Movies" withKey:@"hong-kong"],
                    [Genre itemWithTitle:@"Korea Movies" withKey:@"han-quoc"],
                    [Genre itemWithTitle:@"Viet Nam Movies" withKey:@"viet-nam"],
                    [Genre itemWithTitle:@"China Movies" withKey:@"trung-quoc"],
                    [Genre itemWithTitle:@"US-UK Movies" withKey:@"my-chau-au"],
                    [Genre itemWithTitle:@"Taiwan Movies" withKey:@"dai-loan"],
                    [Genre itemWithTitle:@"Thailan Movies" withKey:@"thai-lan"],
                    [Genre itemWithTitle:@"Japan Movies" withKey:@"nhat"],
                    [Genre itemWithTitle:@"Philippines Movies" withKey:@"philippines"]]
;

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)initViews{
    [self initHeader];
    [self initTableView];
}
-(void)initHeader{
    UIView *bgHeadr = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, 64)];
    bgHeadr.backgroundColor = [ColorSchemeHelper sharedNationHeaderColor];
    
    [self.view addSubview:bgHeadr];
    
    
}
-(void)initTableView{
    self.menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.menuTable.backgroundColor = [UIColor grayColor];
}
#pragma Mark Table
- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    if (section>0) return YES;
    
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self tableView:tableView canCollapseSection:section])
    {
        if ([expandedSections containsIndex:section])
        {
            if (section==1) {
                return  nationDatas.count +1;
            }else{
                return genreDatas.count +1; // return rows when expanded

            }
        }
        
        return 1; // only top row showing
    }
    
    // Return the number of rows in the section.
    return 4;
}

//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *simpleTableIdentifier = @"menu";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//    }
//    if(indexPath.section==0){
//        [self initFavoriteCell:cell atIndexPath:indexPath];
//    }else if(indexPath.section==1){
//        [self initGenreCell:cell atIndexPath:indexPath];
//    }else{
//        [self initConfigCell:cell atIndexPath:indexPath];
//    }
//
//    return cell;
//
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HOME_MENU_HEIGHT;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    HomeMenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HomeMenuViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier frame:CGSizeMake(viewSize.width-64, HOME_MENU_HEIGHT)];
    }
    
    // Configure the cell...
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            // first row
            if(indexPath.section==1){
            [cell SetContentView:@"Country" image:@"tabbaritem_nation.png" separate:YES];
            }else if(indexPath.section==2){
                [cell SetContentView:@"Genre" image:@"tabbaritem_video.png" separate:YES];

            }
            
            // only top row showing
//            UIImageView *expand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_expand_more.png"]];
//            expand.tag =113;
//            expand.frame = CGRectMake(200, 0, 30, 30);
//            [cell.contentView addSubview:expand];
            if ([expandedSections containsIndex:indexPath.section])
            {
                UIImage *accessoryImage = [UIImage imageNamed:@"ic_expand_more.png"];
                UIImageView *accImageView = [[UIImageView alloc] initWithImage:accessoryImage];
                accImageView.userInteractionEnabled = YES;
                [accImageView setFrame:CGRectMake(0, 0, 28.0, 28.0)];
//              accImageView setad
                cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeUp];
            }
            else
            {
                cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeDown];
            }
        }
        else
        {
            // all other rows
            Genre *genre =nil;
            if (indexPath.section==1) {
                genre = [nationDatas objectAtIndex:indexPath.row-1];

            }else if(indexPath.section==2){
                genre = [genreDatas objectAtIndex:indexPath.row-1];
            }
            [cell SetContentView:genre.title image:@"" separate:NO];
            
            cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else
    {
        cell.accessoryView = nil;
        if(indexPath.row==0){
            [cell SetContentView:@"Sign In" image:@"icon_menu_signin.png" separate:YES];

        }else if(indexPath.row==1){
            [cell SetContentView:@"History" image:@"icon_menu_history.png" separate:YES];

        }else if(indexPath.row==2){
            [cell SetContentView:@"Recent Viewed" image:@"icon_menu_recent.png" separate:YES];
            
        }else if(indexPath.row==3){
            [cell SetContentView:@"Home" image:@"icon_menu_home.png" separate:YES];

        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            // only first row toggles exapand/collapse
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSInteger section = indexPath.section;
            BOOL currentlyExpanded = [expandedSections containsIndex:section];
            NSInteger rows;
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            if (currentlyExpanded)
            {
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [expandedSections removeIndex:section];
                
            }
            else
            {
                [expandedSections addIndex:section];
                rows = [self tableView:tableView numberOfRowsInSection:section];
            }
            
            for (int i=1; i<rows; i++)
            {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                               inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            if (currentlyExpanded)
            {
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                
                cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeDown];
                
            }
            else
            {
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                cell.accessoryView =  [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeUp];
                
            }
        }else{
            [delegate didSelectMenu:indexPath.row-1 type:indexPath.section];
        }

    }else{
        //do not canCollapseSection
        NSLog(@"tabBar changedView");
        [delegate didSelectMenu:indexPath.row];
        
    }
}
//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSInteger section = indexPath.section;
//    switch (section) {
//        case 0:{
//            UserDataViewController *vc = [[UserDataViewController alloc] init];
//            vc.myValue = 10;
//            [self presentViewController:vc animated:YES completion:nil];
//            }
//            break;
//        case 1:
////            NSLog(@"clickclick %d",indexPath.row);
////            if (indexPath.row==0) {
////                int controllerIndex = 1;
////                
////                UITabBarController *tabBarController = self.tabBarController;
////                UIView * fromView = tabBarController.selectedViewController.view;
////                UIView * toView = [[tabBarController.viewControllers objectAtIndex:controllerIndex] view];
////                
////                // Transition using a page curl.
////                [UIView transitionFromView:fromView
////                                    toView:toView
////                                  duration:0.5
////                                   options:(controllerIndex > tabBarController.selectedIndex ? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown)
////                                completion:^(BOOL finished) {
////                                    if (finished) {
////                                        tabBarController.selectedIndex = controllerIndex;
////                                    }
////                                }];
////            
////            
////            
////            }else if(indexPath.row==1){
////                [self.tabBarController setSelectedIndex:2];
//////                SearchViewController *vc = [[SearchViewController alloc] init];
//////                [self.tabBarController setSelectedViewController:vc];
////            }else if(indexPath.row==2){
////                SearchViewController *vc = [[SearchViewController alloc] init];
////                [self.tabBarController setSelectedViewController:vc];
////            }
//            break;
//        case 2:
//            break;
//        default:
//            break;
//    }
//
//}
-(void)initFavoriteCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        cell.textLabel.text = @"Phim yeu thich";
    }else if(indexPath.row==1){
        cell.textLabel.text = @"Phim da xem";

    }
}
-(void)initGenreCell:(UITableViewCell *)cell  atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        cell.textLabel.text = @"The loai";
    }else if(indexPath.row==1){
        cell.textLabel.text = @"Quoc gia";
        
    }else if(indexPath.row==2){
        cell.textLabel.text = @"Phim bo";
        
    }

}
-(void)initConfigCell:(UITableViewCell *)cell  atIndexPath:(NSIndexPath *)indexPath{

    [cell.textLabel setText:@"xxx"];
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}

//-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    
//    NSArray *tabViewControllers = tabBarController.viewControllers;
//    UIView * fromView = tabBarController.selectedViewController.view;
//    UIView * toView = viewController.view;
//    if (fromView == toView)
//        return false;
//    NSUInteger fromIndex = [tabViewControllers indexOfObject:tabBarController.selectedViewController];
//    NSUInteger toIndex = [tabViewControllers indexOfObject:viewController];
//    
//    [UIView transitionFromView:fromView
//                        toView:toView
//                      duration:0.3
//                       options: toIndex > fromIndex ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight
//                    completion:^(BOOL finished) {
//                        if (finished) {
//                            tabBarController.selectedIndex = toIndex;
//                        }
//                    }];
//    return true;
//}
@end
