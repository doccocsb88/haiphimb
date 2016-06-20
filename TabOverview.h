//
//  TabOverview.h
//  SlideMenu
//
//  Created by Apple on 6/2/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabOverview : UIView
@property (strong,nonatomic) UILabel *title;
@property (strong,nonatomic) UILabel *movieName;
@property (strong,nonatomic) UILabel *movieDescription;
-(id)initWithInfo:(NSString *)name descriotion:(NSString *)desc frame : (CGRect)frame;
-(void)bindDataToView : (NSString *)name desc : (NSString *)desc;
@end
