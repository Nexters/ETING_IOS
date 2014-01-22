//
//  AppDelegate.h
//  Eting_IOS
//
//  Created by Rangken on 2013. 12. 31..
//  Copyright (c) 2013년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSTimeInterval pauseTime;
    
}
@property (strong, nonatomic) NSString* deviceApnsToken;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary* launchOptions;
- (void)transitionToViewController:(UIViewController *)viewController
                    withTransition:(UIViewAnimationOptions)transition;
@end
