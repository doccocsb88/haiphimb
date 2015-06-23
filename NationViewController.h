//
//  NationViewController.h
//  phimb
//
//  Created by Apple on 6/16/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterHolderViewController.h"
#import "PlayVideoViewController.h"
#import "FilmCollectionViewCell.h"
#import "NationDetailViewController.h"

@interface NationViewController : CenterHolderViewController <UITableViewDataSource,UITableViewDelegate,HomeFilmDelegate,NationDetailDelegate>
//@property (assign,nonatomic) NSInteger indexTagView;
//@property (nonatomic, strong) UIButton *leftButton;
//@property (nonatomic, strong) UIButton *rightButton;
@property (strong,nonatomic) PlayVideoViewController *playvideoController;
@property (strong,nonatomic) UITableView *nationfilms;
@end
