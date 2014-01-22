//
//  BaseView.h
//  00Promise
//
//  Created by Digitalfrog on 13. 9. 25..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BaseViewDelegate <NSObject>
@optional
- (void)viewDidSlide;
- (void)viewUnSilde;
@end

@class MainViewController;
@interface BaseView : UIView <BaseViewDelegate>
@property (nonatomic, strong) MainViewController* parentViewCont;

@end
