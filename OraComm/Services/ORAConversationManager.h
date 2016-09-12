//
//  ORAConversationManager.h
//  OraComm
//
//  Created by trent.harvey on 9/11/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ORAConversation;

@interface ORAConversationManager : NSObject

@property (nonatomic, retain, readonly) NSArray *allConversations;

+ (instancetype)sharedManager;

- (ORAConversation *)conversationWithId:(NSUInteger)conversationId;

- (void)fetchConversations;
- (void)createConversationNamed:(NSString *)conversationName;

@end
