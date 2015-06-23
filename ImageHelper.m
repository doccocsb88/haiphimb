//
//  ImageHelper.m
//  Plan-it Med
/**
 *Copyright (C) 2014 Neos CorporationAllRights　Reserved.
 */

#import "ImageHelper.h"
#import "ColorSchemeHelper.h"

@interface ImageHelper()

@end

@implementation ImageHelper

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    if (size.width == 0.0 || size.height == 0.0) {
        //MyLog(@"imageWithColor can't not passed height or width is equal 0, default = 1");
        size.width = 1.0;
        size.height = 1.0;
    }
    UIImage *image = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)backgroundImageWithColor:(UIColor *)color
{
    CGSize size = CGSizeMake(1.0, 1.0);
    UIImage *image = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


@end
