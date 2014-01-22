//
//  PasswordViewController.h
//  Eting_IOS
//
//  Created by Rangken on 2014. 1. 1..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum ePasswordVCType{
    PASSWORD_VIEWCONT_INIT,
    PASSWORD_VIEWCONT_RESUME,
    PASSWORD_VIEWCONT_CHANGE,
    PASSWORD_VIEWCONT_MAX
}ePasswordVCType;
@interface PasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView* passwordBgImgView;
@property (weak, nonatomic) IBOutlet UITextField* textField;
@property (weak, nonatomic) IBOutlet UIButton* backBtn;
@property (assign, nonatomic) ePasswordVCType type;
@end
