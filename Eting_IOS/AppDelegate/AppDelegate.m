//
//  AppDelegate.m
//  Eting_IOS
//
//  Created by Rangken on 2013. 12. 31..
//  Copyright (c) 2013년 Nexters. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "ViewController.h"
#import "StoryManager.h"
#import "PasswordViewController.h"
#import <JSONKit.h>
#import <FSExtendedAlertKit.h>
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert |
                                                                           UIRemoteNotificationTypeBadge |
                                                                           UIRemoteNotificationTypeSound)];
    
    application.applicationIconBadgeNumber = 0;
    NSLog(@"OPTION :%@",[launchOptions debugDescription]);
    _launchOptions = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if ([_launchOptions objectForKey:@"reply"]) {
        NSString* replyStr = [_launchOptions objectForKey:@"reply"];
        NSDictionary* replyDic = [replyStr objectFromJSONString];
        [[StoryManager sharedSingleton] addStoryReply:replyDic];
    }else if([_launchOptions objectForKey:@"inbox"]){
        NSString* inboxStr = [_launchOptions objectForKey:@"inbox"];
        NSDictionary* inboxDic = [inboxStr objectFromJSONString];
        [[StoryManager sharedSingleton] saveStamp:inboxDic];
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    pauseTime = [[NSDate date] timeIntervalSince1970];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Password_On"]) {
        if ([[NSDate date] timeIntervalSince1970]-pauseTime > 60) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            PasswordViewController* viewCont = [storyboard instantiateViewControllerWithIdentifier:@"PasswordViewController"];
            viewCont.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            viewCont.type = PASSWORD_VIEWCONT_RESUME;
            if (self.window.rootViewController.presentedViewController) {
                [self.window.rootViewController.presentedViewController presentViewController:viewCont animated:YES completion:nil];
            }else{
                [self.window.rootViewController presentViewController:viewCont animated:YES completion:nil];
            }
        }
        
        
        MainViewController* mainViewCont = (MainViewController*)self.window.rootViewController;
        if (mainViewCont && [mainViewCont respondsToSelector:@selector(applicationWillEnterForeground:)] && [mainViewCont isKindOfClass:[MainViewController class]]) {
            [mainViewCont applicationWillEnterForeground:application];
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    NSLog(@"sourceApplication absoluteString : %@",url.absoluteString);
    NSLog(@"sourceApplication sourceApplication : %@",sourceApplication);
    
    return TRUE;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSMutableString* token = [[NSMutableString alloc]initWithFormat:@"%@",deviceToken];
    [token setString:[token stringByReplacingOccurrencesOfString:@"<" withString:@""]];
    [token setString:[token stringByReplacingOccurrencesOfString:@">" withString:@""]];
    [token setString:[token stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
    _deviceApnsToken = [NSString stringWithString:token];
    NSLog(@"_deviceApnsToken %@",_deviceApnsToken);
    ViewController* viewCont = (ViewController* )self.window.rootViewController;
    if (viewCont) {
        [viewCont viewDidLoad];
    }
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//#if !TARGET_IPHONE_SIMULATOR
    
    NSLog(@"Remote Notification: %@", [userInfo description]);
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    //NSString* storyId = [[userInfo objectForKey:@"reply"] objectForKey:@"story_id"];
    if ([userInfo objectForKey:@"reply"]) {
        NSString* replyStr = [userInfo objectForKey:@"reply"];
        NSDictionary* replyDic = [replyStr objectFromJSONString];
        [[StoryManager sharedSingleton] addStoryReply:replyDic];
    }else if([userInfo objectForKey:@"inbox"]){
        NSString* inboxStr = [userInfo objectForKey:@"inbox"];
        NSDictionary* inboxDic = [inboxStr objectFromJSONString];
        [[StoryManager sharedSingleton] saveStamp:inboxDic];
    }else{
        return ;
    }
    
    MainViewController* mainViewCont = (MainViewController*)self.window.rootViewController;
    /*
    if (mainViewCont && [mainViewCont isKindOfClass:[MainViewController class]]) {
        [mainViewCont applicationWillEnterForeground:application];
    }*/
     
    if (application.applicationState == UIApplicationStateActive) {
        if (mainViewCont && [mainViewCont isKindOfClass:[MainViewController class]]) {
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"이팅 도착" message:[apsInfo objectForKey:@"alert"] cancelButton:[FSBlockButton blockButtonWithTitle:@"취소" block:^ {
                
            }] otherButtons:[FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                if ([userInfo objectForKey:@"reply"]) {
                    NSString* replyStr = [userInfo objectForKey:@"reply"];
                    NSDictionary* replyDic = [replyStr objectFromJSONString];
                    [mainViewCont.listView refreshView];
                    [mainViewCont.listView goToEtingContentView:[replyDic objectForKey:@"story_id"]];
                }else if ([userInfo objectForKey:@"inbox"]) {
                    [mainViewCont.mainView refreshView];
                    [mainViewCont.mainView stampClick:NULL];
                }
                
            }], nil];
            [alert show];
        }
    } else {
        //NSString *alert = [apsInfo objectForKey:@"alert"];
        //NSString *badge = [apsInfo objectForKey:@"badge"];
        //NSString *sound = [apsInfo objectForKey:@"sound"];
        if (mainViewCont && [mainViewCont isKindOfClass:[MainViewController class]]) {
            if ([userInfo objectForKey:@"reply"]) {
                NSString* replyStr = [userInfo objectForKey:@"reply"];
                NSDictionary* replyDic = [replyStr objectFromJSONString];
                [mainViewCont.listView refreshView];
                [mainViewCont.listView goToEtingContentView:[replyDic objectForKey:@"story_id"] ];
            }else if ([userInfo objectForKey:@"inbox"]) {
                [mainViewCont.mainView refreshView];
                [mainViewCont.mainView stampClick:NULL];
            }
        }
    }
    
//#endif
}
- (void)transitionToViewController:(UIViewController *)viewController
                    withTransition:(UIViewAnimationOptions)transition
{
    [UIView transitionFromView:self.window.rootViewController.view
                          toView:viewController.view
                        duration:0.65f
                         options:transition
                      completion:^(BOOL finished){
    
                          self.window.rootViewController = viewController;
                      }];
}
@end
