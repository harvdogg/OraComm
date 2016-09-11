//
//  ORALoginViewController.m
//  OraComm
//
//  Created by trent.harvey on 9/10/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import "ORALoginViewController.h"
#import "ORAUser.h"

@interface ORALoginViewController () <UITextFieldDelegate>
{
    IBOutlet UITextField *emailTF;
    IBOutlet UITextField *passwordTF;
    
    UITapGestureRecognizer *keyboardExitTapRecognizer;
}

@end

@implementation ORALoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Instantiate Tap Recognizer for Keyboard Handling
    keyboardExitTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleKeyboardExitTapRecognizer:)];
}

- (void)performLogin
{
    NSLog(@"Attempting to Authenticate with Credentials");
    
    //Verify Values
    if([emailTF.text isEqualToString:@""] || emailTF.text.length == 0 || [passwordTF.text isEqualToString:@""] || passwordTF.text.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                   message:@"You must provide a username and password in order to login."
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    //Create User Object and Attempt Login
    ORAUser *user = [[ORAUser alloc] init];
    user.email = emailTF.text;
    
    [user authenticateWithPassword:passwordTF.text
                          complete:^(bool success, ORAUser *user, NSError *error)
                                    {
                                        if(success)
                                        {
                                            //Navigate to Main
                                            [self performSegueWithIdentifier:@"CompleteLoginShowMain" sender:self];
                                        }
                                        else
                                        {
                                            [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:[NSString stringWithFormat:@"There was a problem signing you in. %@", error.localizedDescription]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil] show];
                                        }
                                    }];
}

#pragma mark - Action Handling
- (IBAction)didPressLogin:(UIBarButtonItem *)sender
{
    [self performLogin];
}

#pragma mark - Text Field Handling
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == emailTF)
        [passwordTF becomeFirstResponder];
    else
        [textField resignFirstResponder];
    
    if(textField == passwordTF && passwordTF.text.length > 0 && emailTF.text.length > 0)
        [self performLogin];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.view addGestureRecognizer:keyboardExitTapRecognizer];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(emailTF.isFirstResponder || passwordTF.isFirstResponder)
        return;
    
    [self.view removeGestureRecognizer:keyboardExitTapRecognizer];
}

- (void)handleKeyboardExitTapRecognizer:(UITapGestureRecognizer *)recognizer
{
    if(emailTF.isFirstResponder)
        [emailTF resignFirstResponder];
    
    if(passwordTF.isFirstResponder)
        [passwordTF resignFirstResponder];
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
