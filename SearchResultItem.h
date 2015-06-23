//
//  SearchResultItem.h
//  SlideMenu
//
//  Created by Apple on 6/1/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SearchResultItem : NSObject
@property(nonatomic) NSInteger _id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *subname;
@property (strong,nonatomic) NSString *img;
@property (strong,nonatomic) NSString *imglanscape;
@property (strong,nonatomic) NSString *status;
@property (strong, nonatomic) UIImage *thumbnail;

@property (assign, nonatomic) NSInteger total;
@property (assign, nonatomic) NSInteger current;
@property (nonatomic,assign) BOOL hasData;
-(id)initWithData: (NSDictionary *)data;
@end
