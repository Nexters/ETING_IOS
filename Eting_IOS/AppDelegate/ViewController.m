//
//  ViewController.m
//  Eting_IOS
//
//  Created by Rangken on 2013. 12. 31..
//  Copyright (c) 2013년 Nexters. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "StoryManager.h"
#import "PasswordViewController.h"
#import <FSExtendedAlertKit.h>
#import "AFAppDotNetAPIClient.h"
#import "TutorialViewController.h"
#define SPLACE_TIME 3
@interface ViewController ()

@end
/*
reply =     {
    comment = "\Ucf54\Uba58\Ud2b8";
    "registration_id" = regId;
    stamps = "1,2,3";
    "story_id" = 9736;
    type = Stamp;
};
 */
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float spacePosY = 218;
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        _bgImgView.frame = CGRectMake(0, -35, _bgImgView.frame.size.width, _bgImgView.frame.size.height);
        spacePosY -= 30;
        _spaceImgView.center = CGPointMake(_spaceImgView.center.x, _spaceImgView.center.y-30);
    }
    [UIView animateWithDuration:2.0
                          delay:0
                        options: UIViewAnimationOptionAutoreverse | UIViewAnimationOptionCurveEaseInOut |
                            UIViewAnimationOptionRepeat
                     animations: ^{ _spaceImgView.center = CGPointMake(160, spacePosY+30); }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             //_spaceImgView.center = CGPointMake(160, 218);
                         }
                     }];
}

- (void)AfterGetToken{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceId"];
    NSString *uuidStr = [[AFAppDotNetAPIClient sharedClient] deviceUUID];
    //deviceId = NULL;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Registration"] && deviceId != NULL && ![deviceId isEqualToString:@""]) {
        //init!!!
        NSDictionary *parameters = [
            NSDictionary dictionaryWithObjectsAndKeys:uuidStr,@"device_uuid",
            deviceId,@"device_id", nil
        ];

        [[AFAppDotNetAPIClient sharedClient] getPath:@"eting/init" parameters:parameters success:^(AFHTTPRequestOperation *response, id responseObject) {
            
            NSLog(@"eting/init: %@",(NSDictionary *)responseObject);
            NSDictionary* adDic = [responseObject objectForKey:@"ad"];
            [[NSUserDefaults standardUserDefaults] setObject:adDic forKey:@"adDic"];
            NSLog(@"adDic: %@",adDic);
            NSLog(@"deviceId: %@",deviceId);

            NSTimer *timer = [NSTimer timerWithTimeInterval:SPLACE_TIME target:self selector:@selector(AfterSplash:) userInfo:nil repeats:FALSE];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            
        } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
            NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"이팅" message:@"서버 공사중입니다.\n 조금만 기다려주세요!!" cancelButton:[FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                exit(0);
            }] otherButtons: nil];
            [alert show];
        }];
        //init end
    }else{
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:uuidStr,@"device_uuid",appDelegate.deviceApnsToken,@"reg_id",@"I",@"os", nil];
        NSTimeInterval before = [[NSDate date] timeIntervalSince1970];
        
        [[AFAppDotNetAPIClient sharedClient] getPath:@"eting/registration" parameters:parameters success:^(AFHTTPRequestOperation *response, id responseObject) {
            
            NSLog(@"eting/registration: %@",(NSDictionary *)responseObject);
            if ([[responseObject objectForKey:@"result"] integerValue] == 1) {
                NSString *deviceId = [responseObject objectForKey:@"device_id"];
                [[NSUserDefaults standardUserDefaults] setObject:deviceId forKey:@"DeviceId"];
                [[NSUserDefaults standardUserDefaults] setObject:uuidStr forKey:@"DeviceToken"];
                [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"Registration"];
                NSTimeInterval after = [[NSDate date] timeIntervalSince1970];
                if (after - before < SPLACE_TIME) {
                    NSTimer *timer = [NSTimer timerWithTimeInterval:SPLACE_TIME-(after-before) target:self selector:@selector(AfterSplash:) userInfo:nil repeats:FALSE];
                    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                }else{
                    [self AfterSplash:NULL];
                }
            }else{
                [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"Registration"];
                FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"회원가입" message:@"회원가입에 실패했습니다." cancelButton:[FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                    exit(0);
                }] otherButtons: nil];
                
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
            NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"이팅" message:@"서버 공사중입니다.\n 조금만 기다려주세요!!" cancelButton:[FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                exit(0);
            }] otherButtons: nil];
            [alert show];
        }];
    }
}
- (void)AfterSplash:(id)sender{
    [[NSRunLoop currentRunLoop] cancelPerformSelectorsWithTarget:self];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"IsIntro"]) {
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"IsIntro"];
        TutorialViewController* viewCont = [storyboard instantiateViewControllerWithIdentifier:@"TutorialViewController"];
        AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        viewCont.type = TUTORIAL_INIT;
        [delegate transitionToViewController:viewCont withTransition:UIViewAnimationOptionTransitionCrossDissolve];
    }
    else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Password_On"]) {
        PasswordViewController* viewCont = [storyboard instantiateViewControllerWithIdentifier:@"PasswordViewController"];
        viewCont.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        viewCont.type = PASSWORD_VIEWCONT_INIT;
        [self presentViewController:viewCont animated:TRUE completion:nil];
    }else{
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"Agree"]) {
            //[[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"Registration"];
            UIViewController* viewCont = [storyboard instantiateViewControllerWithIdentifier:@"AgreeViewController"];
            AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
            [delegate transitionToViewController:viewCont withTransition:UIViewAnimationOptionTransitionCrossDissolve];
        }else{
            UIViewController* viewCont = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
            AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
            [delegate transitionToViewController:viewCont withTransition:UIViewAnimationOptionTransitionCrossDissolve];
        }
    }
}
- (void)retryDeviceToken:(id)sender{
    [self viewDidLoad];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
