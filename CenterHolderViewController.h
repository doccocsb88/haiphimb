//
//  CenterHolderViewController.h
//  phimb
//
//  Created by Apple on 6/16/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import <UIKit/UIKit.h>

//@interface CenterHolderViewController : UIViewController
#import "LeftPanelViewController.h"
#import "RightPanelViewController.h"
#import "ListFilmCell.h"

@protocol CenterHolderDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;

@end

@interface CenterHolderViewController : UIViewController <LeftPanelViewControllerDelegate, RightPanelViewControllerDelegate,NSURLConnectionDataDelegate,RequestImageDelegate>

{
    UIButton *_leftButton;
    UIButton *_rightButton;
    id<CenterHolderDelegate> _delegate;
    NSInteger _indexTagView;


}
//@property (nonatomic, strong) UIButton *leftButton;
//@property (nonatomic, strong) UIButton *rightButton;
- (id)initWithTag : (NSInteger )tag;
-(void)initHeader;
- (void)callWebService;
- (void)loadListFilm:(NSInteger)index;
-(void)setDelegate:(id<CenterHolderDelegate>) delegate;
-(void)setLeftButtonTag:(int)tag;
-(void)setRightButtonTag:(int)tag;
-(void)btnMovePanelRight:(id)sender;
@end
