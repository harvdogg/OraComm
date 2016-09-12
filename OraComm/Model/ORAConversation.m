//
//  ORAConversation.m
//  OraComm
//
//  Created by trent.harvey on 9/10/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import "ORAConversation.h"

#import "ORAUser.h"
#import "ORAConversationManager.h"

@interface ORAConversation ()
{
    NSMutableArray *mMessages;
}

@end

@implementation ORAConversation

#pragma mark - Initialization
- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if(self)
    {
        [self setup];
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
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        
        _created = [formatter dateFromString:data[@"created"]];
    }
    
    if([properties containsObject:@"user"])
        _user = [[ORAUser alloc] initWithData:data[@"user"]];
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

 - (ORAMessage *)messageWithId:(NSUInteger)messageId
{
    return nil;
}

#pragma mark - Utility
- (NSString *)description
{
    return [NSString stringWithFormat:@"Conversation \"%@\" by %@ (%lu Messages)[Created: %@]", self.name, self.user.name, mMessages.count, self.created];
}
@end
