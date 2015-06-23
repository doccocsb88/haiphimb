//
//  SearchViewController.h
//  SlideMenu
//
//  Created by Apple on 5/31/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultViewCell.h"
#import "PlayVideoViewController.h"
@interface SearchViewController : UIViewController <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,SearchCellImgDelegate,NSURLConnectionDataDelegate>
@property (strong, nonatomic) PlayVideoViewController *playvideoController;
@property (strong, nonatomic) UITableView *tbSearch;
@property (strong,nonatomic) UISearchBar *search;
@property (strong, nonatomic) UIButton *btnCancel;
@end
