//
//  FilmViewCell.m
//  phimb
//
//  Created by becauseyoulive1989 on 4/25/16.
//  Copyright © 2016 com.haiphone. All rights reserved.
//

#import "FilmViewCell.h"
#import "ImageUtils.h"
#import <UIImageView+WebCache.h>
@implementation FilmViewCell
-(void)awakeFromNib{
    [super awakeFromNib];
//    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    _indicator.hidesWhenStopped = YES;
//    _indicator.center = self.thumbnail.center;
//    _indicator.frame = self.thumbnail.frame;
//    [_indicator startAnimating];
    [self addSubview:_indicator];
    self.thumbnail.layer.cornerRadius = 5.0;
    self.thumbnail.layer.masksToBounds = YES;
}
-(void)setContentView:(SearchResultItem *)item{
    [_indicator startAnimating];
    self.lbTitle.text = item.name;
    [self.thumbnail setShowActivityIndicatorView:YES];
    [self.thumbnail setIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    - (void)setIndicatorStyle:(UIActivityIndicatorViewStyle)style;
    NSString *filename = [[item.img componentsSeparatedByString:@"/"] lastObject];
    if ([self exist:filename]) {
        NSString *path = [self filePath:filename];
        self.thumbnail.image = [UIImage imageWithContentsOfFile:path];
        [self.thumbnail setShowActivityIndicatorView:NO];
    }else{
    [self.thumbnail sd_setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:[UIImage new] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error && image) {
            self.thumbnail.image = image;
//            [_indicator stopAnimating];
            [self.thumbnail setShowActivityIndicatorView:NO];
            [self saveImaget:image filename:filename];
        }
    }];
    }

}

-(void)saveImaget:(UIImage *)newImage filename:(NSString *)filename{
    NSData *imageData =UIImageJPEGRepresentation(newImage, 1.0);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",filename]];
    
    NSLog((@"pre writing to file"));
    if (![imageData writeToFile:imagePath atomically:NO])
    {
        NSLog((@"Failed to cache image data to disk"));
    }
    else
    {
        NSLog(@"the cachedImagedPath is %@",imagePath);
    }
}

-(BOOL)exist:(NSString *)filename{
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* foofile = [documentsPath stringByAppendingPathComponent:filename];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
    return fileExists;
}
-(NSString *)filePath:(NSString *)filename{
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* foofile = [documentsPath stringByAppendingPathComponent:filename];
    return foofile;
}
@end
