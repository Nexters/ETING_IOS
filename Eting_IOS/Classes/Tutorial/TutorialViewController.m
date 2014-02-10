//
//  TutorialViewController.m
//  Eting_IOS
//
//  Created by Rangken on 2014. 1. 16..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "TutorialViewController.h"
#import "AppDelegate.h"
@interface TutorialViewController ()

@end

@implementation TutorialViewController

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
    for (int i=0; i < 4; i++) {
        UIImageView* tutoImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"tuto%d.jpg",i+1]]];
        [tutoImgView setFrame:CGRectMake(320*i, 0, 320, 568)];
        [_scrollView addSubview:tutoImgView];
    }
    if (_type == TUTORIAL_INIT) {
        [_backBtn setHidden:TRUE];
    }
	// Do any additional setup after loading the view.
}
- (IBAction)leftSwipeGesutre:(id)sender{
    if (_scrollView.contentOffset.x == 0 || _scrollView.contentOffset.x == 320 || _scrollView.contentOffset.x == 640) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x+320, 0) animated:TRUE];
        [_pageControl setCurrentPage:_scrollView.contentOffset.x/320+1];
    }else if(_scrollView.contentOffset.x == 960){
        // 스크롤 완료
        if (_type == TUTORIAL_INIT) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"Agree"]) {
                UIViewController* viewCont = [storyboard instantiateViewControllerWithIdentifier:@"AgreeViewController"];
                AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
                [delegate transitionToViewController:viewCont withTransition:UIViewAnimationOptionTransitionCrossDissolve];
            }else{
                UIViewController* viewCont = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
                AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
                [delegate transitionToViewController:viewCont withTransition:UIViewAnimationOptionTransitionCrossDissolve];
            }
        }else if (_type == TUTORIAL_SETTING){
            [self dismissViewControllerAnimated:TRUE completion:nil];
        }
    }
}

- (IBAction)rightSwipeGesture:(id)sender{
    if (_scrollView.contentOffset.x == 320 || _scrollView.contentOffset.x == 640 || _scrollView.contentOffset.x == 960) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x-320, 0) animated:TRUE];
        [_pageControl setCurrentPage:_scrollView.contentOffset.x/320-1];
    }else if (_scrollView.contentOffset.x == 0){
        if (_type == TUTORIAL_SETTING){
            [self dismissViewControllerAnimated:TRUE completion:nil];
        }
    }
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}

- (IBAction)backClick:(id)sender{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
