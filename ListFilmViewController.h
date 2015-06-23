//
//  ListFilmViewController.h
//  SlideMenu
//
//  Created by Apple on 5/30/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListFilmViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,NSURLConnectionDataDelegate>
@property (strong,nonatomic) UICollectionView *listFilm;
- (void)callWebService;

@end
