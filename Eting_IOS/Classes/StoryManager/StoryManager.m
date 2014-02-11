//
//  StoryManager.m
//  Eting_IOS
//
//  Created by Rangken on 2014. 1. 4..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "StoryManager.h"

@implementation StoryManager
+ (StoryManager *)sharedSingleton{
    static StoryManager *singletonClass = nil;
    if(singletonClass == nil)
    {
        @synchronized(self)
        {
            if(singletonClass == nil)
            {
                singletonClass = [[self alloc] init];
                [singletonClass initVariable];
            }
        }
    }
    return singletonClass;
}
- (void)initVariable{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    storyPath = [documentsDirectory stringByAppendingPathComponent:@"story.plist"];
    stampPath = [documentsDirectory stringByAppendingPathComponent:@"stamp.plist"];
    stampCountPath = [documentsDirectory stringByAppendingPathComponent:@"stamp_count.plist"];
    storyArray = [self getStorys];
    [self changeStoryArrayToDictionary];
    //storyDicionary = [self getStoryDictionary];
}
- (BOOL)saveStory:(NSDictionary *)receiveDic date:(NSString*)dateStr{
    NSMutableArray* storyArr = [NSMutableArray arrayWithContentsOfFile:storyPath];
    if (storyArr == NULL) {
        storyArr = [[NSMutableArray alloc] init];
    }
    [storyArr insertObject:receiveDic atIndex:0];
    BOOL isSaved = [storyArr writeToFile:storyPath atomically:YES];
    if (!isSaved) {
        return FALSE;
    }
    if (storyArray == NULL) {
        storyArray = [[NSMutableArray alloc] init];
    }
    
    [storyArray insertObject:receiveDic atIndex:0];
    if (storyDicionary == NULL) {
        storyDicionary = [[NSMutableDictionary alloc] init];
    }
    /*
    NSMutableArray* todayStoryArr = [storyDicionary objectForKey:dateStr];
    if (todayStoryArr == NULL) {
        todayStoryArr = [[NSMutableArray alloc] init];
    }
    [todayStoryArr insertObject:receiveDic atIndex:0];
    [storyDicionary setObject:todayStoryArr forKey:dateStr];
     */
    [self changeStoryArrayToDictionary];
    return TRUE;
}
- (NSMutableArray* )getStorys{
    if (storyArray == NULL) {
        NSMutableArray* storySaveArr = [NSMutableArray arrayWithContentsOfFile:storyPath];
        storyArray = storySaveArr;
    }
    return [storyArray mutableCopy];
}
- (BOOL)removeStory:(NSString*)storyId{
    NSMutableArray *storyArr = [NSMutableArray arrayWithContentsOfFile:storyPath];
    if (storyArr == NULL) {
        storyArr = [[NSMutableArray alloc] init];
    }
    for (NSDictionary* dic in storyArr) {
        if ([[dic objectForKey:@"story_id"] isEqualToString:storyId]) {
            [storyArr removeObject:dic];
            
            BOOL save = [storyArr writeToFile:storyPath atomically:YES];
            if (!save) {
                return FALSE;
            }
            storyArray = storyArr;
            [self changeStoryArrayToDictionary];
            return TRUE;
        }
    }
    return FALSE;
}
- (void)addStoryReply:(NSDictionary*)replyDic{
    NSMutableArray *storyArr = [NSMutableArray arrayWithContentsOfFile:storyPath];
    if (storyArr == NULL) {
        storyArr = [[NSMutableArray alloc] init];
    }
    for (NSMutableDictionary* dic in storyArr) {
        if ([[dic objectForKey:@"story_id"] isEqualToString:[replyDic objectForKey:@"story_id"]]) {
            if ([dic objectForKey:@"reply"] == NULL) {
                [dic setObject:replyDic forKey:@"reply"];
            }
        }
    }
    storyArray = storyArr;
    [self changeStoryArrayToDictionary];
    [storyArr writeToFile:storyPath atomically:YES];
}
- (void)removeStoryReply:(NSDictionary*)replyDic{
    NSMutableArray *storyArr = [NSMutableArray arrayWithContentsOfFile:storyPath];
    if (storyArr == NULL) {
        storyArr = [[NSMutableArray alloc] init];
    }
    for (NSMutableDictionary* dic in storyArr) {
        if ([[dic objectForKey:@"story_id"] isEqualToString:[replyDic objectForKey:@"story_id"]]) {
            [dic removeObjectForKey:@"reply"];
        }
    }
    storyArray = storyArr;
    [self changeStoryArrayToDictionary];
    [storyArr writeToFile:storyPath atomically:YES];
}
- (NSString *)getStoryForMail{
    NSMutableArray *storyArr = [NSMutableArray arrayWithContentsOfFile:storyPath];
    if (storyArr == NULL) {
        return @"";
    }
    NSMutableString* str = [[NSMutableString alloc] init];
    for (NSMutableDictionary* dic in storyArr) {
        [str appendString:[NSString stringWithFormat:@"%@ %@\n%@\n\n",[dic objectForKey:@"story_date"],[dic objectForKey:@"story_time"],[dic objectForKey:@"content"]]];
    }
    return str;
}
- (NSMutableDictionary*)getStoryDictionary{
    if (storyDicionary == NULL) {
        storyDicionary = [[NSMutableDictionary alloc] init];
    }
    return [[NSMutableDictionary alloc] initWithDictionary:storyDicionary copyItems:TRUE];
}
- (void)changeStoryArrayToDictionary{
    if (storyArray == NULL) {
        storyDicionary = NULL;
    }else{
        storyDicionary = [[NSMutableDictionary alloc] init];
        for (NSDictionary* dic in storyArray) {
            NSString* dateStr = [dic objectForKey:@"story_date"];
            NSString* dateEnumeratorStr = [[StoryManager sharedSingleton] yearMonthKey:dateStr];
            NSMutableArray* dateStoryArr = [storyDicionary objectForKey:dateEnumeratorStr];
            if (dateStoryArr == NULL) {
                dateStoryArr = [[NSMutableArray alloc] init];
            }
            [dateStoryArr addObject:dic];
            [storyDicionary setObject:dateStoryArr forKey:dateEnumeratorStr];
        }
    }
    
}

- (BOOL)saveStamp:(NSDictionary *)dic{
    NSMutableArray *stampArr = [NSMutableArray arrayWithContentsOfFile:stampPath];
    if (stampArr == NULL) {
        stampArr = [[NSMutableArray alloc] init];
    }
    [stampArr insertObject:dic atIndex:0];
    BOOL save = [stampArr writeToFile:stampPath atomically:YES];
    if (!save) {
        return FALSE;
    }
    return TRUE;
}
- (NSMutableArray *)getStamps{
    NSMutableArray *stampArr = [NSMutableArray arrayWithContentsOfFile:stampPath];
    if( stampArr == nil ){
        NSLog(@"failed to retrieve dictionary from disk");
    }
    return stampArr;
}
- (BOOL)removeStamp:(NSString*)storyId{
    NSMutableArray *stampArr = [NSMutableArray arrayWithContentsOfFile:stampPath];
    if (stampArr == NULL) {
        stampArr = [[NSMutableArray alloc] init];
    }
    for (NSDictionary* dic in stampArr) {
        if ([[dic objectForKey:@"story_id"] isEqualToString:storyId]) {
            [stampArr removeObject:dic];
            BOOL save = [stampArr writeToFile:stampPath atomically:YES];
            if (!save) {
                return FALSE;
            }
            return TRUE;
        }
    }
    return FALSE;
}
- (NSInteger)getTimeBackIdx{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *date = [NSDate date];//datapicker date
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    NSInteger hour = [dateComponents hour];
    int backGroundIdx = 3;
    if (hour < 6) {
        backGroundIdx = 3;
    }else if(hour < 12 ){
        backGroundIdx = 2;
    }else if(hour < 24){
        backGroundIdx = 1;
    }else{
        backGroundIdx = 3;
    }
    return backGroundIdx;
}
- (NSString*)todayKey{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *date = [NSDate date];//datapicker date
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    
    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
    return [NSString stringWithFormat:@"%li-%02li",(long)year,(long)month];
}
- (NSString*)yearMonthKey:(NSString*)dateStr{
    NSMutableString* str = [[NSMutableString alloc] initWithString:dateStr];
    return [str substringToIndex:7];
    //return @"";
}
@end
