//
//  ORAMessage.m
//  OraComm
//
//  Created by trent.harvey on 9/10/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import "ORAMessage.h"

#import "ORAUser.h"
#import "ORAHTTPClient.h"
#import "ORAConversation.h"
#import "ORAConversationManager.h"

@implementation ORAMessage

static NSDateFormatter *df;

- (instancetype)initWithData:(NSDictionary *)data conversation:(ORAConversation *)conversation
{
    
    ORAMessage *existingMessage;
    
    //Extract ID
    NSUInteger messageID = [data[@"id"] unsignedIntegerValue];
    
    //Converastion
    existingMessage = [conversation messageWithId:messageID];
    
    if(existingMessage)
        self = existingMessage;
    else
    {
        self = [super init];
        
        [self setup];
        
        _conversation = conversation;
    }
    
    if(self)
    {
        [self parseData:data];
    }
    return self;
}

- (instancetype)initWithMessage:(NSString *)message inConversation:(ORAConversation *)conversation
{
    self = [super init];
    if(self)
    {
        [self setup];
        
        _message = message;
        _conversation = conversation;
        _created = [NSDate date];
        _user = [ORAUser currentUser];
     
        [[[ORAHTTPClient defaultClient] sessionManager] POST:[NSString stringWithFormat:@"chats/%lu/messages", conversation.conversationId]
                                                  parameters:@{@"message": message}
                                                    progress:nil
                                                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                                                            {
                                                                NSLog(@"Sent Message \"%@\"", message);
                                                                
                                                                if(responseObject && [responseObject isKindOfClass:[NSDictionary class]])
                                                                {
                                                                    
                                                                    NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                                                                    NSArray *properties = responseDictionary.allKeys;
                                                                    
                                                                    if([properties containsObject:@"data"])
                                                                        [self parseData:responseDictionary[@"data"]];
                                                                    
                                                                }
                                                            }
                                                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
                                                            {
                                                                NSLog(@"Failed to Send Message \"%@\": %@", message, error.localizedDescription);
                                                            }];
    }
    return self;
}

- (void)setup
{
    if(!df)
    {
        df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    }
}

- (void)parseData:(NSDictionary *)data
{
    //Extract Keys for Verification
    NSArray *properties = data.allKeys;
    
    //Parse ID
    if([properties containsObject:@"id"])
        _messageId = [data[@"id"] unsignedIntegerValue];
    
    if([properties containsObject:@"created"])
        _created = [df dateFromString:data[@"created"]];
    
    if([properties containsObject:@"message"])
        _message = data[@"message"];
    
    if([properties containsObject:@"user"])
        _user = [[ORAUser alloc] initWithData:data[@"user"]];

}

@end
