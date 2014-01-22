//
//  AboutViewController.m
//  Eting_IOS
//
//  Created by Rangken on 2014. 1. 9..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "AboutViewController.h"
#import <FSExtendedAlertKit.h>
@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated{
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        [_scrollView setContentSize:CGSizeMake(320, 568)];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)backClick:(id)sender{
    [self dismissViewControllerAnimated:TRUE completion:NULL];
}
- (IBAction)click:(id)sender{
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        return ;
    }
    int tag = ((UIButton *)sender).tag;
    if (tag == 7) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.nextersappfactory.com"]];
        return ;
    }
    NSMutableArray* arr = [NSMutableArray arrayWithObjects:@"이팅을 사랑해주셔서 감사합니다"
                   , @"그는 훈남입니다.",@"그는 착한 남자입니다",@"그는 열정남입니다",@"그녀는 저도 잘 모릅니다",@"그녀는 아주 작아요", @"그녀는 무색무취입니다.", nil];
    NSString* message = [arr objectAtIndex:tag];
    FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"이팅" message:message cancelButton:[FSBlockButton blockButtonWithTitle:@"확인" block:^ {
    }] otherButtons: nil];
    
    [alert show];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
