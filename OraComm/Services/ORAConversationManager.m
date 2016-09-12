//
//  ORAConversationManager.m
//  OraComm
//
//  Created by trent.harvey on 9/11/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import "ORAConversationManager.h"

#import "ORAHTTPClient.h"
#import "ORAConversation.h"
#import "ORAMessage.h"

@interface ORAConversationManager ()
{
    NSMutableArray <ORAConversation *> *mConversations;
}

@end

@implementation ORAConversationManager

#pragma mark - Initialization
+ (instancetype)sharedManager
{
    static dispatch_once_t p = 0;
    __strong static ORAConversationManager *_sharedManager = nil;
    
    dispatch_once(&p, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        //Initialize User Storage
        mConversations = [NSMutableArray new];
    }
    return self;
}

#pragma mark - Data Processing
- (void)parseConversations:(NSArray *)conversations
{
    NSArray *cArray = mConversations.copy;
    
    for(NSDictionary *convo in conversations)
    {
        //Create Conversations
        ORAConversation *conversation = [[ORAConversation alloc] initWithData:convo];
        
        if(![cArray containsObject:conversation])
            [mConversations addObject:conversation];
    }
    
    NSLog(@"Conversations\n%@", mConversations);
}

#pragma mark - Conversation Management
- (ORAConversation *)conversationWithId:(NSUInteger)conversationId
{
    NSArray <ORAConversation *> *matchingConvos = [mConversations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"conversationId == %lu", conversationId]];
    
    return (matchingConvos && matchingConvos.count > 0 ? matchingConvos.firstObject : nil);
}

- (void)fetchConversations
{
    [self fetchConversationsFromPage:1];
}

- (void)fetchConversationsFromPage:(NSInteger)pageNumber
{
    NSString *getPath = [NSString stringWithFormat:@"chats?page=%@", @(pageNumber)];
    
    __block NSInteger thisPage = pageNumber;
    
    [[[ORAHTTPClient defaultClient] sessionManager] GET:getPath
                                             parameters:nil
                                               progress:nil
                                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                                                        {
                                                            if(responseObject && [responseObject isKindOfClass:[NSDictionary class]])
                                                            {
                                                                NSLog(@"Server Conversations Response:\n%@", responseObject);
                                                                
                                                                NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                                                                NSArray *properties = responseDictionary.allKeys;
                                                                
                                                                if([properties containsObject:@"data"] && [responseDictionary[@"data"] isKindOfClass:[NSArray class]])
                                                                    [self parseConversations:responseDictionary[@"data"]];
                                                                
                                                                if([properties containsObject:@"pagination"])
                                                                {
                                                                    NSDictionary *paginationDict = responseDictionary[@"pagination"];
                                                                    NSInteger pageCount = [paginationDict[@"page_count"] integerValue];
                                                                    
                                                                    if(pageCount > thisPage && [paginationDict[@"has_next_page"] boolValue])
                                                                        [self fetchConversationsFromPage:(thisPage + 1)];
                                                                }
                                                            }
                                                        }
                                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
                                                        {
                                                            NSLog(@"There was a problem fetching conversations from page %ld", pageNumber);
                                                            NSLog(@"Fetch Error: %@", error.localizedDescription);
                                                        }];
}

- (void)createConversationNamed:(NSString *)conversationName
{
    
}

@end
