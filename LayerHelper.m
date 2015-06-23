//
//  LayerHelper.m
//  Plan-it Med
/**
 *Copyright (C) 2014 Neos CorporationAllRights　Reserved.
 */

#import "LayerHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "ColorSchemeHelper.h"

#define DEFAULT_RADIUS 5.0
#define DEFAULT_BORDER_WIDTH 1.0

@implementation LayerHelper

+ (void)configureLayer:(CALayer *)layer withCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:radius];
    [layer setBorderWidth:borderWidth];
    [layer setBorderColor:borderColor.CGColor];
}

+ (void)configureLayer:(CALayer *)layer withCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity
{
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:radius];
    [layer setBorderWidth:borderWidth];
    [layer setBorderColor:borderColor.CGColor];
    [layer setShadowColor:shadowColor.CGColor];
    [layer setShadowOffset:shadowOffset];
    [layer setShadowOpacity:shadowOpacity];
    layer.masksToBounds = NO;
}


+ (void)configureLayerWithoutBorder:(CALayer *)layer withCornerRadius:(CGFloat)radius
{
    [self configureLayer:layer withCornerRadius:radius borderWidth:0.0 borderColor:nil];
}

+ (void)configureDefaultLayerWithoutBorder:(CALayer *)layer
{
    [self configureLayer:layer withCornerRadius:DEFAULT_RADIUS borderWidth:0.0 borderColor:nil];
}

+ (void)configureDefaultLayer:(CALayer *)layer withBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    [self configureLayer:layer withCornerRadius:DEFAULT_RADIUS borderWidth:borderWidth borderColor:borderColor];
}

+ (void)configureDefaultLayer:(CALayer *)layer withBorderColor:(UIColor *)borderColor
{
    [self configureLayer:layer withCornerRadius:DEFAULT_RADIUS borderWidth:DEFAULT_BORDER_WIDTH borderColor:borderColor];
}


+ (void)configureDefaultLayer:(CALayer *)layer withCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor
{
    [self configureLayer:layer withCornerRadius:radius borderWidth:DEFAULT_BORDER_WIDTH borderColor:borderColor];
}

@end
