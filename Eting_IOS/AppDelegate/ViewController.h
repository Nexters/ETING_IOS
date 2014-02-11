//
//  ViewController.h
//  Eting_IOS
//
//  Created by Rangken on 2013. 12. 31..
//  Copyright (c) 2013년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
}
@property (weak, nonatomic) IBOutlet UIImageView* bgImgView;
@property (weak, nonatomic) IBOutlet UIImageView* spaceImgView;
- (void)AfterGetToken;
@end
