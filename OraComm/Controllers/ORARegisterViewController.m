//
//  ORARegisterViewController.m
//  OraComm
//
//  Created by trent.harvey on 9/10/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import "ORARegisterViewController.h"

@interface ORARegisterViewController ()

@end

@implementation ORARegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Action Handling
- (IBAction)didPressRegister:(UIBarButtonItem *)sender
{
    NSLog(@"Attempting to Create Account");
    
    [self performSegueWithIdentifier:@"CompleteRegisterShowMain" sender:self];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

#pragma mark - Utility
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
