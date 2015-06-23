//
//  ImageUtils.m
//  phimb
//
//  Created by Apple on 6/14/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import "ImageUtils.h"

@implementation ImageUtils
+(UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point
{
    
    UIFont *font = [UIFont boldSystemFontOfSize:30];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    [[UIColor whiteColor] set];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,
                                [UIColor redColor], NSForegroundColorAttributeName, nil];
    CGSize textSize = [text sizeWithAttributes:attributes];
    
    CGFloat strikeWidth = textSize.width;
    CGRect rect = CGRectMake(image.size.width/2 - strikeWidth/2, image.size.height/3, image.size.width, image.size.height);
    CGRect rect2 = CGRectMake(image.size.width/2 - strikeWidth/2, image.size.height/2, image.size.width, image.size.height);

    CGRect rect3 = CGRectMake(image.size.width/2 - strikeWidth/2, image.size.height*2/3, image.size.width, image.size.height);
    [text drawInRect:CGRectIntegral(rect) withAttributes:attributes];
    [text drawInRect:CGRectIntegral(rect2) withAttributes:attributes];
    [text drawInRect:CGRectIntegral(rect3) withAttributes:attributes];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
