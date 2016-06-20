//
//  PlayVideoViewController.h
//  SlideMenu
//
//  Created by Apple on 5/30/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TabCommentView.h"
#import "SearchResultItem.h"
#import "UIDevice-Hardware.h"
#import "GUIPlayerView.h"
#define TAB_INFO 1
#define TAB_RELATIVE 2
#define TAB_COMMENT 3
//@protocol PlayVideoViewDelegate <NSObject>
//-(void)playVideoAtIndex : (NSInteger )index;
//@end
@protocol PlayMovieControllerDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelLeft:(NSString *)cate;

- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;
@end

@interface PlayVideoViewController : UIViewController <NSURLConnectionDataDelegate,UITextFieldDelegate,CommentViewDelegate>
//@property (nonatomic, weak) id<PlayVideoViewDelegate> playvideoDelegate;

@property (strong,nonatomic) id<PlayMovieControllerDelegate> playDelegate;
@property (strong, nonatomic) SearchResultItem *filmInfo;
//
@property (nonatomic) NSInteger currentTab;
@property (strong, nonatomic) UIButton *btnTabInfo;
@property (strong, nonatomic) UIButton *btnTabComment;
@property (strong, nonatomic) UIButton *btnTabRelative;
@property (strong, nonatomic) UIImageView *previewImage;
@property (strong, nonatomic) UIButton *btnPlay;
@property (strong, nonatomic) UIButton *btnBack;
@property (strong, nonatomic) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *rightButton;

-(id)initWithInfo : (SearchResultItem *)info;
- (void)callWebService;
-(void)prepareFilmData:(SearchResultItem *)item;
-(void)scaleViewToOriginalSize;

@end
