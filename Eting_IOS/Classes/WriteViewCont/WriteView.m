//
//  WriteView.m
//  Eting_IOS
//
//  Created by Rangken on 2014. 1. 1..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "WriteView.h"
#import "MainViewController.h"
#import "StoryManager.h"
#import "AFAppDotNetAPIClient.h"
#import <FSExtendedAlertKit.h>
#define WRITE_SPLACE_TIME 2.5f
@implementation WriteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib{
    
}
- (void)initVariable{
    etingBtnPoint = _etingBtn.center;
    bgImg2Point = _bgImgView2.center;
    _textView.font = [UIFont systemFontOfSize:15];
    [_textView setTextColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1.0f]];
}
- (IBAction)backClick:(id)sender
{
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
    }else{
        [self.parentViewCont.scrollView setContentOffset:CGPointMake(320, 0) animated:TRUE];
    }
}

- (IBAction)tapGeusture:(id)sender{
    [_textView resignFirstResponder];
}
- (IBAction)etingClick:(id)sender{
    if (_textView.text.length <= 3) {
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"이팅" message:@"4글자 이상 입력해주세요." cancelButton:[FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            
        }] otherButtons: nil];
        [alert show];
        return ;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [_textView setAlpha:0.0f];
        [_textView resignFirstResponder];
        [_writeBgImgView setAlpha:0.0f];
        [_dateLabel setAlpha:.0f];
        [_backBtn setAlpha:.0f];
        [_etingBtn setAlpha:.0f];
        [_bgImgView1 setAlpha:.0f];
        [_bgImgView2 setAlpha:.0f];
    } completion:^(BOOL finished) {
        //[_textView setHidden:YES];
        [UIView animateWithDuration:2.0
                              delay:0
                            options: UIViewAnimationOptionAutoreverse | UIViewAnimationOptionCurveEaseInOut |
                                UIViewAnimationOptionRepeat
                         animations: ^{ _spaceImgView.center = CGPointMake(160, _spaceImgView.center.y+30); }
                         completion: ^(BOOL finished) {
                             //_spaceImgView.center = CGPointMake(160, 218-30);
                             //_spaceImgView.center = CGPointMake(160, 218-30);
                         }];
    }];
    
    NSString *uuidStr = [[AFAppDotNetAPIClient sharedClient] deviceUUID];
    
    NSTimeInterval before = [[NSDate date] timeIntervalSince1970];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:_textView.text,@"content",uuidStr,@"phone_id", nil];
    [[AFAppDotNetAPIClient sharedClient] postPath:@"eting/saveStory" parameters:parameters success:^(AFHTTPRequestOperation *response, id responseObject) {
        
        NSLog(@"eting/saveStory: %@",(NSDictionary *)responseObject);
        
        NSMutableDictionary* saveMyStroyDic = [[responseObject objectForKey:@"myStory"] mutableCopy];
        if (saveMyStroyDic != NULL) {
            NSInteger backGroundIdx = [[StoryManager sharedSingleton] getTimeBackIdx];
            
            [saveMyStroyDic setObject:[[NSNumber alloc] initWithInt:(int)backGroundIdx] forKey:@"ColorIdx"];
            [[StoryManager sharedSingleton] saveStory:saveMyStroyDic date:[[StoryManager sharedSingleton] todayKey]];
     
        }
        NSDictionary* saveReceiveDic = [responseObject objectForKey:@"recievedStory"];
        //saveReceiveDic = [saveReceiveDic mutableCopy];
        if (saveReceiveDic != NULL) {
            [[StoryManager sharedSingleton] saveStamp:saveReceiveDic];
        }
        NSTimeInterval after = [[NSDate date] timeIntervalSince1970];
        if (after-before > WRITE_SPLACE_TIME) {
            [self writeComplete:NULL];
        }else{
            NSTimer *timer = [NSTimer timerWithTimeInterval:WRITE_SPLACE_TIME-(after-before) target:self selector:@selector(writeComplete:) userInfo:nil repeats:FALSE];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"이팅" message:@"이팅에 실패했습니다." cancelButton:[FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            [self writeComplete:NULL];
        }] otherButtons: nil];
        
        [alert show];
    }];
}
- (void)refreshView{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *date = [NSDate date];//datapicker date
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    
    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
    NSInteger day = [dateComponents day];
    _dateLabel.text = [NSString stringWithFormat:@"%li-%02li-%02li",(long)year,(long)month, (long)day];
}
- (void)writeComplete:(id)sender{
    [self.parentViewCont.mainView viewDidSlide];
    [self.parentViewCont.listView refreshView];
    [self.parentViewCont.mainView refreshView];
    [self.parentViewCont.scrollView setContentOffset:CGPointMake(320, 0) animated:TRUE];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(writeViewReset:) userInfo:nil repeats:FALSE];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
- (void)writeViewReset:(id)sender{
    [_textView setText:@""];
    [_textView setAlpha:1.0f];
    [_textView resignFirstResponder];
    [_writeBgImgView setAlpha:1.0f];
    [_dateLabel setAlpha:1.0f];
    [_backBtn setAlpha:1.0f];
    [_etingBtn setAlpha:1.0f];
    _spaceImgView.center = CGPointMake(160, 218);
    [_spaceImgView.layer removeAllAnimations];
    [_bgImgView1 setAlpha:1.0f];
    [_bgImgView2 setAlpha:1.0f];
}
#pragma mark BaseViewDelegate
- (void)viewDidSlide{
    [_textView resignFirstResponder];
    _textView.text = @"";
}

- (void)viewUnSilde{
    [_textView resignFirstResponder];
    _textView.text = @"";
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self initVariable];
    [self refreshView];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        _textView.frame = CGRectMake(25, 102, 270, 182);
        _textView.contentSize = CGSizeMake(270, 182);
    }else{
        _textView.frame = CGRectMake(25, 102, 270, 182-88);
        _textView.contentSize = CGSizeMake(270, 182-88);
    }
    UIImage *backImage1 = [UIImage imageNamed:[NSString stringWithFormat:@"send_bg02.png"]];
    _bgImgView1.image = [backImage1 stretchableImageWithLeftCapWidth:3 topCapHeight:3];
    
    UIImage *backImage2 = [UIImage imageNamed:[NSString stringWithFormat:@"send_bg03.png"]];
    _bgImgView2.image = [backImage2 stretchableImageWithLeftCapWidth:3 topCapHeight:3];
}
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    return TRUE;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    int keyBoardHeight = 202;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGeusture:)];
    [textView addGestureRecognizer:tap];
    
    [UIView animateWithDuration:.3f
                          delay:0
                        options: UIViewAnimationOptionCurveLinear
                     animations: ^{
                         _etingBtn.center = CGPointMake(160, etingBtnPoint.y-keyBoardHeight-10);
                         _bgImgView2.center = CGPointMake(160, bgImg2Point.y-keyBoardHeight-10);
                         [_bgImgView1 setFrame:CGRectMake(_bgImgView1.frame.origin.x, _bgImgView1.frame.origin.y, _bgImgView1.frame.size.width, _bgImgView1.frame.size.height-keyBoardHeight)];
                         if ([[UIScreen mainScreen] bounds].size.height == 568) {
                             _textView.frame = CGRectMake(25, 102, 270, 148);
                             _textView.contentSize = CGSizeMake(270, 148);
                         }else{
                             _textView.frame = CGRectMake(25, 102, 270, 148-88);
                             _textView.contentSize = CGSizeMake(270, 148-88);
                         }
                     }
                     completion: ^(BOOL finished) { }];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (tap) {
        [textView removeGestureRecognizer:tap];
    }
    int keyBoardHeight = 202;
    [UIView animateWithDuration:.3f
                          delay:0
                        options: UIViewAnimationOptionCurveLinear
                     animations: ^{
                         //_etingBtn.center = CGPointMake(160, etingBtnPoint.y);
                         //_bgImgView2.center = CGPointMake(160,bgImg2Point.y);
                         _etingBtn.center = CGPointMake(160, _etingBtn.center.y+keyBoardHeight+10);
                         _bgImgView2.center = CGPointMake(160,_bgImgView2.center.y+keyBoardHeight+10);
                         
                         [_bgImgView1 setFrame:CGRectMake(_bgImgView1.frame.origin.x, _bgImgView1.frame.origin.y, _bgImgView1.frame.size.width, _bgImgView1.frame.size.height+keyBoardHeight)];
                         if ([[UIScreen mainScreen] bounds].size.height == 568) {
                             _textView.frame = CGRectMake(25, 102, 270, 363);
                             _textView.contentSize = CGSizeMake(270, 202);
                         }else{
                             _textView.frame = CGRectMake(25, 102, 270, 363-88);
                             _textView.contentSize = CGSizeMake(270, 202-88);
                         }
                     }
                     completion: ^(BOOL finished) { }];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return TRUE;
}
- (void)textViewDidChange:(UITextView *)textView{
    [textView scrollRangeToVisible:[textView selectedRange]];
    
}

@end
