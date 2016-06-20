//
//  FilmViewController.h
//  phimb
//
//  Created by becauseyoulive1989 on 4/25/16.
//  Copyright © 2016 com.haiphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultItem.h"
#import "Genre.h"
@protocol FilmViewDelegate <NSObject>
-(void)pressedItemAtIndex:(SearchResultItem *)item;
@end
@interface FilmViewController : UIViewController
@property (strong, nonatomic) Genre *genre;
@property (strong, nonatomic) id<FilmViewDelegate>delegate;
-(instancetype) initWithGenreKey:(Genre *)genre;
-(void)callWebservide:(Genre *)genre;
-(void)resetListFilm:(Genre *)genre;
@end
