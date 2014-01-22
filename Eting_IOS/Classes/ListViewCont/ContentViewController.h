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
@property (weak, nonatomic) IBOutlet UIImageView* bgAllImgView;
@property (weak, nonatomic) IBOutlet UIImageView* bgImgView;
@property (weak, nonatomic) IBOutlet UIImageView* bgImgView2;
@property (weak, nonatomic) IBOutlet UITextView* textView;
@property (weak, nonatomic) IBOutlet UILabel* dateLabel;
@property (weak, nonatomic) IBOutlet UITextView* replyTextView;
@property (weak, nonatomic) IBOutlet UIImageView* stampImgView1;
@property (weak, nonatomic) IBOutlet UIImageView* stampImgView2;
@property (weak, nonatomic) IBOutlet UIImageView* stampImgView3;
@property (weak, nonatomic) ListView* parent;
@property (assign, nonatomic) NSInteger idx;
@property (strong, nonatomic) NSDictionary* storyDic;
@end
