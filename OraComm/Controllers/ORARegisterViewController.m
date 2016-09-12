//
//  ORARegisterViewController.m
//  OraComm
//
//  Created by trent.harvey on 9/10/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import "ORARegisterViewController.h"
#import "ORAUser.h"

@interface ORARegisterViewController () <UITextFieldDelegate>
{
    IBOutlet UITextField *nameTF;
    IBOutlet UITextField *emailTF;
    IBOutlet UITextField *passwordTF;
    IBOutlet UITextField *confirmTF;
    
    UITapGestureRecognizer *keyboardExitTapRecognizer;
}

@end

@implementation ORARegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Instantiate Tap Recognizer for Keyboard Handling
    keyboardExitTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleKeyboardExitTapRecognizer:)];
}

- (void)performRegister
{
    NSLog(@"Attempting to Create Account");
    
    if(passwordTF.text.length == 0 || confirmTF.text.length == 0 || emailTF.text.length == 0 || nameTF.text.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"All fields are required in order to create an account."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        
        [nameTF becomeFirstResponder];
        
        return;
    }
    
    if(![passwordTF.text isEqual:confirmTF.text])
    {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Password and Confirm fields must be the same."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        
        [passwordTF becomeFirstResponder];
        
        return;
    }
    
    ORAUser *user = [[ORAUser alloc] initWithEmail:emailTF.text];
    user.name = nameTF.text;
    
    [user registerWithPassword:passwordTF.text confirm:confirmTF.text
                      complete:^(bool success, ORAUser *user, NSError *error)
                                {
                                    if(success)
                                    {
                                        [self performSegueWithIdentifier:@"CompleteRegisterShowMain" sender:self];
                                    }
                                    else
                                    {
                                        [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:[NSString stringWithFormat:@"There was a problem creating your account. %@", error.localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil] show];
                                    }
                                }];
}

#pragma mark - Action Handling
- (IBAction)didPressRegister:(UIBarButtonItem *)sender
{
    [self performRegister];
}

#pragma mark - Text Field Handling
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == nameTF)
        [emailTF becomeFirstResponder];
    else if (textField == emailTF)
        [passwordTF becomeFirstResponder];
    else if (textField == passwordTF)
        [confirmTF becomeFirstResponder];
    else
        [textField resignFirstResponder];
    
    if(textField == confirmTF && passwordTF.text.length > 0 && confirmTF.text.length > 0 && emailTF.text.length > 0 && nameTF.text.length > 0)
        [self performRegister];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.view addGestureRecognizer:keyboardExitTapRecognizer];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(nameTF.isFirstResponder || emailTF.isFirstResponder || passwordTF.isFirstResponder || confirmTF.isFirstResponder)
        return;
    
    [self.view removeGestureRecognizer:keyboardExitTapRecognizer];
}

- (void)handleKeyboardExitTapRecognizer:(UITapGestureRecognizer *)recognizer
{
    
    if(nameTF.isFirstResponder)
    {
        [nameTF resignFirstResponder];
        return;
    }
    else if(emailTF.isFirstResponder)
    {
        [emailTF resignFirstResponder];
        return;
    }
    else if(passwordTF.isFirstResponder)
    {
        [passwordTF resignFirstResponder];
        return;
    }
    else if(confirmTF.isFirstResponder)
        [confirmTF resignFirstResponder];
    
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
