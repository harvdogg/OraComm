//
//  ORAUserManager.h
//  OraComm
//
//  Created by trent.harvey on 9/11/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ORAUser;

@interface ORAUserManager : NSObject

+ (instancetype)sharedManager;

- (ORAUser *)userWithId:(NSUInteger)userId;
- (ORAUser *)userWithEmail:(NSString *)email;

- (void)registerUser:(ORAUser *)user;
- (void)unregisterUser:(ORAUser *)user;

@end
