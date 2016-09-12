//
//  ORAConversation.m
//  OraComm
//
//  Created by trent.harvey on 9/10/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import "ORAConversation.h"

#import "ORAUser.h"
#import "ORAMessage.h"
#import "ORAHTTPClient.h"
#import "ORAConversationManager.h"

@interface ORAConversation ()
{
    NSMutableArray *mMessages;
}

@end

@implementation ORAConversation

static NSDateFormatter *df;

#pragma mark - Initialization
- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if(self)
    {
        [self setup];
        
        _name = name;
        _user = [ORAUser currentUser];
        _created = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        
        _dateString = [formatter stringFromDate:_created];
        
        [[[ORAHTTPClient defaultClient] sessionManager] POST:@"chats"
                                                  parameters:@{@"name": name}
                                                    progress:nil
                                                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                                                            {
                                                                NSLog(@"Created Chat named %@", name);
                                                                
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
                                                                NSLog(@"Failed to Create Chat Named %@: %@", name, error.localizedDescription);
                                                            }];
    }
    return self;
}

- (instancetype)initWithData:(NSDictionary *)data
{
    ORAConversation *existingConvo = [[ORAConversationManager sharedManager] conversationWithId:[data[@"id"] unsignedIntegerValue]];
    
    if(existingConvo)
        self = existingConvo;
    else
    {
        self = [super init];
        [self setup];
    }
    
    if(self)
    {
        [self parseData:data];
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
    
    mMessages = [NSMutableArray new];
}

- (void)parseData:(NSDictionary *)data
{
    NSArray *properties = data.allKeys;
    
    if([properties containsObject:@"id"])
        _conversationId = [data[@"id"] unsignedIntegerValue];
    
    if([properties containsObject:@"name"])
        _name = data[@"name"];
    
    if([properties containsObject:@"created"])
    {
        _created = [df dateFromString:data[@"created"]];
        _dateString = [data[@"created"] substringToIndex:10];
    }
    
    if([properties containsObject:@"user"])
        _user = [[ORAUser alloc] initWithData:data[@"user"]];
    
    if([properties containsObject:@"last_message"])
    {
        ORAMessage *lastMessage = [[ORAMessage alloc] initWithData:data[@"last_message"] conversation:self];
        
        if(![mMessages containsObject:lastMessage])
            [mMessages insertObject:lastMessage atIndex:0];
    }
}

#pragma mark - Operational
- (ORAMessage *)sendMessage:(NSString *)message
{
    return nil;
}

- (void)fetchLatestMessages
{
    
}

- (void)fetchPreviousMessages
{
    
}

- (ORAMessage *)last_message
{
    if(!mMessages || mMessages.count == 0)
        return nil;
    
    return mMessages.firstObject;
}

 - (ORAMessage *)messageWithId:(NSUInteger)messageId
{
    NSArray <ORAMessage *> *matchingMsgs = [mMessages filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"messageId == %lu", messageId]];
    
    return (matchingMsgs && matchingMsgs.count > 0 ? matchingMsgs.firstObject : nil);
}

- (NSArray<ORAMessage *> *)messages
{
    return (mMessages ? mMessages.copy : [[NSArray alloc] init]);
}

#pragma mark - Utility
- (NSString *)description
{
    return [NSString stringWithFormat:@"Conversation \"%@\" by %@ (%lu Messages)[Created: %@]", self.name, self.user.name, mMessages.count, self.created];
}
@end
