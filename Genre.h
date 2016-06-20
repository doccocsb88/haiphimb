//
//  Genre.h
//  SlideMenu
//
//  Created by Apple on 6/2/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Genre : NSObject

+ (id)itemWithTitle:(NSString *)title  withKey:(NSString *)creator;
- (id)initWithTitle:(NSString *)title  withKey:(NSString *)creator;
@property (nonatomic, copy) NSString *title;
//@property (nonatomic, copy) UIImage  *image;
@property (nonatomic, copy) NSString *key;
@end
