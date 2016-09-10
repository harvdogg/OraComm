//
//  ORALoginViewController.m
//  OraComm
//
//  Created by trent.harvey on 9/10/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import "ORALoginViewController.h"

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
    
}

- (IBAction)didPressRegister:(UIBarButtonItem *)sender
{
    NSLog(@"Navigating to Register View");
    [self.navigationController performSegueWithIdentifier:@"ShowRegister" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
