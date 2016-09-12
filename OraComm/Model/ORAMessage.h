//
//  ORAMessage.h
//  OraComm
//
//  Created by trent.harvey on 9/10/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ORAUser, ORAConversation;

@interface ORAMessage : NSObject

//Message Properties
@property (nonatomic, assign, readonly) NSUInteger messageId;
@property (nonatomic, copy, readonly) NSString *message;
@property (nonatomic, copy, readonly) NSDate *created;

//Cross References
@property (nonatomic, retain, readonly) ORAUser *user;
@property (nonatomic, retain, readonly) ORAConversation *conversation;

//Message Methods
- (instancetype)initWithData:(NSString *)data;
- (instancetype)initWithMessage:(NSString *)message inConversation:(ORAConversation *)conversation;

@end
