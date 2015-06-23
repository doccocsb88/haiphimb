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
#import "CenterHolderViewController.h"
#import "PlayVideoViewController.h"
//@protocol CenterXViewControllerDelegate <NSObject>
//
//@optional
//- (void)movePanelLeft;
//- (void)movePanelRight;

//@required
//- (void)movePanelToOriginalPosition;
//
//@end

@interface CenterXViewController : CenterHolderViewController <UICollectionViewDataSource,UICollectionViewDelegate>


//@property (nonatomic, assign) id<CenterXViewControllerDelegate> delegate;
//@property (assign,nonatomic) NSInteger indexTagView;
//@property (nonatomic, strong) UIButton *leftButton;
//@property (nonatomic, strong) UIButton *rightButton;
@property (strong,nonatomic) PlayVideoViewController *playvideoController;
@property (strong,nonatomic) UICollectionView *listFilm;
//- (id)initWithTag : (NSInteger )tag;
//- (void)callWebService;
//- (void)loadListFilm:(NSInteger)index;
@end
