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
    NSInteger backIdx = _idx;
    if (backIdx <= 0 || backIdx > 4) {
        backIdx = 1;
    }
    
    _bgAllImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bg%02ld.jpg",(long)backIdx]];
    UIImage *backImage = [UIImage imageNamed:[NSString stringWithFormat:@"list_bg%02ld.png",(long)backIdx+3]];
    _bgImgView.image = [backImage stretchableImageWithLeftCapWidth:3 topCapHeight:0];
    UIImage *backImage2 = [UIImage imageNamed:@"list_bg07.png"];
    _bgImgView2.image = [backImage2 stretchableImageWithLeftCapWidth:3 topCapHeight:0];
    //NSMutableArray* storyArr = [[StoryManager sharedSingleton] getStorys];
    //_storyDic = [storyArr objectAtIndex:_idx];
    _textView.text = [_storyDic objectForKey:@"content"];
    _dateLabel.text = [_storyDic objectForKey:@"story_date"];
    
    if ([_storyDic objectForKey:@"reply"] == NULL) {
        [_bgImgView2 setFrame:CGRectMake(_bgImgView2.frame.origin.x, _bgImgView2.frame.origin.y, _bgImgView2.frame.size.width, 70)];
        [_bgImgView2 setHidden:TRUE];
    }else{
        _replyTextView.text = [[_storyDic objectForKey:@"reply"] objectForKey:@"comment"];
        NSString* stampStr = [[_storyDic objectForKey:@"reply"] objectForKey:@"stamps"];
        NSArray* stampArr = [stampStr componentsSeparatedByString:@","];
        NSArray* stampImgArr = [NSArray arrayWithObjects:_stampImgView1,_stampImgView2,_stampImgView3, nil];
        for (int i=0; i < 3; i++) {
            if (i < [stampArr count]) {
                NSString* stampIdxStr = [stampArr objectAtIndex:i];
                UIImageView* imgView = [stampImgArr objectAtIndex:i];
                [imgView setHidden:FALSE];
                imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"feed_btn%02d",stampIdxStr.intValue]];
            }
        }
    }
	// Do any additional setup after loading the view.
}


- (IBAction)backClick:(id)sender{
    NSLog(@"presentedViewController : %@",self.presentedViewController);
    NSLog(@"presentingViewController : %@",self.presentingViewController);
    
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
