//
//  ContentViewController.m
//  Eting_IOS
//
//  Created by Rangken on 2014. 1. 1..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "ContentViewController.h"
#import "StoryManager.h"
#import "ListView.h"
#import <FSExtendedAlertKit.h>
#import "AFAppDotNetAPIClient.h"
#import "MBProgressHUD.h"
@interface ContentViewController ()

@end

@implementation ContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imoticonPoint[0] = CGPointMake(22+47*2, 423);
    imoticonPoint[1] = CGPointMake(22+47*3, 423);
    imoticonPoint[2] = CGPointMake(22+47*1, 423);
    imoticonPoint[3] = CGPointMake(22+47*4, 423);
    imoticonPoint[4] = CGPointMake(22,423);
    imoticonPoint[5] = CGPointMake(22+47*5, 423);
    imoticonPoint[6] = CGPointMake(22+47/2+47*2, 423);
    imoticonPoint[7] = CGPointMake(22+47/2+47*3, 423);
    imoticonPoint[8] = CGPointMake(22+47/2+47, 423);
    imoticonPoint[9] = CGPointMake(22+47/2+47*4, 423);
    imoticonPoint[10] = CGPointMake(22+47/2, 423);
    
    NSString* contentStr = [_storyDic objectForKey:@"content"];

    NSInteger backIdx = _idx;
    
    if (backIdx <= 0 || backIdx > 4) {
        backIdx = 3;
    }
    
    _bgAllImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bg%02ld.jpg",[[StoryManager sharedSingleton] getTimeBackIdx]]];
    
    _listTopBgImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"list_top_bg%02ld.png",(long)backIdx]];
    UIImage *middleImgView = [UIImage imageNamed:@"list_middle_bg01.png"];
    _listMiddleBgImgView.image = [middleImgView stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIFont *myFont = [UIFont fontWithName:@"Helvetica" size:15];
    CGSize contentSize = [contentStr sizeWithFont:myFont
                               constrainedToSize:CGSizeMake(292, 2000)
                                   lineBreakMode:NSLineBreakByWordWrapping];
    [_listMiddleBgImgView setFrame:CGRectMake(_listMiddleBgImgView.frame.origin.x, _listMiddleBgImgView.frame.origin.y, _listMiddleBgImgView.frame.size.width, 70 + contentSize.height)];
    [_listBottomBgImgView setFrame:CGRectMake(_listBottomBgImgView.frame.origin.x, _listTopBgImgView.frame.origin.y+_listTopBgImgView.frame.size.height+_listMiddleBgImgView.frame.size.height, _listBottomBgImgView.frame.size.width, _listBottomBgImgView.frame.size.height)];
    
    _textView.text = contentStr;
    if (contentSize.height >= 2000) {
        [_textView setFrame:CGRectMake(_textView.frame.origin.x, _textView.frame.origin.y, _textView.frame.size.width, 2000)];
    }else{
        [_textView setFrame:CGRectMake(_textView.frame.origin.x, _textView.frame.origin.y, _textView.frame.size.width, contentSize.height+40)];
        [_textView setContentSize:CGSizeMake(_textView.frame.size.width, contentSize.height+40)];
    }
    
    _textView.font = [UIFont fontWithName:@"Helvetica" size:15];
    [_textView setTextColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1.0f]];
    _dateLabel.text = [_storyDic objectForKey:@"story_date"];
    
    if ([_storyDic objectForKey:@"reply"] == NULL) {
        [_feedbackTopBgImgView setHidden:TRUE];
        [_feedbackMiddleBgImgView setHidden:TRUE];
        [_feedbackBottomBgImgView setHidden:TRUE];
        [_reportBtn setHidden:TRUE];
        [_delBtn setHidden:TRUE];
        
        NSArray* stampImgArr = [NSArray arrayWithObjects:_stampImgView1,_stampImgView2,_stampImgView3,_stampImgView4,_stampImgView5,_stampImgView6, nil];
        for (int i=0; i < [stampImgArr count]; i++) {
            UIImageView* imgView = [stampImgArr objectAtIndex:i];
            [imgView setHidden:TRUE];
        }
        [_replyTextView setHidden:TRUE];
    }else{
        NSString* commentStr = [[_storyDic objectForKey:@"reply"] objectForKey:@"comment"];
        [_feedbackTopBgImgView setFrame:CGRectMake(_feedbackTopBgImgView.frame.origin.x, _listBottomBgImgView.frame.origin.y + _listBottomBgImgView.frame.size.height + 11, _feedbackTopBgImgView.frame.size.width, _feedbackTopBgImgView.frame.size.height)];
        UIImage *middleImgView = [UIImage imageNamed:@"list_middle_bg01.png"];
        _feedbackMiddleBgImgView.image = [middleImgView stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        CGSize contentSize = [commentStr sizeWithFont:myFont
                                    constrainedToSize:CGSizeMake(292, 960)
                                        lineBreakMode:NSLineBreakByWordWrapping];
        [_feedbackMiddleBgImgView setFrame:CGRectMake(_feedbackMiddleBgImgView.frame.origin.x, _feedbackTopBgImgView.frame.origin.y + _feedbackTopBgImgView.frame.size.height , _feedbackMiddleBgImgView.frame.size.width, contentSize.height+60)];
        [_feedbackBottomBgImgView setFrame:CGRectMake(_feedbackBottomBgImgView.frame.origin.x, _feedbackMiddleBgImgView.frame.origin.y + _feedbackMiddleBgImgView.frame.size.height, _feedbackBottomBgImgView.frame.size.width, _feedbackBottomBgImgView.frame.size.height)];
        
        _replyTextView.text = commentStr;
        [_replyTextView setTextColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1.0f]];
        if (contentSize.height >= 960) {
            [_replyTextView setFrame:CGRectMake(_replyTextView.frame.origin.x, _feedbackMiddleBgImgView.frame.origin.y+5, _replyTextView.frame.size.width, 960)];
        }else{
            [_replyTextView setFrame:CGRectMake(_replyTextView.frame.origin.x, _feedbackMiddleBgImgView.frame.origin.y+5, _replyTextView.frame.size.width, contentSize.height+40)];
            [_replyTextView setContentSize:CGSizeMake(_replyTextView.frame.size.width, contentSize.height+40)];
        }
        _replyTextView.font = [UIFont fontWithName:@"Helvetica" size:15];
        [_reportBtn setFrame:CGRectMake(_reportBtn.frame.origin.x, _feedbackBottomBgImgView.frame.origin.y-20, _reportBtn.frame.size.width, _reportBtn.frame.size.height)];
        [_delBtn setFrame:CGRectMake(_delBtn.frame.origin.x, _feedbackBottomBgImgView.frame.origin.y-20, _delBtn.frame.size.width, _delBtn.frame.size.height)];
        NSString* stampStr = [[_storyDic objectForKey:@"reply"] objectForKey:@"stamps"];
        NSArray* stampArr = [stampStr componentsSeparatedByString:@","];
        NSArray* stampImgArr = [NSArray arrayWithObjects:_stampImgView1,_stampImgView2,_stampImgView3,_stampImgView4,_stampImgView5,_stampImgView6, nil];
        for (int i=0; i < [stampImgArr count]; i++) {
            if (i < [stampArr count]) {
                NSString* stampIdxStr = [stampArr objectAtIndex:i];
                UIImageView* imgView = [stampImgArr objectAtIndex:i];
                
                [imgView setHidden:FALSE];
                imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"emotion_icon%02d_press.png",stampIdxStr.intValue]];
                if ([stampArr count] % 2 == 1) {
                    [imgView setFrame:CGRectMake(imoticonPoint[i+6].x, _feedbackTopBgImgView.frame.origin.y + 7, imgView.frame.size.width, imgView.frame.size.height)];
                }else{
                    [imgView setFrame:CGRectMake(imoticonPoint[i].x, _feedbackTopBgImgView.frame.origin.y + 7, imgView.frame.size.width, imgView.frame.size.height)];
                }
                
            }
        }
        [_scrollView setFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
        [_scrollView setContentSize:CGSizeMake(320, _feedbackBottomBgImgView.frame.origin.y+20)];
    }
    
	
}
- (IBAction)reportClick:(id)sender
{
    FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"이팅" message:@"해당 댓글을 신고하시겠습니까?" cancelButton:[FSBlockButton blockButtonWithTitle:@"취소" block:^ {
        
    }] otherButtons:[FSBlockButton blockButtonWithTitle:@"확인" block:^ {
        NSLog(@"_storyDic : %@",[_storyDic debugDescription]);
        NSString* commentIdStr = [NSString stringWithFormat:@"%@",[[_storyDic objectForKey:@"reply"] objectForKey:@"comment_id"]];
        NSString* storyIdStr = [NSString stringWithFormat:@"%@",[_storyDic objectForKey:@"story_id"]];
        NSMutableDictionary* parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:commentIdStr forKey:@"comment_id"];
        [parameters setObject:@"R" forKey:@"flag"];
        [parameters setObject:storyIdStr forKey:@"story_id"];
       
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[AFAppDotNetAPIClient sharedClient] postPath:@"eting/reportComment" parameters:parameters success:^(AFHTTPRequestOperation *response, id responseObject) {
            
            NSLog(@"eting/reportComment: %@",(NSDictionary *)responseObject);
            [_storyDic removeObjectForKey:@"reply"];
            [[StoryManager sharedSingleton] removeStoryReply:_storyDic];
            [self viewDidLoad];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
            NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"이팅" message:@"신고에 실패했습니다." cancelButton:[FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                
            }] otherButtons: nil];
            [alert show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }],nil];
    [alert show];
}
- (IBAction)delCommentClick:(id)sender
{
    FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"이팅" message:@"해당 댓글을 삭제하시겠습니까?" cancelButton:[FSBlockButton blockButtonWithTitle:@"취소" block:^ {
        
    }] otherButtons:[FSBlockButton blockButtonWithTitle:@"확인" block:^ {
        NSString* commentIdStr = [NSString stringWithFormat:@"%@",[[_storyDic objectForKey:@"reply"] objectForKey:@"comment_id"]];
        NSString* storyIdStr = [NSString stringWithFormat:@"%@",[_storyDic objectForKey:@"story_id"]];
        NSMutableDictionary* parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:commentIdStr forKey:@"comment_id"];
        [parameters setObject:@"D" forKey:@"flag"];
        [parameters setObject:storyIdStr forKey:@"story_id"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[AFAppDotNetAPIClient sharedClient] postPath:@"eting/reportComment" parameters:parameters success:^(AFHTTPRequestOperation *response, id responseObject) {
            
            NSLog(@"eting/reportComment: %@",(NSDictionary *)responseObject);
            [_storyDic removeObjectForKey:@"reply"];
            [[StoryManager sharedSingleton] removeStoryReply:_storyDic];
            [self viewDidLoad];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
            NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"이팅" message:@"삭제에 실패했습니다." cancelButton:[FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                
            }] otherButtons: nil];
            
            [alert show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }],nil];
    [alert show];
}
- (IBAction)backClick:(id)sender{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)delClick:(id)sender{
    FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"이팅" message:@"해당 이팅을 삭제하시겠습니까?" cancelButton:[FSBlockButton blockButtonWithTitle:@"취소" block:^ {
        
    }] otherButtons:[FSBlockButton blockButtonWithTitle:@"확인" block:^ {
        [[StoryManager sharedSingleton] removeStory:[_storyDic objectForKey:@"story_id"]];
        [_parent refreshView];
        [self dismissViewControllerAnimated:TRUE completion:nil];
    }],nil];
    [alert show];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
