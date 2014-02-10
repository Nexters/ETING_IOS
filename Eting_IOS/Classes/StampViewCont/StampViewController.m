//
//  StampViewController.m
//  Eting_IOS
//
//  Created by Rangken on 2014. 1. 1..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "StampViewController.h"
#import "StoryManager.h"
#import "AFAppDotNetAPIClient.h"
#import "MBProgressHUD.h"
#import <FSExtendedAlertKit.h>

@interface StampViewController ()

@end

@implementation StampViewController

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
    
    NSMutableArray* stampArr = [[StoryManager sharedSingleton] getStamps];
    stampDic = [stampArr objectAtIndex:0];
    _dateLabel.text = [NSString stringWithFormat:@"%@    %@",[stampDic objectForKey:@"story_date"],[stampDic objectForKey:@"story_time"]];
    _contentTextView.text = [NSString stringWithFormat:@"%@",[stampDic objectForKey:@"content"]];
    /*
	UIImage *backImage1 = [UIImage imageNamed:[NSString stringWithFormat:@"send_bg02.png"]];
    _bgImgView1.image = [backImage1 stretchableImageWithLeftCapWidth:0 topCapHeight:0];
     */
    originalRect = _contentTextView.frame;
    originalSize = _contentTextView.contentSize;
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        _contentTextView.frame = CGRectMake(_contentTextView.frame.origin.x, _contentTextView.frame.origin.y, _contentTextView.frame.size.width, _contentTextView.frame.size.height-10);
        _contentTextView.contentSize = CGSizeMake(_contentTextView.contentSize.width, _contentTextView.contentSize.height-10);
    }
    _contentTextView.font = [UIFont systemFontOfSize:15];
}

- (IBAction)backClick:(id)sender{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)reportClick:(id)sender{
    FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"이팅" message:@"해당 이팅을 신고하시겠습니까?" cancelButton:[FSBlockButton blockButtonWithTitle:@"취소" block:^ {
        
    }] otherButtons:[FSBlockButton blockButtonWithTitle:@"확인" block:^ {
        NSString* storyIdStr = [NSString stringWithFormat:@"%@",[stampDic objectForKey:@"story_id"]];
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:storyIdStr,@"story_id"
                                    , nil];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[AFAppDotNetAPIClient sharedClient] postPath:@"eting/report" parameters:parameters success:^(AFHTTPRequestOperation *response, id responseObject) {
            
            NSLog(@"eting/saveStamp: %@",(NSDictionary *)responseObject);
            [[StoryManager sharedSingleton] removeStamp:storyIdStr];
            [self dismissViewControllerAnimated:TRUE completion:nil];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
            NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"이팅" message:@"이팅에 실패했습니다." cancelButton:[FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                
            }] otherButtons: nil];
            
            [alert show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }],nil];
    [alert show];
    
}
- (IBAction)sendClick:(id)sender{
    if (_writeTextView.text.length <= 3) {
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"이팅" message:@"4글자 이상 입력해주세요." cancelButton:[FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            
        }] otherButtons: nil];
        [alert show];
        return ;
    }
    [_writeTextView resignFirstResponder];
    
    NSString* storyIdStr = [NSString stringWithFormat:@"%@",[stampDic objectForKey:@"story_id"]];
    NSMutableString* stampIdSuffix = [[NSMutableString alloc] init];
    for (UIButton* btn in [NSArray arrayWithObjects:_stampBtn1,_stampBtn2,_stampBtn3,_stampBtn4,_stampBtn5,_stampBtn6, nil]) {
        if (btn.selected) {
            [stampIdSuffix appendString:[NSString stringWithFormat:@"%ld,",(long)btn.tag+1]];
        }
    }
    if ([stampIdSuffix isEqualToString:@""]) {
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"이팅" message:@"스탬프를 선택해주세요." cancelButton:[FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            
        }] otherButtons: nil];
        [alert show];
        return ;
    }
    NSString* stampId = @"";
    if (![stampIdSuffix isEqualToString:@""] && [stampIdSuffix hasSuffix:@","]) {
        stampId = [stampIdSuffix substringWithRange:NSMakeRange(0, stampIdSuffix.length-1)];
    }
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:storyIdStr,@"story_id"
                                ,_writeTextView.text,@"sender"
                                ,stampId,@"stamp_id", nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AFAppDotNetAPIClient sharedClient] postPath:@"eting/saveStamp" parameters:parameters success:^(AFHTTPRequestOperation *response, id responseObject) {
        
        NSLog(@"eting/saveStamp: %@",(NSDictionary *)responseObject);
        [[StoryManager sharedSingleton] removeStamp:storyIdStr];
        [self dismissViewControllerAnimated:TRUE completion:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"이팅" message:@"이팅에 실패했습니다." cancelButton:[FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            
        }] otherButtons: nil];
        
        [alert show];
    }];
}
- (IBAction)tapGesture:(id)sender{
    [_writeTextView resignFirstResponder];
}
- (IBAction)stampClick:(id)sender{
    UIButton* btn = (UIButton*)sender;
    if (![btn isSelected]) {
        [btn setSelected:TRUE];
    }else{
        [btn setSelected:FALSE];
    }
}
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    return TRUE;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
//    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
//    [_contentTextView addGestureRecognizer:tap];
    int height = 198;
    [UIView animateWithDuration:.3f
                          delay:0
                        options: UIViewAnimationOptionCurveLinear
                     animations: ^{
                         _writeView.center = CGPointMake(_writeView.center.x, _writeView.center.y-height);
                         if ([[UIScreen mainScreen] bounds].size.height == 568) {
                             [_contentTextView setFrame:CGRectMake(_contentTextView.frame.origin.x, 131, 267, 251-100)];
                             [_contentTextView setContentSize:CGSizeMake(_contentTextView.contentSize.width, _contentTextView.contentSize.height-100)];
                             [_bgImgView1 setFrame:CGRectMake(_bgImgView1.frame.origin.x, _bgImgView1.frame.origin.y, _bgImgView1.frame.size.width, _bgImgView1.frame.size.height-height)];
                         }else{
                             [_contentTextView setFrame:CGRectMake(_contentTextView.frame.origin.x, 131, 267, 251-100-88)];
                             [_contentTextView setContentSize:CGSizeMake(_contentTextView.contentSize.width, _contentTextView.contentSize.height-100-88)];
                             [_bgImgView1 setFrame:CGRectMake(_bgImgView1.frame.origin.x, _bgImgView1.frame.origin.y, _bgImgView1.frame.size.width, _bgImgView1.frame.size.height-height)];
                         }
                     }
                     completion: ^(BOOL finished) { }];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
//    if (tap) {
//        [_contentTextView removeGestureRecognizer:tap];
//    }
    int height = 198;
    [UIView animateWithDuration:.3f
                          delay:0
                        options: UIViewAnimationOptionCurveLinear
                     animations: ^{
                         _writeView.center = CGPointMake(_writeView.center.x, _writeView.center.y+height);
                         if ([[UIScreen mainScreen] bounds].size.height == 568) {
                             [_contentTextView setFrame:originalRect];
                             [_contentTextView setContentSize:originalSize];
                             [_bgImgView1 setFrame:CGRectMake(_bgImgView1.frame.origin.x, _bgImgView1.frame.origin.y, _bgImgView1.frame.size.width, _bgImgView1.frame.size.height+height)];
                         }else{
                             [_contentTextView setFrame:CGRectMake(originalRect.origin.x, originalRect.origin.y, originalRect.size.width, originalRect.size.height-78)];
                             [_contentTextView setContentSize:CGSizeMake(originalSize.width, originalSize.height-78)];
                             [_bgImgView1 setFrame:CGRectMake(_bgImgView1.frame.origin.x, _bgImgView1.frame.origin.y, _bgImgView1.frame.size.width, _bgImgView1.frame.size.height+height)];
                         }
                     }
                     completion: ^(BOOL finished) { }];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return TRUE;
}
- (void)textViewDidChange:(UITextView *)textView{
    if (![textView.text isEqualToString:@""]) {
        _emptyWriteLabel.hidden = TRUE;
    }else{
        _emptyWriteLabel.hidden = FALSE;
    }
    if (textView.contentSize.height > textView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, textView.contentSize.height - textView.frame.size.height);
        [_writeTextView setContentOffset:offset animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
