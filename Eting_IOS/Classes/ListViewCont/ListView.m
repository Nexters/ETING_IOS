//
//  ListView.m
//  Eting_IOS
//
//  Created by Rangken on 2014. 1. 1..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "ListView.h"
#import "ListCell.h"
#import "ListDataCell.h"
#import "StoryManager.h"
#import "MainViewController.h"
#import "ContentViewController.h"
@implementation ListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)initVariable{
    _addCellCnt = 0;
    _storyArr = [[StoryManager sharedSingleton] getStorys];
    _storyDic = [[StoryManager sharedSingleton] getStoryDictionary];
    if (_storyDic == NULL || [_storyDic count] == 0) {
        _emptyLabel.hidden = FALSE;
        _emptyStarImgView.hidden = FALSE;
    }
    [_tableView setAllowsSelection:YES];
    [_tableView reloadData];
}
- (void)refreshView{
    //NSMutableArray* nowStoryArray = [[StoryManager sharedSingleton] getStorys];
    
    NSMutableDictionary* newStoryDic = [[StoryManager sharedSingleton] getStoryDictionary];
    _storyDic = newStoryDic;
    _storyArr = [[StoryManager sharedSingleton] getStorys];
    [_tableView reloadData];
    
    if ([_storyDic count] != 0) {
        _emptyLabel.hidden = TRUE;
        _emptyStarImgView.hidden = TRUE;
    }else{
        _emptyLabel.hidden = FALSE;
        _emptyStarImgView.hidden = FALSE;
    }    
}
#pragma mark BaseViewDelegate
- (void)viewDidSlide{
    [self refreshView];
    [self.parentViewCont.writeView.textView resignFirstResponder];
}

- (void)viewUnSilde{
}

- (void)etingClick:(NSInteger)section :(NSInteger)row{
    NSArray* keys = [_storyDic allKeys];
    NSString* key = [keys objectAtIndex:section];
    NSMutableArray* arr = [_storyDic objectForKey:key];
    NSDictionary* dic = [arr objectAtIndex:row-1];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ContentViewController* viewCont = [storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
    //viewCont.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    //UIViewController* viewCont = [[UIViewController alloc] init];
    viewCont.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    viewCont.storyDic = dic;
    viewCont.parent = self;
    NSNumber* num = [dic objectForKey:@"ColorIdx"];
    NSInteger idx = 1;
    if (num) {
        idx = [num integerValue];
    }
    viewCont.idx = idx;
    [self.parentViewCont presentViewController:viewCont animated:YES completion:nil];
}
#pragma mark UITableViewDelegate UITableViewDataSource
/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 20;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    int height = 0;
    if (section == 0) {
        height = 0;
    }else{
        height = 10;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    int height = 0;
    if (section == 0) {
        height = 0;
    }else{
        height = 10;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 36;
    }
    return 71;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray* keys = [_storyDic allKeys];
    NSString* key = [keys objectAtIndex:section];
    NSMutableArray* arr = [_storyDic objectForKey:key];
    return [arr count]+1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_storyDic count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    NSArray* keys = [_storyDic allKeys];
    NSString* key = [keys objectAtIndex:indexPath.section];
    
    if (indexPath.row == 0) {
        ListDataCell *cell = (ListDataCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ListDataCell" owner:nil options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.dateLabel.text = key;
        return cell;
    }else{
        NSMutableArray* arr = [_storyDic objectForKey:key];
        NSDictionary* dic = [arr objectAtIndex:indexPath.row-1];
        
        ListCell *cell = (ListCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:nil options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
       
        cell.parentView = self;
        NSNumber* backNum = [dic objectForKey:@"ColorIdx"];
        NSInteger backGroundIdx = 3;
        if (backNum) {
             backGroundIdx = [backNum integerValue];
        }
        UIImage *backImage = [UIImage imageNamed:[NSString stringWithFormat:@"list_bg%02ld.png",(long)backGroundIdx]];
        cell.bgImgView.image = [backImage stretchableImageWithLeftCapWidth:3 topCapHeight:0];
        cell.btn.tag = indexPath.row;
        cell.section = indexPath.section;
        cell.row = indexPath.row;
        cell.dateLabel.text = [dic objectForKey:@"story_date"];
        cell.contentLabel.text = [dic objectForKey:@"content"];
        
        if ([dic objectForKey:@"reply"] != NULL) {
            [cell.starBtn setSelected:TRUE];
        }
        
        return cell;
    }

    return NULL;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*
    if (indexPath.row == 0) {
        return ;
    }
    NSArray* keys = [_storyDic allKeys];
    NSString* key = [keys objectAtIndex:indexPath.section];
    NSMutableArray* arr = [_storyDic objectForKey:key];
    NSDictionary* dic = [arr objectAtIndex:indexPath.row-1];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ContentViewController* viewCont = [storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
    //viewCont.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    //UIViewController* viewCont = [[UIViewController alloc] init];
    viewCont.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    viewCont.storyDic = dic;
    viewCont.parent = self;
    [self.parentViewCont presentViewController:viewCont animated:YES completion:nil];
     */
}
- (void)goToEtingContentView:(NSString*)storyId{
    
    for (NSDictionary* dic in _storyArr) {
        if ([[dic objectForKey:@"story_id"] isEqualToString:storyId]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            ContentViewController* viewCont = [storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
            //viewCont.modalTransitionStyle = UIModalTransitionStylePartialCurl;
            //UIViewController* viewCont = [[UIViewController alloc] init];
            viewCont.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            viewCont.storyDic = [dic mutableCopy];
            viewCont.parent = self;
            NSNumber* num = [dic objectForKey:@"ColorIdx"];
            NSInteger idx = 1;
            if (num) {
                idx = [num integerValue];
            }
            viewCont.idx = idx;
            [self.parentViewCont presentViewController:viewCont animated:YES completion:nil];
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
    [self initVariable];
}


@end
