//
//  ORAChatListTableViewController.m
//  OraComm
//
//  Created by trent.harvey on 9/11/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import "ORAChatListTableViewController.h"

#import "ORAConversation.h"
#import "ORAConversationManager.h"
#import "ConversationsTableViewCell.h"
#import "ORAChatCollectionViewController.h"

@interface ORAChatListTableViewController () <UIAlertViewDelegate>
{
    NSDictionary *cData;
    NSArray *sData;
}

@end

@implementation ORAChatListTableViewController

static NSDateFormatter *df;

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleConversationsUpdateNotification:) name:@"ORAConversationsUpdateComplete" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    //Fetch Conversations
    [[ORAConversationManager sharedManager] fetchConversations];
    
    //Reload Data
    [self prepareConversationData];
}

- (void)prepareConversationData
{
    //Get All Conversations
    NSArray *conversations = [[ORAConversationManager sharedManager] allConversations];
    
    //Extract Dates
    NSArray *dates = [conversations valueForKeyPath:@"@distinctUnionOfObjects.dateString"];
    
    NSMutableDictionary *cDataTemp = [NSMutableDictionary new];
    
    //Assemble cData
    for(NSString *dString in dates)
    {
        //Find Conversations In Date
        NSArray *convosForDate = [conversations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"dateString == %@", dString]];
        
        [cDataTemp setObject:[convosForDate sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]]] forKey:dString];
    }
    
    //Set Data Source
    cData = cDataTemp;
    sData = [cData.allKeys sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:nil ascending:NO selector:@selector(compare:)]]];
    
    //Reload Data
    [self.tableView reloadData];
}

#pragma mark - Action Handlers
- (IBAction)didPressCreateNewButton:(UIBarButtonItem *)sender
{
    //Launch Create New Prompt
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Enter A Title"
                                                 message:nil
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"OK", nil];
    
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [av show];
}

#pragma mark - Responders
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == alertView.cancelButtonIndex)
        return;
    
    NSString *titleString = [alertView textFieldAtIndex:0].text;
    NSLog(@"Title Input: %@", titleString);
    
    [[ORAConversationManager sharedManager] createConversationNamed:titleString];
}

- (void)handleConversationsUpdateNotification:(NSNotification *)notification
{
    [self prepareConversationData];
}

#pragma mark - Data Source Management
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (cData ? cData.count : 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (cData && sData ? [[cData objectForKey:[sData objectAtIndex:section]] count] : 0);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //Safe Escape
    if(!sData || sData.count <= section)
        return @"";
    
    //Obtain Base Date String
    NSString *baseString = [sData objectAtIndex:section];
    
    //Format
    if(!df)
    {
        df = [[NSDateFormatter alloc] init];
        df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [df setDateFormat:@"MMM d"];
    }
    
    //Obtain Reference Date
    ORAConversation *refConversation = [[cData objectForKey:baseString] firstObject];
    NSDate *refDate = refConversation.created;
    
    return [df stringFromDate:refDate];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Obtain Cell
    ConversationsTableViewCell *cell = (ConversationsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ConversationCell" forIndexPath:indexPath];
    
    //Set Conversation to Cell
    cell.conversation = [self conversationForIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
    [self performSegueWithIdentifier:@"ShowChatMessages" sender:cell];
}

- (ORAConversation *)conversationForIndexPath:(NSIndexPath *)indexPath
{
    //Obtain Conversation
    NSString *sectionKey = [sData objectAtIndex:indexPath.section];
    ORAConversation *convo = [[cData objectForKey:sectionKey] objectAtIndex:indexPath.row];
    
    return convo;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Preparing Segue");
    
    if([sender isKindOfClass:[ConversationsTableViewCell class]])
    {
        ConversationsTableViewCell *cell = (ConversationsTableViewCell *)sender;
        
        if([segue.destinationViewController isKindOfClass:[ORAChatCollectionViewController class]])
        {
            ORAChatCollectionViewController *destinationVC = (ORAChatCollectionViewController *)segue.destinationViewController;
            destinationVC.conversation = cell.conversation;
        }
    }
    
}

#pragma mark - Utility
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    //Remove from Notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
