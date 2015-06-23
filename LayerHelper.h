//
//  LayerHelper.h
//  Plan-it Med
/**
 *Copyright (C) 2014 Neos CorporationAllRights　Reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LayerHelper : NSObject

//
+ (void)configureLayer:(CALayer *)layer withCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

//Configure layer with radius and without border
+ (void)configureLayerWithoutBorder:(CALayer *)layer withCornerRadius:(CGFloat)radius;

//Configure layer with default radius and border width, border color
+ (void)configureDefaultLayer:(CALayer *)layer withBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

//Configure layer with default radius and without border
+ (void)configureDefaultLayerWithoutBorder:(CALayer *)layer;

//Configure layer with default radius, default border width and border color
+ (void)configureDefaultLayer:(CALayer *)layer withBorderColor:(UIColor *)borderColor;

//Configure layer with default border width and with radius, border color
+ (void)configureDefaultLayer:(CALayer *)layer withCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor;

//Configure layer with many features
+ (void)configureLayer:(CALayer *)layer withCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity;

@end
