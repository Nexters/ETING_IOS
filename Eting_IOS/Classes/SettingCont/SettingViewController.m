//
//  SettingViewController.m
//  Eting_IOS
//
//  Created by Rangken on 2014. 1. 9..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "SettingViewController.h"
#import "StoryManager.h"
#import "PasswordViewController.h"
#import "AppDelegate.h"
#import "TutorialViewController.h"
#import "PasswordSettingViewController.h"
#import <FSExtendedAlertKit.h>
@interface SettingViewController ()

@end

@implementation SettingViewController

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

- (IBAction)btnClick:(id)sender
{
    NSInteger tag = ((UIButton *)sender).tag;
    if (tag == 0) {
        
    }
    if (tag == 1) {
        if ([[NSUserDefaults standardUserDefaults] stringForKey:@"Password"]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PasswordViewController* viewCont = [storyboard instantiateViewControllerWithIdentifier:@"PasswordViewController"];
            viewCont.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            viewCont.type = PASSWORD_VIEWCONT_CHANGE;
            [self presentViewController:viewCont animated:TRUE completion:nil];
        }else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            PasswordSettingViewController* viewCont = (PasswordSettingViewController*)[storyboard instantiateViewControllerWithIdentifier:@"PasswordSettingViewController"];
            viewCont.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            viewCont.settingViewCont = self;
            [self presentViewController:viewCont animated:TRUE completion:NULL];
        }
    }
    if (tag == 2) {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"ETING"];
        [controller setMessageBody:[[StoryManager sharedSingleton] getStoryForMail] isHTML:NO];
        
        [self presentViewController:controller animated:TRUE completion:NULL];
    }
    if (tag == 3) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"IsIntro"];
        TutorialViewController* viewCont = [storyboard instantiateViewControllerWithIdentifier:@"TutorialViewController"];
        AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        viewCont.type = TUTORIAL_SETTING;
        [self presentViewController:viewCont animated:TRUE completion:NULL];
    }
    if (tag == 4) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UIViewController* viewCont = [storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
        viewCont.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:viewCont animated:TRUE completion:NULL];
    }
}

- (IBAction)doneClick:(id)sender{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}
- (IBAction)switchChange:(id)sender{
    FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"이팅" message:@"아이폰 설정에서 푸시를 꺼주세요." cancelButton:[FSBlockButton blockButtonWithTitle:@"확인" block:^ {
        UISwitch* sw = (UISwitch*)sender;
        [sw setOn:TRUE];
    }] otherButtons:nil];
    [alert show];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
    }
    [self dismissViewControllerAnimated:TRUE completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
