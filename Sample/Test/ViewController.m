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

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CSPeoplePickerNavigationController *controller = [[CSPeoplePickerNavigationController alloc] initWithType:ULABContactEmail];
    controller.messageBody = @"This is a test";
    [self presentModalViewController:controller animated:YES];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
