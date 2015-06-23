//
//  ImageUtils.h
//  phimb
//
//  Created by Apple on 6/14/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageUtils : NSObject
+(UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point;
@end
