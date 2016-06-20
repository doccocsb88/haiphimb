//
//  MainPlayMoViewController.h
//  phimb
//
//  Created by Apple on 6/7/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultItem.h"
@interface MainPlayMoViewController : UIViewController
-(id)initWithFilmData:(SearchResultItem *)data;
-(void)prepareFilmData:(SearchResultItem *)data;
@end
