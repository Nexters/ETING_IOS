//
//  PasswordSettingViewController.h
//  Eting_IOS
//
//  Created by Rangken on 2014. 1. 9..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettingViewController;
@interface PasswordSettingViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIView* passwordView;
@property (nonatomic, weak) IBOutlet UISwitch* passwordSwitch;
@property (nonatomic, weak) IBOutlet UIButton* doneBtn;
@property (nonatomic, weak) IBOutlet UITextField* textField1;
@property (nonatomic, weak) IBOutlet UITextField* textField2;
@property (nonatomic, weak) SettingViewController* settingViewCont;
@end
