//
//  StoryManager.h
//  Eting_IOS
//
//  Created by Rangken on 2014. 1. 4..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryManager : NSObject
{
    NSString* storyPath;
    NSString* stampPath;
    NSString* stampCountPath;
    
    NSMutableArray* storyArray;
    NSMutableDictionary* storyDicionary;
}
+ (StoryManager *)sharedSingleton;
- (BOOL)saveStory:(NSDictionary *)storyDic date:(NSString*)dateStr;
- (NSMutableArray* )getStorys;
- (BOOL)removeStory:(NSString*)storyId;
- (void)addStoryReply:(NSDictionary*)replyDic;
- (NSString *)getStoryForMail;
- (NSMutableDictionary*)getStoryDictionary;
- (BOOL)saveStamp:(NSDictionary *)dic;
- (NSMutableArray *)getStamps;
- (BOOL)removeStamp:(NSString*)storyId;
- (NSString*)todayKey;
- (NSString*)yearMonthKey:(NSString*)dateStr;
@end
