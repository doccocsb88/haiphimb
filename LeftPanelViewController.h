//
//  LeftPanelViewController.h
//  SlideoutNavigation
//
//  Created by Tammy Coron on 1/10/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Genre.h"

@protocol LeftPanelViewControllerDelegate <NSObject>

@optional
- (void)imageSelected:(UIImage *)image withTitle:(NSString *)imageTitle withCreator:(NSString *)imageCreator;

@required
- (void)animalSelected:(Genre *)animal;
- (void)genreSelected:(Genre *)genre;
@end

@interface LeftPanelViewController : UIViewController
@property (assign,nonatomic) NSInteger indexTagView;
@property (nonatomic, assign) id<LeftPanelViewControllerDelegate> delegate;

@end