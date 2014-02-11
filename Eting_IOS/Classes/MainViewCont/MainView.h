//
//  MainView.h
//  Eting_IOS
//
//  Created by Rangken on 2014. 1. 1..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@interface MainView : BaseView
{
    NSTimeInterval starCheckTime;
    NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet UIView* spaceShipView;
@property (weak, nonatomic) IBOutlet UIButton* spaceShipBtn;
@property (weak, nonatomic) IBOutlet UIImageView* earthImgView;
@property (weak, nonatomic) IBOutlet UIButton* starBtn;

@property (weak, nonatomic) IBOutlet UILabel* dateLabel;
@property (weak, nonatomic) IBOutlet UILabel* etingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel* stampCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView* etingTextImgView;
@property (weak, nonatomic) IBOutlet UIImageView* planetImgView;
@property (weak, nonatomic) IBOutlet UIButton* etingBtn;
@property (strong, nonatomic) NSMutableArray* stampArr;
- (void)runAnimation;
- (void)refreshView;
- (IBAction)stampClick:(id)sender;
- (void)setStarTimer;
@end
