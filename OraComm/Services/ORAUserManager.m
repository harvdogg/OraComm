//
//  ORAUserManager.m
//  OraComm
//
//  Created by trent.harvey on 9/11/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import "ORAUserManager.h"
#import "ORAUser.h"

@interface ORAUserManager ()
{
    NSMutableArray <ORAUser *> *mUsers;
}

@end

@implementation ORAUserManager

+ (instancetype)sharedManager
{
    static dispatch_once_t p = 0;
    __strong static ORAUserManager *_sharedManager = nil;
    
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
        mUsers = [NSMutableArray new];
    }
    return self;
}

- (ORAUser *)userWithId:(NSUInteger)userId
{
    if(userId == 0)
        return nil;
    
    NSArray <ORAUser *> *matchingUsers = [mUsers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"userId == %lu", userId]];
    
    return (matchingUsers && matchingUsers.count != 0 ? matchingUsers.firstObject : nil);
}

- (ORAUser *)userWithEmail:(NSString *)email
{
    if(!email)
        return nil;
    
    NSArray <ORAUser *> *matchingUsers = [mUsers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"email == %@", email]];
    
    return (matchingUsers && matchingUsers.count != 0 ? matchingUsers.firstObject : nil);
}

- (void)registerUser:(ORAUser *)user
{
    if(user.userId && [self userWithId:user.userId])
        return;
    
    if(user.email && [self userWithEmail:user.email])
        return;
    
    [mUsers addObject:user];
}

- (void)unregisterUser:(ORAUser *)user
{
    if([mUsers containsObject:user])
        [mUsers removeObject:user];
}

@end
