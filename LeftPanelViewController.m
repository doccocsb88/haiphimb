//
//  LeftPanelViewController.m
//  SlideoutNavigation
//
//  Created by Tammy Coron on 1/10/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//

#import "LeftPanelViewController.h"

#import "Genre.h"
//#import "SUCache.h"
#import "ColorSchemeHelper.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "LoginViewController.h"
#define LEFT_MENU_HEIGHT 35
@interface LeftPanelViewController (){
    NSIndexPath *_currentIndexPath;

}
@property (nonatomic,strong) UILabel *lbUserName;
@property (nonatomic, weak) IBOutlet UITableView *myTableView;
//@property (nonatomic, weak) IBOutlet UITableViewCell *cellMain;
@property (nonatomic,strong) UIButton *btnLogin;
@property (nonatomic, strong) NSMutableArray *arrayOfAnimals;
@property (weak, nonatomic) FBSDKProfilePictureView *profilePic;
@end

@implementation LeftPanelViewController

#pragma mark -
#pragma mark View Did Load/Unload

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess:)
                                                 name:FBSDKAccessTokenDidChangeNotification
                                               object:nil];
    _currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];

   
    [self setupAnimalsArray];
//    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
//                                  initWithGraphPath:@"/{user-id}/picture"
//                                  parameters:nil
//                                  HTTPMethod:@"GET"];
//    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
//                                          id result,
//                                          NSError *error) {
//        // Handle the result
//    }];
    [self initializeSubViews];
}
- (void)initializeSubViews {
  
    UIView *bgHeader= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64) ];
    bgHeader.backgroundColor = [ColorSchemeHelper sharedNationHeaderColor];
    [self.view addSubview:bgHeader];
    FBSDKProfilePictureView *profilePic = [[FBSDKProfilePictureView alloc]
                                           initWithFrame:CGRectMake(
                                                                    10 ,
                                                                    22,
                                                                    40,
                                                                    40)];
//    FBSDKProfile *profile= [[FBSDKProfile alloc] init];
//    NSLog(@"------+++++%@",profile.name);
   

    _lbUserName = [[UILabel alloc] initWithFrame:CGRectMake(50, 22, 200, 40) ];
    _lbUserName.text =@"";
    _lbUserName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lbUserName];
//    self.clipsToBounds = YES;
//    self.autoresizesSubviews = YES;
    profilePic.layer.cornerRadius = 20.f;
    profilePic.clipsToBounds = YES;
    [self.view addSubview:profilePic];
    if (![FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        _btnLogin  = [[UIButton alloc] initWithFrame:CGRectMake(10 ,
                                                                        22,
                                                                        40,
                                                                         40) ];
//        [_btnLogin setTitle:@"LOgin" forState:UIControlStateNormal];
        UIImageView *imgLogin =[ [UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_login.png"]];
        imgLogin.contentMode = UIViewContentModeScaleAspectFit;
        imgLogin.frame = CGRectMake(0, 0, 40, 40);
        [_btnLogin addSubview:imgLogin];
        [_btnLogin addTarget:self action:@selector(pressedLogin) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btnLogin];
        [profilePic setHidden:YES];

    }else{
        [profilePic setHidden:NO];
    }
    self.profilePic = profilePic;

}
- (void)viewDidUnload
{
    [super viewDidUnload];
   
}

#pragma mark -
#pragma mark View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
                 _lbUserName.text = result[@"name"];
             }
         }];
        [_btnLogin setHidden:YES];

    }

}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

#pragma mark -
#pragma mark View Will/Did Disappear

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
#pragma mark - Properties

- (NSString *)userID {
    return self.profilePic.profileID;
}

- (void)setUserID:(NSString *)userID {
    self.profilePic.profileID = userID;
}

#pragma mark -
#pragma mark Array Setup

- (void)setupAnimalsArray
{
    NSArray *genre =nil;
    NSArray *nations =nil;
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if (![language isEqualToString:@"vi"]) {
        nations = @[
                        [Genre itemWithTitle:@"Hong Kong Movies" withKey:@"hong-kong"],
                        [Genre itemWithTitle:@"Korea Movies" withKey:@"han-quoc"],
                        [Genre itemWithTitle:@"Viet Nam Movies" withKey:@"viet-nam"],
                        [Genre itemWithTitle:@"China Movies" withKey:@"trung-quoc"],
                        [Genre itemWithTitle:@"US-UK Movies" withKey:@"my-chau-au"],
                        [Genre itemWithTitle:@"Taiwan Movies" withKey:@"dai-loan"],
                        [Genre itemWithTitle:@"Thailand Movies" withKey:@"thai-lan"],
                        [Genre itemWithTitle:@"Japan Movies" withKey:@"nhat"],
                        [Genre itemWithTitle:@"Philippines Movies" withKey:@"philippines"]
                        ];
        genre= @[
                       [Genre itemWithTitle:@"Action Films" withKey:@"hanh-dong"],
                       [Genre itemWithTitle:@"Adventure Films" withKey:@"phieu-luu"],
                       [Genre itemWithTitle:@"Romance Films" withKey:@"tinh-cam"],
                       [Genre itemWithTitle:@"Drama Film" withKey:@"tam-ly"],
                       [Genre itemWithTitle:@"Kung fu Films" withKey:@"vo-thuat"],
                       [Genre itemWithTitle:@"Costume Drama Films" withKey:@"co-trang"],
                       [Genre itemWithTitle:@"Hài Hước" withKey:@"hai-huoc"],
                       [Genre itemWithTitle:@"Musical Films" withKey:@"ca-nhac"],
                       [Genre itemWithTitle:@"Comedy Films" withKey:@"hai-kich"],
                       [Genre itemWithTitle:@"Crime Films" withKey:@"hinh-su"],
                       [Genre itemWithTitle:@"Wars Films " withKey:@"chien-tranh"]];
    }else{
        nations = @[
                        [Genre itemWithTitle:@"Phim Hồng Kong" withKey:@"hong-kong"],
                        [Genre itemWithTitle:@"Phim Hàn Quốc" withKey:@"han-quoc"],
                        [Genre itemWithTitle:@"Phim Việt Nam" withKey:@"viet-nam"],
                        [Genre itemWithTitle:@"Phim Trung Quốc" withKey:@"trung-quoc"],
                        [Genre itemWithTitle:@"Phim Mỹ - Châu Âu" withKey:@"my-chau-au"],
                        [Genre itemWithTitle:@"Phim Đài Loan" withKey:@"dai-loan"],
                        [Genre itemWithTitle:@"Phim Thái Lan" withKey:@"thai-lan"],
                        [Genre itemWithTitle:@"Phim Nhật" withKey:@"nhat"],
                        [Genre itemWithTitle:@"Phim Philippines" withKey:@"philippines"]
                        ];
        genre = @[
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
    }

    if (_indexTagView==40) {
        self.arrayOfAnimals = [NSMutableArray arrayWithArray:genre];

    }else if(_indexTagView==44){
        self.arrayOfAnimals = [NSMutableArray arrayWithArray:nations];

    }else{
    
    }
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        NSLog(@"FBLogged ");
    }else{
        NSLog(@"FBLogged --->");
        
    }

    [self.myTableView reloadData];
}
#pragma mark -
-(void)loginSuccess:(NSNotification *)noti{
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
                 _lbUserName.text = result[@"name"];
             }
         }];
        [_btnLogin removeFromSuperview];
        [self.profilePic setHidden:NO];
    }

}
#pragma mark -
#pragma mark UITableView Datasource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrayOfAnimals count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LEFT_MENU_HEIGHT;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return LEFT_MENU_HEIGHT;
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
}

- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellMainNibID = @"cellMain";
    
   UITableViewCell *cellMain = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
    
//    UIImageView *mainImage = (UIImageView *)[_cellMain viewWithTag:1];
//    
//    UILabel *imageTitle = (UILabel *)[_cellMain viewWithTag:2];
//    UILabel *creator = (UILabel *)[_cellMain viewWithTag:3];
    if(cellMain==nil){
    
        cellMain = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellMainNibID];
    }
    if ([_arrayOfAnimals count] > 0)
    {
        Genre *currentRecord = [self.arrayOfAnimals objectAtIndex:indexPath.row];
        
        [cellMain.textLabel setText:currentRecord.title];
    }
    
    return cellMain;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Genre *currentRecord = [self.arrayOfAnimals objectAtIndex:indexPath.row];
    
    // Return Data to delegate: either way is fine, although passing back the object may be more efficient
    // [_delegate imageSelected:currentRecord.image withTitle:currentRecord.title withCreator:currentRecord.creator];
    // [_delegate animalSelected:currentRecord];
    [_delegate genreSelected:currentRecord];
//    [_delegate animalSelected:currentRecord];
}
#pragma mark -
#pragma mark Button Action
-(void)pressedLogin{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    LoginViewController *vc = (LoginViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:vc animated:YES completion:nil];

}
#pragma mark -
#pragma mark Default System Code

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
