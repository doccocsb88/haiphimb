//
//  UserDataViewController.m
//  phimb
//
//  Created by Apple on 6/10/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import "UserDataViewController.h"
#import "ColorSchemeHelper.h"
#import "FilmInfoDetails.h"
#import "UserDataViewCell.h"
#import "UserDataFilm.h"
#import "PlayVideoViewController.h"
#define DATA_TYPE_RECENT 1
#define DATA_TYPE_HISTORY 2
@interface UserDataViewController () <RequestImageDelegate>
{
    CGSize viewSize;
}
@end

@implementation UserDataViewController
@synthesize userdataTable;
@synthesize employeeDbUtil;
@synthesize employeeList;
@synthesize delegate;
@synthesize dataType;
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        viewSize = frame.size;
        // Do any additional setup after loading the view.
        // Custom initialization
        self.employeeDbUtil = [[EmployeeDbUtil alloc] init];
        [employeeDbUtil initDatabase];
        [self initData];
        [self initViews];
    }
    return self;
}
- (id)init {
    self = [super init];
    if(self){
    dataType = DATA_TYPE_HISTORY;
    viewSize = self.frame.size;
    // Do any additional setup after loading the view.
    // Custom initialization
    self.employeeDbUtil = [[EmployeeDbUtil alloc] init];
    [employeeDbUtil initDatabase];
    [self initData];
    [self initViews];
    }
    return self;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//save the employee information

-(void)saveUserData:(id)sender{
    UserDataFilm *data = [[UserDataFilm alloc] init];
    FilmInfoDetails *info = [[FilmInfoDetails alloc] init];
    info._id = rand();
    info.name = @"a";
    info.subname = @"b";
    info.img =@"a";
    info.img_landscpae = @"a";
    info.cate =@"a";
    info.country =@"a";
    info.total = 122;
    info.star =@"star";
    info.director = @"d";
    info.desc = @"desc";
    
    data.info = info;
    data.type = 1;
    data.date =@"10-06-2015";
    BOOL rs =[employeeDbUtil saveFilmUserData:data];
    NSLog(@"insertResult : %d",rs);
}
-(void)initData{
//    userData = [[NSMutableArray alloc] init];
//    for(int i = 0; i < 10; i ++){
//        [userData addObject:@"abc"];
//    }
    if(dataType==DATA_TYPE_HISTORY){
        employeeList = [employeeDbUtil getUserDatas];
    }else if(dataType == DATA_TYPE_RECENT){
        employeeList = [employeeDbUtil getRecentViewed];

    }
   // [[UserDataManager sharedInstance]initDatabase];
   // NSLog(@"count+++++ : %d",[[DBManager getSharedInstance] checkTableExist]);
}
-(void)initViews{
    //[self initHeader];
    [self initTableView];
}
-(void)refreshHistoryData{
    [employeeList removeAllObjects];
    if(dataType==DATA_TYPE_HISTORY){
        employeeList = [employeeDbUtil getUserDatas];
    }else if(dataType == DATA_TYPE_RECENT){
        employeeList = [employeeDbUtil getRecentViewed];
        
    }
    [userdataTable reloadData];
}
-(void)initHeader{
    UIView *bgHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 64, viewSize.width, 64)];
    bgHeader.backgroundColor = [ColorSchemeHelper sharedNationHeaderColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 40, 44)];
    [btn setTitle:@"add" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveEmployee:) forControlEvents:UIControlEventTouchUpInside];
    [bgHeader addSubview:btn];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(viewSize.width - 50, 20, 40, 44)];
    [btn2 setTitle:@"add2" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(saveUserData:) forControlEvents:UIControlEventTouchUpInside];
    [bgHeader addSubview:btn2];
    [self addSubview:bgHeader];
    

}
-(void)initTableView{
    userdataTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    userdataTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    userdataTable.delegate = self;
    userdataTable.dataSource = self;

    [self addSubview:userdataTable];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80.f;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"---><-----%d",employeeList.count);
    return     employeeList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifis = @"user";
    UserDataViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifis];
    if(cell==nil){
      cell = [[UserDataViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifis frame:CGRectMake(0, 0, viewSize.width, 80.f)];
//        cell = [UITableViewCell alloc] initw
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UserDataFilm *data = [employeeList objectAtIndex:indexPath.row];
    [cell setContent:data atIndex:indexPath.row];
    return cell;
    

}
//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserDataFilm *data =[employeeList objectAtIndex:indexPath.row];
    [delegate playHistoryMovie:data.info._id];
}
-(void)setImageAtIndex:(NSInteger)index image:(UIImage *)img{
    if(index < employeeList.count){
        UserDataFilm *item = [employeeList objectAtIndex:index];
        item.thumb= img;
        [employeeList replaceObjectAtIndex:index withObject:item];
        SearchResultItem *new = [employeeList objectAtIndex:index];
        NSLog(@"setContentForFilmCell %d : %d",index,new.hasData);
    }

}
@end
