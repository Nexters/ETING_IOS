//
//  PasswordViewController.m
//  Eting_IOS
//
//  Created by Rangken on 2014. 1. 1..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "PasswordViewController.h"
#import "AppDelegate.h"
#import <FSExtendedAlertKit.h>
@interface PasswordViewController ()

@end

@implementation PasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(_type == PASSWORD_VIEWCONT_CHANGE){
        [_backBtn setHidden:FALSE];
    }
	// Do any additional setup after loading the view.
}
- (IBAction)passwordClick:(id)sender{
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"Password"] isEqualToString:_textField.text]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if (_type == PASSWORD_VIEWCONT_INIT) {
            UIViewController* viewCont = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
            AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
            [delegate transitionToViewController:viewCont withTransition:UIViewAnimationOptionTransitionCrossDissolve];
        }else if(_type == PASSWORD_VIEWCONT_RESUME){
            AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
            [delegate.window.rootViewController dismissViewControllerAnimated:TRUE completion:nil];
        }else if(_type == PASSWORD_VIEWCONT_CHANGE){
            UIViewController* presentingViewController = self.presentingViewController;
            [self dismissViewControllerAnimated:FALSE completion:^(void){
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                UIViewController* viewCont = [storyboard instantiateViewControllerWithIdentifier:@"PasswordSettingViewController"];
                viewCont.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [presentingViewController presentViewController:viewCont animated:TRUE completion:NULL];
            }];
        }
    }else{
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"이팅" message:@"패스워드를 재대로 입력해주세요." cancelButton:[FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            
        }] otherButtons: nil];
        [alert show];
        _textField.text = @"";
    }
}
- (IBAction)backClick:(id)sender{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return TRUE;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return TRUE;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
- (void)textViewDidChange:(UITextView *)textView{
    //[textView scrollRangeToVisible:[textView selectedRange]];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= 4 || returnKey;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
