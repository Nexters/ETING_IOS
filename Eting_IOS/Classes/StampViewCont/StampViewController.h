//
//  StampViewController.h
//  Eting_IOS
//
//  Created by Rangken on 2014. 1. 1..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainView;
@interface StampViewController : UIViewController{
    NSDictionary* stampDic;
    UITapGestureRecognizer* tap;
    CGRect originalRect;
    CGSize originalSize;
}
@property (weak, nonatomic) IBOutlet UITextView* contentTextView;
@property (weak, nonatomic) IBOutlet UILabel* dateLabel;
@property (weak, nonatomic) IBOutlet UIButton* reportBtn;
@property (weak, nonatomic) IBOutlet UIButton* stampBtn1;
@property (weak, nonatomic) IBOutlet UIButton* stampBtn2;
@property (weak, nonatomic) IBOutlet UIButton* stampBtn3;
@property (weak, nonatomic) IBOutlet UIButton* stampBtn4;
@property (weak, nonatomic) IBOutlet UIButton* stampBtn5;
@property (weak, nonatomic) IBOutlet UIButton* stampBtn6;
@property (weak, nonatomic) IBOutlet UILabel* emptyWriteLabel;
@property (weak, nonatomic) IBOutlet UITextView* writeTextView;
@property (weak, nonatomic) IBOutlet UIImageView* bgImgView1;
@property (weak, nonatomic) IBOutlet UIView* writeView;
@property (weak, nonatomic) IBOutlet UIView* imoticonView;
@property (strong, nonatomic) MainView* mainView;
@end
