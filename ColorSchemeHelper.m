//
//  ColorSchemeHelper.m
//  Kaomoji
/**
 *Copyright (C) 2014 Neos CorporationAllRights　Reserved.
 */

#import "ColorSchemeHelper.h"

@implementation ColorSchemeHelper


#pragma mark - Common Color
+ (UIColor *)sharedBaseBackgroundColor
{
    static UIColor *_color = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _color = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    });
    
    return _color;
}

+ (UIColor *)sharedSelectedCellColor {
    static UIColor *_color = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _color = [UIColor colorWithRed:114.0/255.0 green:196.0/255.0 blue:183.0/255.0 alpha:1];
    });
    
    return _color;

}

+ (UIColor *)sharedNormalCellColor {
    return [self sharedBaseBackgroundColor];
}

+ (UIColor *)sharedSelectedTabarItemColor {
    static UIColor *_color = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _color = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:120/255.0 alpha:1];
    });
    
    return _color;
    
}

+ (UIColor *)sharedNormalTabarItemColor {
    static UIColor *_color = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _color = [UIColor colorWithRed:254/255.0 green:147/255.0 blue:157/255.0 alpha:1];
    });
    
    return _color;
    
}

+ (UIColor *)sharedSeparatorColor {
    static UIColor *_color = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _color = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    });
    
    return _color;
    
}

+ (UIColor *)sharedCloseButtonColor
{
    static UIColor *_color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _color = [UIColor colorWithRed:0x54 / 255.0 green:0x6c / 255.0 blue:0x7c / 255.0 alpha:1];
    });
    return _color;
}
+(UIColor *)sharedMovieInfoTitleColor{
    static UIColor *_color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _color = [UIColor colorWithRed:210 / 255.0 green:18 / 255.0 blue:18 / 255.0 alpha:1];
    });
    return _color;
}
+(UIColor *)sharedNationHeaderColor{
    //255	153	102

    //209	2	38
    static UIColor *_color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _color = [UIColor colorWithRed:209 / 255.0 green:2 / 255.0 blue:38 / 255.0 alpha:1];
    });
    return _color;
}
+(UIColor *)sharedGenreHeaderColor{
    //76	45	30

    static UIColor *_color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _color = [UIColor colorWithRed:209 / 255.0 green:2 / 255.0 blue:38 / 255.0 alpha:1];
    });
    return _color;

}
+(UIColor *)sharedSearchHeaderColor{
    static UIColor *_color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _color = [UIColor colorWithRed:210 / 255.0 green:18 / 255.0 blue:18 / 255.0 alpha:1];
    });
    return _color;
}
+(UIColor *) sharedTabTextColor{
//30	62	74
    static UIColor *_color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _color = [UIColor colorWithRed:30 / 255.0 green:62 / 255.0 blue:74 / 255.0 alpha:1];
    });
    return _color;

}
+(UIColor *)sharedThumbnailBorderColor{
    //#d7dee1 215	222	225

    static UIColor *_color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _color = [UIColor colorWithRed:215 / 255.0 green:222 / 255.0 blue:255 / 255.0 alpha:1];
    });
    return _color;
}
+(UIColor *)sharedHistoryBgCellColor{
    static UIColor *_color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _color = [UIColor colorWithRed:227 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1];
    });
    return _color;
}
+(UIColor *)sharedFlashColor{
    //245	223	194

    static UIColor *_color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _color = [UIColor colorWithRed:245 / 255.0 green:223 / 255.0 blue:194 / 255.0 alpha:1];
    });
    return _color;
}
@end
