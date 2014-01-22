//
//  ListCell.h
//  Eting_IOS
//
//  Created by Rangken on 2014. 1. 1..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ListView;
@interface ListCell : UITableViewCell
@property (weak, nonatomic) ListView* parentView;
@property (weak, nonatomic) IBOutlet UILabel* dateLabel;
@property (weak, nonatomic) IBOutlet UILabel* contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView* bgImgView;
@property (weak, nonatomic) IBOutlet UIButton* starBtn;
@property (weak, nonatomic) IBOutlet UIButton* btn;
@property (assign, nonatomic) NSInteger section;
@property (assign, nonatomic) NSInteger row;
@end
