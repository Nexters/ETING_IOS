//
//  PasswordSettingViewController.m
//  Eting_IOS
//
//  Created by Rangken on 2014. 1. 9..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "PasswordSettingViewController.h"
#import "SettingViewController.h"
#import <FSExtendedAlertKit.h>
@interface PasswordSettingViewController ()

@end

@implementation PasswordSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)backClick:(id)sender{
    [self dismissViewControllerAnimated:TRUE completion:NULL];
}

- (IBAction)submitClick:(id)sender{
    if ([_textField1.text isEqualToString:_textField2.text]) {
        [[NSUserDefaults standardUserDefaults] setObject:_textField1.text forKey:@"Password"];
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"Password_On"];
        [self dismissViewControllerAnimated:TRUE completion:nil];
    }else{
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"이팅" message:@"패스워드를 확인해주세요." cancelButton:[FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            
        }] otherButtons: nil];
        [alert show];
        _textField1.text = @"";
        _textField2.text = @"";
    }
}
- (IBAction)switchChange:(id)sender{
    UISwitch* sw = (UISwitch*)sender;
    if ([sw isOn]) {
        [_passwordView setHidden:FALSE];
        if ([[NSUserDefaults standardUserDefaults] stringForKey:@"Password"]) {
            [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"Password_On"];
        }
    }else{
        [_passwordView setHidden:TRUE];
        [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"Password"];
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"Password_On"];
    }
}
- (IBAction)doneClick:(id)sender{
    //[_textField1 resignFirstResponder];
    //[_textField2 resignFirstResponder];
    [self dismissViewControllerAnimated:FALSE completion:^(void) {
        [_settingViewCont dismissViewControllerAnimated:TRUE completion:nil];
    }];
}
- (IBAction)tap:(id)sender{
    [_textField1 resignFirstResponder];
    [_textField2 resignFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Password_On"]) {
        [_passwordSwitch setOn:TRUE];
        [_passwordView setHidden:FALSE];
    }else{
        [_passwordSwitch setOn:FALSE];
        [_passwordView setHidden:TRUE];
    }
	// Do any additional setup after loading the view.
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return TRUE;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //[_doneBtn setHidden:FALSE];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return TRUE;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    //[_doneBtn setHidden:TRUE];
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
