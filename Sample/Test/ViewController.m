//
//  ViewController.m
//  Test
//
//  Created by User on 24/11/2012.
//  Copyright (c) 2012 LuigiColucci. All rights reserved.
//

#import "ViewController.h"
#import <CSAddressBookUI/CSAddressBookUI.h>

@interface ViewController ()

- (void)presentMailController;
- (void)presentSMSController;

@end

@implementation ViewController

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"Multiple AB Selection";
    
    UIButton *mailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mailButton setTitle:@"Send E-mail" forState:UIControlStateNormal];
    [mailButton setFrame:CGRectMake(60., 100., 200., 44.)];
    [mailButton addTarget:self action:@selector(presentMailController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mailButton];
    
    UIButton *smsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [smsButton setTitle:@"Send SMS" forState:UIControlStateNormal];
    [smsButton setFrame:CGRectMake(60., 200., 200., 44.)];
    [smsButton addTarget:self action:@selector(presentSMSController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:smsButton];
}

- (void)presentMailController{
    
    CSPeoplePickerNavigationController *controller = [[CSPeoplePickerNavigationController alloc] initWithType:ULABContactEmail];
    controller.messageBody = @"This is a test";
    [self presentModalViewController:controller animated:YES];
}

- (void)presentSMSController{
    
    CSPeoplePickerNavigationController *controller = [[CSPeoplePickerNavigationController alloc] initWithType:ULABContactPhone];
    controller.messageBody = @"This is a test";
    [self presentModalViewController:controller animated:YES];
}

@end
