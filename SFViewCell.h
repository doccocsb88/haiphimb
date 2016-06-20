//
//  SFViewCell.h
//  SlideMenu
//
//  Created by Apple on 5/31/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFViewCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *ftitle;
-(void)updateTitle: (NSString *)title;
@end
