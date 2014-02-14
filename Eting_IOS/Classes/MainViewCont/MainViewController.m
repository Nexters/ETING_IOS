//
//  MainViewController.m
//  Eting_IOS
//
//  Created by Rangken on 2013. 12. 31..
//  Copyright (c) 2013년 Nexters. All rights reserved.
//

#import "MainViewController.h"
#import "StoryManager.h"
#import "AppDelegate.h"
#import <JSONKit.h>
#import <FSExtendedAlertKit.h>
#import "AFAppDotNetAPIClient.h"
#define CLOUD1_SPEED 50
#define CLOUD2_SPEED 25
#define CLOUD3_SPEED 45
#define CLOUD4_SPEED 22
@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isViewDidApper = FALSE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSInteger backGroundIdx = [[StoryManager sharedSingleton] getTimeBackIdx];
    
    _backImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bg%02d.jpg",(int)backGroundIdx]];
    
    
    NSTimer* timer =[NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(passwordCheck:) userInfo:NULL repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    [_snowView start];
    [self startCloudAnimation];
    
    
    //[_scrollView addSubview:_listView];
    
    _state = eViewMain;
    //_scrollView.direction = PunchScrollViewDirectionHorizontal;
    //_scrollView.delegate = self;
    //_scrollView.dataSource = self;
    [_scrollView setContentSize:CGSizeMake(320*3, [[UIScreen mainScreen] bounds].size.height)];
    [_scrollView setContentOffset:CGPointMake(320,0)];
    _scrollView.scrollsToTop = NO;
    _scrollView.pagingEnabled = YES;
    _listView = [[[NSBundle mainBundle] loadNibNamed:@"ListView" owner:nil options:nil] objectAtIndex:0];
    _listView.parentViewCont = self;
    [_listView setFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
    [_scrollView addSubview:_listView];
    
    _mainView = [[[NSBundle mainBundle] loadNibNamed:@"MainView" owner:nil options:nil] objectAtIndex:0];
    _mainView.parentViewCont = self;
    NSMutableArray* stampArr = [[StoryManager sharedSingleton] getStamps];
    if ([stampArr count] != 0) {
        [_mainView.spaceShipView setAlpha:1.0f];
    }else{
        [_mainView.spaceShipView setAlpha:0.0f];
    }
    [_mainView setFrame:CGRectMake(320, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
    [_scrollView addSubview:_mainView];
    
    _writeView = [[[NSBundle mainBundle] loadNibNamed:@"WriteView" owner:nil options:nil] objectAtIndex:0];
    _writeView.parentViewCont = self;
    [_writeView setFrame:CGRectMake(320*2, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
    [_scrollView addSubview:_writeView];
    
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (delegate.launchOptions) {
        NSDictionary* userInfo = delegate.launchOptions;
        
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"이팅 도착" message:@"eting!!!" cancelButton:[FSBlockButton blockButtonWithTitle:@"취소" block:^ {
            
        }] otherButtons:[FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            if ([userInfo objectForKey:@"reply"]) {
                NSString* replyStr = [userInfo objectForKey:@"reply"];
                NSDictionary* replyDic = [replyStr objectFromJSONString];
                [_listView refreshView];
                [_listView goToEtingContentView:[replyDic objectForKey:@"story_id"]];
            }else if ([userInfo objectForKey:@"inbox"]) {
                [_mainView refreshView];
                [_mainView stampClick:NULL];
            }
            
        }], nil];
        [alert show];
    }
    [self getStoryReplyes];
}
- (void)getStoryReplyes{
    NSMutableArray* storyIdArr = [[NSMutableArray alloc] init];
    for (NSDictionary* dic in [[StoryManager sharedSingleton] getStorys]) {
        if ([dic objectForKey:@"reply"] == NULL) {
            [storyIdArr addObject:[dic objectForKey:@"story_id"]];
        }
    }
    if ([storyIdArr count] == 0) {
        return ;
    }
    NSString* storyIdsStr = [storyIdArr componentsJoinedByString:@","];
    NSLog(@"storyIdsStr : %@",storyIdsStr);
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:storyIdsStr forKey:@"storyList"];
    
    [[AFAppDotNetAPIClient sharedClient] postPath:@"eting/getCommentedStorys" parameters:parameters success:^(AFHTTPRequestOperation *response, id responseObject) {
        NSLog(@"eting/getCommentedStorys: %@",(NSDictionary *)responseObject);
        NSMutableArray* storyArr = [responseObject objectForKey:@"ReplyList"];
        for (NSDictionary* storyDic in storyArr) {
            [[StoryManager sharedSingleton] addStoryReply:storyDic];
        }
        [_listView refreshView];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        
    }];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:(BOOL)animated];
    
    [_mainView refreshView];
    [_listView refreshView];
    //[_mainView setStarTimer];
}

- (void)passwordCheck:(id)sender{
    
}
- (IBAction)leftSwipeGesutre:(id)sender{
    /*
    if (_scrollView.contentOffset.x == 0 || _scrollView.contentOffset.x == 320) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x+320, 0) animated:TRUE];
    }
     */
}

- (IBAction)rightSwipeGesture:(id)sender{
    /*
    if (_scrollView.contentOffset.x == 320 || _scrollView.contentOffset.x == 640) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x-320, 0) animated:TRUE];
    }
     */
}
- (void)startCloudAnimation{
    [self startCloudAnimation:_cloudImgView1 time:CLOUD1_SPEED];
    [self startCloudAnimation:_cloudImgView2 time:CLOUD2_SPEED];
    [self startCloudAnimation:_cloudImgView3 time:CLOUD3_SPEED];
    [self startCloudAnimation:_cloudImgView4 time:CLOUD4_SPEED];
    [self startCloudAnimation:_cloudImgView5 time:CLOUD2_SPEED];
    [self startCloudAnimation:_cloudImgView6 time:CLOUD3_SPEED];
}
- (void)startCloudAnimation:(UIImageView*)imgView time:(int)time{
    /*
    if (imgView.center.x != -imgView.frame.size.width) {
        if (_cloudImgView2 == imgView || _cloudImgView5 == imgView) {
            time = 5;
        }
    }
     */
    [UIView animateWithDuration:time
                          delay:0
                        options: UIViewAnimationOptionCurveLinear
                     animations: ^{
                         if (imgView.center.x != -imgView.frame.size.width) {
                             imgView.center = CGPointMake(320-imgView.center.x+imgView.frame.size.width, imgView.center.y);
                         }else{
                             imgView.center = CGPointMake(320+imgView.frame.size.width, imgView.center.y);
                         }
                     }
                     completion: ^(BOOL finished) {
                         imgView.center = CGPointMake(-imgView.frame.size.width, imgView.center.y);
                         [self startCloudAnimation:imgView time:time];
                     }];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    //scrollView.userInteractionEnabled = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
   //scrollView.userInteractionEnabled = YES;
    if (scrollView.contentOffset.x <= 160) {
        if (_state != eViewList) {
            [_listView viewDidSlide];
            [_mainView viewUnSilde];
            _state = eViewList;
        }
    }else if (scrollView.contentOffset.x > 160 && scrollView.contentOffset.x <= 480) {
        if (_state != eViewMain) {
            if (scrollView.contentOffset.x < 320) {
                [_listView viewUnSilde];
            }else{
                [_writeView viewUnSilde];
            }
            [_mainView viewDidSlide];
            _state = eViewMain;
        }
    }else{
        if (_state != eViewWrite) {
            [_writeView viewDidSlide];
            [_mainView viewUnSilde];
            _state = eViewWrite;
        }
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 메인뷰의 스크롤을 고정시키기 위함
    
    if (scrollView == _scrollView) {
        [scrollView setContentOffset: CGPointMake(scrollView.contentOffset.x, 0)];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{    
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [_mainView runAnimation];
    [_mainView refreshView];
    [_writeView refreshView];
    [_listView refreshView];
}
- (void)applicationDidBecomeActive:(UIApplication *)application{
    [_mainView runAnimation];
    [_mainView refreshView];
    [_writeView refreshView];
    [_listView refreshView];
    [self getStoryReplyes];
    [_mainView updateStar:NULL];
    NSInteger backGroundIdx = [[StoryManager sharedSingleton] getTimeBackIdx];
    _backImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bg%02d.jpg",(int)backGroundIdx]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
