//
//  ORAAccountViewController.m
//  OraComm
//
//  Created by trent.harvey on 9/10/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import "ORAAccountViewController.h"

@interface ORAAccountViewController ()

@end

@implementation ORAAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Action Handling
- (IBAction)didPressSave:(UIBarButtonItem *)sender
{
    NSLog(@"Attempting to Save Account Information");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Utility
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
