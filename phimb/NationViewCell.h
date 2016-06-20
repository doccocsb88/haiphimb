//
//  NationViewCell.h
//  phimb
//
//  Created by becauseyoulive1989 on 4/25/16.
//  Copyright © 2016 com.haiphone. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NationFilmCellDelegate <NSObject>
-(void)pressedViewMore:(NSInteger)index;
@end
@interface NationViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnViewMore;
@property (weak, nonatomic) IBOutlet UICollectionView *clFilm;
@property (strong, nonatomic) id<NationFilmCellDelegate>delegate;
-(void)setcontentView:(NSString *)header jsonData:(NSString *)json atIndex:(NSInteger)index;
-(void)setcontentView:(NSString *)header nationCode:(NSString *)nationCode complete:(void(^)(NSString *json))complete atIndex:(NSInteger)index;

@end
