//
//  ConversationsTableViewCell.m
//  OraComm
//
//  Created by trent.harvey on 9/11/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import "ConversationsTableViewCell.h"

#import "ORAConversation.h"
#import "ORAMessage.h"
#import "ORAUser.h"

@interface ConversationsTableViewCell ()
{
    
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *lastMessageHeaderLabel;
    IBOutlet UILabel *lastMessagePreviewLabel;
    
}

@end

@implementation ConversationsTableViewCell

static NSDateFormatter *df;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setConversation:(ORAConversation *)conversation
{
    
    _conversation = conversation;
    
    if(!df)
    {
        df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MMM d 'at' h:mma"];
    }
    
    //Set Labels
    titleLabel.text = conversation.name;
    lastMessageHeaderLabel.text = (conversation.last_message ? [NSString stringWithFormat:@"%@ - %@", conversation.last_message.user.name, [df stringFromDate:conversation.last_message.created]] : @"No Messages Sent");
    lastMessagePreviewLabel.text = (conversation.last_message ? (conversation.last_message.message.length > 30 ? [conversation.last_message.message substringToIndex:30] : conversation.last_message.message) : @"");
    
}

@end
