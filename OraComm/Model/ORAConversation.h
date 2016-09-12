//
//  ORAConversation.h
//  OraComm
//
//  Created by trent.harvey on 9/10/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ORAMessage, ORAUser;

@interface ORAConversation : NSObject

//Conversation Properties
@property (nonatomic, assign, readonly) NSUInteger conversationId;
@property (nonatomic, assign, readonly) NSUInteger userId;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSDate *created;

//Cross References
@property (nonatomic, strong, readonly) ORAUser *user;
@property (nonatomic, strong, readonly) ORAMessage *last_message;
@property (nonatomic, strong, readonly) NSArray <ORAMessage *> *messages;

//Conversation Methods
- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithData:(NSDictionary *)data;

- (ORAMessage *)sendMessage:(NSString *)message;

- (void)fetchLatestMessages;
- (void)fetchPreviousMessages;
- (ORAMessage *)messageWithId:(NSUInteger)messageId;

@end
