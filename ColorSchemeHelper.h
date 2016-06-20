//
//  ColorSchemeHelper.h
//  Kaomoji
/**
 *Copyright (C) 2014 Neos CorporationAllRights　Reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ColorSchemeHelper : NSObject

//Conmon
+ (UIColor *)sharedBaseBackgroundColor;                         //Background color of most of pages
+ (UIColor *)sharedSelectedCellColor;                         //Background color of most of selected cell of tableview

+ (UIColor *)sharedNormalCellColor;                         //Background color of most of normal cell of tableview

+ (UIColor *)sharedSelectedTabarItemColor;                         //Background color of most of selected item of tabbarview

+ (UIColor *)sharedNormalTabarItemColor;                         //Background color of most of normal item of tabbarview

+ (UIColor *)sharedSeparatorColor;                         //Background color of most of Separator of cell of tabbarview

+ (UIColor *)sharedCloseButtonColor;
+ (UIColor *)sharedMovieInfoTitleColor;
+ (UIColor *)sharedNationHeaderColor;
+ (UIColor *)sharedGenreHeaderColor;
+ (UIColor *)sharedSearchHeaderColor;
+ (UIColor *)sharedTabTextColor;
+ (UIColor *)sharedThumbnailBorderColor;
+ (UIColor *)sharedHistoryBgCellColor;
@end
