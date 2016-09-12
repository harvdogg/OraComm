//
//  ORAChatCollectionViewController.m
//  OraComm
//
//  Created by trent.harvey on 9/12/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import "ORAChatCollectionViewController.h"

#import "ORAMessageViewCell.h"
#import "ORAConversation.h"
#import "ORAMessage.h"
#import "ORAUser.h"

@interface ORAChatCollectionViewController ()
{
    NSArray *messages;
}

@end

@implementation ORAChatCollectionViewController

static NSString * const themCellReuseIdentifer = @"themCell";
static NSString * const meCellReuseIdentifier = @"meCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerClass:[ORAMessageViewCell class] forCellWithReuseIdentifier:themCellReuseIdentifer];
    [self.collectionView registerClass:[ORAMessageViewCell class] forCellWithReuseIdentifier:meCellReuseIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setConversation:(ORAConversation *)conversation
{
    //Retain Value
    _conversation = conversation;
    
    //Set Messages
    messages = conversation.messages;

    //Reload Data
    [self.collectionView reloadData];
    
    NSLog(@"Setting Conversation");
    NSLog(@"Messages: %@", messages);
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (messages ? messages.count : 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ORAMessageViewCell *cell;
    
    ORAMessage *cellMessage = [messages objectAtIndex:indexPath.row];
    
    if(cellMessage.user == [ORAUser currentUser])
        cell = (ORAMessageViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:meCellReuseIdentifier forIndexPath:indexPath];
    else
        cell = (ORAMessageViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:themCellReuseIdentifer forIndexPath:indexPath];
    
    cell.message = cellMessage;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
