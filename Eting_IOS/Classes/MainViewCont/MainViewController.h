//
//  MainViewController.h
//  Eting_IOS
//
//  Created by Rangken on 2013. 12. 31..
//  Copyright (c) 2013년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainView.h"
#import "WriteView.h"
#import "ListView.h"
#import "SnowEmitterView.h"
typedef enum {
    eViewList,
    eViewMain,
    eViewWrite
}eViewState;

@interface MainViewController : UIViewController <UIScrollViewDelegate>
{
    BOOL isViewDidApper;
}
@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UIImageView* backImgView;
@property (weak, nonatomic) IBOutlet MainView* mainView;
@property (weak, nonatomic) IBOutlet WriteView* writeView;
@property (weak, nonatomic) IBOutlet ListView* listView;
@property (weak, nonatomic) IBOutlet SnowEmitterView* snowView;
@property (weak, nonatomic) IBOutlet UIPageControl* pageControl;
@property (weak, nonatomic) IBOutlet UIImageView* cloudImgView1;
@property (weak, nonatomic) IBOutlet UIImageView* cloudImgView2;
@property (weak, nonatomic) IBOutlet UIImageView* cloudImgView3;
@property (weak, nonatomic) IBOutlet UIImageView* cloudImgView4;
@property (weak, nonatomic) IBOutlet UIImageView* cloudImgView5;
@property (weak, nonatomic) IBOutlet UIImageView* cloudImgView6;


@property (assign, nonatomic) eViewState state;
- (IBAction)leftSwipeGesutre:(id)sender;
- (IBAction)rightSwipeGesture:(id)sender;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)applicationDidBecomeActive:(UIApplication *)application;
@end
