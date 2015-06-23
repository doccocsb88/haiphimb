//
//  HomeMenuViewController.h
//  phimb
//
//  Created by Apple on 6/10/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDataViewController.h"
@protocol HomeMenuViewDelegate <NSObject>
@required
-(void)didSelectMenu:(NSInteger)index;
-(void)didSelectMenu:(NSInteger)index type:(NSInteger)type;
@end
@interface HomeMenuViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITabBarControllerDelegate>
@property (strong,nonatomic) id<HomeMenuViewDelegate> delegate;
@property (weak,nonatomic) IBOutlet UITableView *menuTable;
@end
