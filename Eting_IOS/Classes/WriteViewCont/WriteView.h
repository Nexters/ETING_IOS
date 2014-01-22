//
//  WriteView.h
//  Eting_IOS
//
//  Created by Rangken on 2014. 1. 1..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@interface WriteView : BaseView < UITextViewDelegate >
{
    CGPoint etingBtnPoint;
    CGPoint bgImg2Point;
    UITapGestureRecognizer* tap;
}
@property (weak, nonatomic) IBOutlet UITextView* textView;
@property (weak, nonatomic) IBOutlet UILabel* dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView* writeBgImgView;
@property (weak, nonatomic) IBOutlet UIImageView* spaceImgView;
@property (weak, nonatomic) IBOutlet UIButton* backBtn;
@property (weak, nonatomic) IBOutlet UIButton* etingBtn;
@property (weak, nonatomic) IBOutlet UIImageView* bgImgView1;
@property (weak, nonatomic) IBOutlet UIImageView* bgImgView2;
- (void)refreshView;
@end
