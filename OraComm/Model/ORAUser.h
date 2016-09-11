//
//  ORAUser.h
//  OraComm
//
//  Created by trent.harvey on 9/10/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ORAUser : NSObject

typedef void (^UserOperationComplete)(bool success, ORAUser *user, NSError *error);

//User Properties
@property (nonatomic, assign, readonly) NSUInteger userId;
@property (nonatomic, copy, readonly) NSString *accessToken;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *name;

//User Methods
+ (ORAUser *)currentUser;
- (void)becomeCurrentUser;
- (void)resignCurrentUser;

- (void)authenticateWithPassword:(NSString *)password complete:(UserOperationComplete)complete;
- (void)registerWithPassword:(NSString *)password confirm:(NSString *)confirm complete:(UserOperationComplete)complete;
- (void)saveWithPassword:(NSString *)password confirm:(NSString *)confirm complete:(UserOperationComplete)complete;
- (void)revert;

@end
