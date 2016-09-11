//
//  ORAAccountViewController.m
//  OraComm
//
//  Created by trent.harvey on 9/10/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import "ORAAccountViewController.h"
#import "ORAUser.h"

@interface ORAAccountViewController () <UITextFieldDelegate>
{
    IBOutlet UITextField *nameTF;
    IBOutlet UITextField *emailTF;
    IBOutlet UITextField *passwordTF;
    IBOutlet UITextField *confirmTF;
    
    UITapGestureRecognizer *keyboardExitTapRecognizer;
}

@end

@implementation ORAAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    if([ORAUser currentUser])
    {
        nameTF.text = [ORAUser currentUser].name;
        emailTF.text = [ORAUser currentUser].email;
    }
}

- (void)commitUserInformation
{
    NSLog(@"Attempting to Save Account Information");
    
    if([ORAUser currentUser])
    {
        [[ORAUser currentUser] saveWithPassword:passwordTF.text
                                        confirm:confirmTF.text
                                       complete:^(bool success, ORAUser *user, NSError *error)
                                                {
                                                    if(success)
                                                    {
                                                        [[[UIAlertView alloc] initWithTitle:@"Success!"
                                                                                    message:@"Your information was saved!"
                                                                                   delegate:nil
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil] show];
                                                    }
                                                    else
                                                    {
                                                        [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                                    message:[NSString stringWithFormat:@"There was a problem saving your information. %@", error.localizedDescription]
                                                                                   delegate:nil
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil] show];
                                                    }
                                                }];
    }
}

#pragma mark - Action Handling
- (IBAction)didPressSave:(UIBarButtonItem *)sender
{
    [self commitUserInformation];
}

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
