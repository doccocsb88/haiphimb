//
//  ListFilmSingleViewController.h
//  SlideMenu
//
//  Created by Apple on 6/2/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayVideoViewController.h"


@interface ListFilmSingleViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,NSURLConnectionDataDelegate>
@property (strong,nonatomic) UICollectionView *listFilm;
- (void)callWebService;
@property (strong,nonatomic) PlayVideoViewController *playvideoController;

@end
