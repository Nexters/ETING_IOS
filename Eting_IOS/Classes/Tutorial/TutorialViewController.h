//
//  TutorialViewController.h
//  Eting_IOS
//
//  Created by Rangken on 2014. 1. 16..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum eTutorialType{
    TUTORIAL_INIT,
    TUTORIAL_SETTING
}eTutorialType;
@interface TutorialViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UIButton* backBtn;
@property (weak, nonatomic) IBOutlet UIPageControl* pageControl;
@property (assign, nonatomic) eTutorialType type;
@end
