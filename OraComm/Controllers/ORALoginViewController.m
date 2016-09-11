//
//  ORALoginViewController.m
//  OraComm
//
//  Created by trent.harvey on 9/10/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import "ORALoginViewController.h"
#import "ORAHTTPClient.h"

@interface ORALoginViewController ()

@end

@implementation ORALoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Action Handling
- (IBAction)didPressLogin:(UIBarButtonItem *)sender
{
    NSLog(@"Attempting to Login with Credentials");
    
    //Perform Navigation to Main
    [self performSegueWithIdentifier:@"CompleteLoginShowMain" sender:self];
}

#pragma mark - Navigation
- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

#pragma mark - Utility
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
