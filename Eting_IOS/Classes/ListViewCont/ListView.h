//
//  ListView.h
//  Eting_IOS
//
//  Created by Rangken on 2014. 1. 1..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@interface ListView : BaseView < UITableViewDelegate, UITableViewDataSource >
{
   
}
@property (strong, nonatomic) NSMutableArray* storyArr;
@property (strong, nonatomic) NSMutableDictionary* storyDic;
@property (assign, nonatomic) int addCellCnt;
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet UIImageView* emptyStarImgView;
@property (weak, nonatomic) IBOutlet UILabel* emptyLabel;
- (void)refreshView;
- (void)goToEtingContentView:(NSString*)storyId;
- (void)etingClick:(NSInteger)section :(NSInteger)row;
@end
