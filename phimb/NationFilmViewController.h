//
//  NationFilmViewController.h
//  phimb
//
//  Created by becauseyoulive1989 on 4/25/16.
//  Copyright © 2016 com.haiphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftPanelViewController.h"
#import "RightPanelViewController.h"
#import "ListFilmCell.h"
@protocol NationFilmDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;

@end

@interface NationFilmViewController : UIViewController <LeftPanelViewControllerDelegate, RightPanelViewControllerDelegate,NSURLConnectionDataDelegate,RequestImageDelegate>


@property (nonatomic, assign) id<NationFilmDelegate> delegate;
@property (assign,nonatomic) NSInteger indexTagView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
- (id)initWithTag : (NSInteger )tag;
- (void)callWebService;
- (void)loadListFilm:(NSInteger)index;@end
