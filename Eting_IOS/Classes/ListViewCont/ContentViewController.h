//
//  ContentViewController.h
//  Eting_IOS
//
//  Created by Rangken on 2014. 1. 1..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ListView;
@interface ContentViewController : UIViewController
{
}
@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UILabel* dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView* bgAllImgView;
@property (weak, nonatomic) IBOutlet UIImageView* listTopBgImgView;
@property (weak, nonatomic) IBOutlet UIImageView* listMiddleBgImgView;
@property (weak, nonatomic) IBOutlet UIImageView* listBottomBgImgView;
@property (weak, nonatomic) IBOutlet UITextView* textView;
@property (weak, nonatomic) IBOutlet UIImageView* feedbackTopBgImgView;
@property (weak, nonatomic) IBOutlet UIImageView* feedbackMiddleBgImgView;
@property (weak, nonatomic) IBOutlet UIImageView* feedbackBottomBgImgView;
@property (weak, nonatomic) IBOutlet UITextView* replyTextView;


@property (weak, nonatomic) IBOutlet UIImageView* stampImgView1;
@property (weak, nonatomic) IBOutlet UIImageView* stampImgView2;
@property (weak, nonatomic) IBOutlet UIImageView* stampImgView3;
@property (weak, nonatomic) IBOutlet UIImageView* stampImgView4;
@property (weak, nonatomic) IBOutlet UIImageView* stampImgView5;
@property (weak, nonatomic) IBOutlet UIImageView* stampImgView6;
@property (weak, nonatomic) IBOutlet UIButton* reportBtn;
@property (weak, nonatomic) IBOutlet UIButton* delBtn;

@property (weak, nonatomic) ListView* parent;
@property (assign, nonatomic) NSInteger idx;
@property (strong, nonatomic) NSMutableDictionary* storyDic;
@end
