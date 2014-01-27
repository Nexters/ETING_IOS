//
//  AgreeViewController.m
//  Eting_IOS
//
//  Created by Rangken on 2014. 1. 27..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "AgreeViewController.h"
#import "AppDelegate.h"
@interface AgreeViewController ()

@end

@implementation AgreeViewController

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
	// Do any additional setup after loading the view.
}
- (IBAction)agreeClick:(id)sender{
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"Agree"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* viewCont = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    [delegate transitionToViewController:viewCont withTransition:UIViewAnimationOptionTransitionCrossDissolve];
}

- (IBAction)disAgreeClick:(id)sender{
    [[UIApplication sharedApplication] finalize];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
