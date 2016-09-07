//
//  FilmHomeViewController.h
//  SlideMenu
//
//  Created by Apple on 5/29/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SlideNavigationController.h"
#import "FilmCollectionViewCell.h"
#import "HomeMenuViewController.h"
@protocol HomeControllerDelegate <NSObject>

@optional
- (void)movePanelLeft;
//- (void)movePanelLeft:(NSString *)cate;

- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;
@end
@interface FilmHomeViewController : UIViewController <HomeFilmDelegate,HomeMenuViewDelegate,NSURLConnectionDataDelegate,HistoryDelegate>

@property(strong,nonatomic) id<HomeControllerDelegate> homeDelegate;
@property (nonatomic,strong) UIButton *homeMenu;
@property (nonatomic,strong) UILabel *homeTitle;
@property (nonatomic) CGFloat sliderHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet UICollectionView *filmCollectionView;
@end
