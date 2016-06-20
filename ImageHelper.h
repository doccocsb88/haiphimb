//
//  ImageHelper.h
//  Plan-it Med
/**
 *Copyright (C) 2014 Neos CorporationAllRights　Reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageHelper : NSObject

+ (UIImage *)backgroundImageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
@end
