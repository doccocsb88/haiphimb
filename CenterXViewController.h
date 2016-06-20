//
//  CenterXViewController.h
//  Navigation
//
//  Created by Tammy Coron on 1/19/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//

#import "LeftPanelViewController.h"
#import "RightPanelViewController.h"
#import "ListFilmCell.h"

@protocol CenterXViewControllerDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;

@end

@interface CenterXViewController : UIViewController <LeftPanelViewControllerDelegate, RightPanelViewControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,NSURLConnectionDataDelegate,RequestImageDelegate>


@property (nonatomic, assign) id<CenterXViewControllerDelegate> delegate;
@property (assign,nonatomic) NSInteger indexTagView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIView *bgHeader;
@property (weak, nonatomic) IBOutlet UILabel *lbTitleView;
@property (weak,nonatomic)  IBOutlet UICollectionView *listFilm;
- (id)initWithTag : (NSInteger )tag;
- (void)callWebService;
- (void)loadListFilm:(NSInteger)index;
@end
