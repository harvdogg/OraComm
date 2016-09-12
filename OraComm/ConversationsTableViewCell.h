//
//  ConversationsTableViewCell.h
//  OraComm
//
//  Created by trent.harvey on 9/11/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ORAConversation;

@interface ConversationsTableViewCell : UITableViewCell

@property (nonatomic, retain) ORAConversation *conversation;

@end
