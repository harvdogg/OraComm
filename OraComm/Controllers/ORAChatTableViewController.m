//
//  ORAChatTableViewController.m
//  OraComm
//
//  Created by trent.harvey on 9/12/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import "ORAChatTableViewController.h"

#import "ORAUser.h"
#import "ORAMessage.h"
#import "ORAConversation.h"
#import "ORAMessageViewCell.h"

@interface ORAChatTableViewController () <UIAlertViewDelegate>
{
    NSArray *messages;
}

@end

@implementation ORAChatTableViewController

static NSString * const themCellReuseIdentifer = @"themCell";
static NSString * const meCellReuseIdentifier = @"meCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)reloadMessages
{
    //Set Messages
    messages = self.conversation.messages;
    
    //Reload Data
    [self.tableView reloadData];
}

#pragma mark - Handlers
- (IBAction)didPressComposeButton:(UIBarButtonItem *)sender
{
    //Launch Create New Prompt
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Compose Message"
                                                 message:nil
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"OK", nil];
    
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [av show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == alertView.cancelButtonIndex)
        return;
    
    NSString *messageString = [alertView textFieldAtIndex:0].text;
    
    [self.conversation sendMessage:messageString];
    [self reloadMessages];
}


#pragma mark - Data Operations
- (void)setConversation:(ORAConversation *)conversation
{
    //Retain Value
    _conversation = conversation;
    
    [self reloadMessages];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (messages ? messages.count : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ORAMessageViewCell *cell;
    
    ORAMessage *cellMessage = [messages objectAtIndex:indexPath.row];
    
    if(cellMessage.user == [ORAUser currentUser])
        cell = (ORAMessageViewCell *)[tableView dequeueReusableCellWithIdentifier:meCellReuseIdentifier forIndexPath:indexPath];
    else
        cell = (ORAMessageViewCell *)[tableView dequeueReusableCellWithIdentifier:themCellReuseIdentifer forIndexPath:indexPath];
    
    cell.message = cellMessage;
    
    NSLog(@"Setting Cell with Reuse %@ and Message \"%@\"", cell.reuseIdentifier, cellMessage.message);
    
    return cell;
}

@end
