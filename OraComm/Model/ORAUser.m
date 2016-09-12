//
//  ORAUser.m
//  OraComm
//
//  Created by trent.harvey on 9/10/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import "ORAUser.h"

#import "ORAHTTPClient.h"
#import "ORAUserManager.h"

@implementation ORAUser

static ORAUser *currentUser;

#pragma mark - User State Management
+ (instancetype)currentUser
{
    return currentUser;
}

- (void)becomeCurrentUser
{
    if(currentUser)
        [currentUser resignCurrentUser];
    
    currentUser = self;
}

- (void)resignCurrentUser
{
    if(currentUser && currentUser != self)
        return;
    
    currentUser = nil;
}

#pragma mark - Initialization
- (instancetype)initWithData:(NSDictionary *)data
{
    ORAUser *existingUser;
    
    //Attempt to Find Duplicate with ID
    if([data.allKeys containsObject:@"id"])
        existingUser = [[ORAUserManager sharedManager] userWithId:[data[@"id"] unsignedIntegerValue]];
    
    //Attempt to Find Duplicate with E-Mail
    if(!existingUser && [data.allKeys containsObject:@"email"])
        existingUser = [[ORAUserManager sharedManager] userWithEmail:data[@"email"]];
    
    //Create New
    if(!existingUser)
    {
        //Obtain New Reference
        self = [super init];
        
        //Register Self with Manager
        [[ORAUserManager sharedManager] registerUser:self];
    }
    else
        self = existingUser;
    
    if(self)
    {
        
        //Parse Data
        [self parseData:data];
        
    }
    
    return self;
}

- (instancetype)initWithEmail:(NSString *)email
{
    //Look for Duplicate
    ORAUser *existingUser = [[ORAUserManager sharedManager] userWithEmail:email];
    
    if(!existingUser)
    {
        self = [super init];
        
        [[ORAUserManager sharedManager] registerUser:self];
    }
    else
        self = existingUser;
    
    if(self)
    {
        //Retain E-Mail Value
        _email = email;
    }
    return self;
}

#pragma mark - Information
- (NSString *)description
{
    return [NSString stringWithFormat:@"User %@ (%@) [%lu]", self.name, self.email, self.userId];
}

#pragma mark - Data Manipulation
- (void)parseData:(NSDictionary *)data
{
    //Verify Object Type for Safety
    if(!data || ![data isKindOfClass:[NSDictionary class]])
        return;
    
    NSArray *properties = data.allKeys;
    
    if([properties containsObject:@"id"] && [data[@"id"] isKindOfClass:[NSNumber class]])
        _userId = [data[@"id"] unsignedIntegerValue];
    
    if([properties containsObject:@"token"] && [data[@"token"] isKindOfClass:[NSString class]])
        [[ORAHTTPClient defaultClient] setAccessToken:data[@"token"]];
    
    if([properties containsObject:@"email"] && [data[@"email"] isKindOfClass:[NSString class]])
        _email = data[@"email"];
    
    if([properties containsObject:@"name"] && [data[@"name"] isKindOfClass:[NSString class]])
        _name = data[@"name"];
}

#pragma mark - API Interaction
- (void)authenticateWithPassword:(NSString *)password complete:(UserOperationComplete)complete
{
    NSLog(@"Authenticating User \"%@\"", self.email);
    
    //Verify Essential Information
    if(!self.email || self.email.length == 0 || !password || password.length == 0)
    {
        NSLog(@"Missing Essential Information. Authentication Aborted!");
        if(complete)
            complete(NO, nil, [NSError errorWithDomain:@"com.orainteractive.errors.missingInformation" code:10404 userInfo:@{@"message": @"Missing required e-mail or password value."}]);
        
        return;
    }
    
    [[[ORAHTTPClient defaultClient] sessionManager] POST:@"users/login"
                                              parameters:@{@"email": self.email, @"password": password}
                                                progress:nil
                                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                                                        {
                                                            NSLog(@"Authentication Succeeded!");
                                                            NSLog(@"Response Information:\n %@", responseObject);
                                                            
                                                            if(responseObject && [responseObject isKindOfClass:[NSDictionary class]])
                                                            {
                                                                NSArray *properties = [(NSDictionary *)responseObject allKeys];
                                                                
                                                                if([properties containsObject:@"data"])
                                                                    [self parseData:responseObject[@"data"]];
                                                            }
                                                            
                                                            [self becomeCurrentUser];
                                                            
                                                            if(complete)
                                                                complete(YES, self, nil);
                                                        }
                                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
                                                        {
                                                            NSLog(@"Authentication Failed with Errors: %@", error.localizedDescription);
                                                            
                                                            if(complete)
                                                                complete(NO, nil, error);
                                                        }];

    
}

- (void)registerWithPassword:(NSString *)password confirm:(NSString *)confirm complete:(UserOperationComplete)complete
{
    NSLog(@"Creating: %@", self);
    
    //Verify Essential Information
    if(!self.email || self.email.length == 0 || !password || password.length == 0 || !confirm || confirm.length == 0 || !self.name || self.name.length == 0)
    {
        NSLog(@"Missing Essential Information. Registration Aborted!");
        if(complete)
            complete(NO, nil, [NSError errorWithDomain:@"com.orainteractive.errors.missingInformation" code:10404 userInfo:@{@"message": @"Missing required name, e-mail, password or password confirm value."}]);
        
        return;
    }
    
    [[[ORAHTTPClient defaultClient] sessionManager] POST:@"users/register"
                                              parameters:@{@"name": self.name, @"email": self.email, @"password": password, @"confirm": confirm}
                                                progress:nil
                                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                                                        {
                                                            NSLog(@"Creation Succeeded!");
                                                            NSLog(@"Response Information:\n %@", responseObject);
                                                            
                                                            if(responseObject && [responseObject isKindOfClass:[NSDictionary class]])
                                                            {
                                                                NSArray *properties = [(NSDictionary *)responseObject allKeys];
                                                                
                                                                if([properties containsObject:@"data"])
                                                                    [self parseData:responseObject[@"data"]];
                                                            }
                                                            
                                                            [self becomeCurrentUser];
                                                            
                                                            if(complete)
                                                                complete(YES, self, nil);
                                                        }
                                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
                                                        {
                                                            NSLog(@"Creation Failed with Errors: %@", error.localizedDescription);
                                                            
                                                            if(complete)
                                                                complete(NO, nil, error);
                                                        }];
}

- (void)saveWithPassword:(NSString *)password confirm:(NSString *)confirm complete:(UserOperationComplete)complete
{
    NSLog(@"Saving: %@", self);
    
    //Verify Essential Information
    if(!self.email || self.email.length == 0 || !self.name || self.name.length == 0)
    {
        NSLog(@"Missing Essential Information. Save Aborted!");
        
        if(complete)
            complete(NO, nil, [NSError errorWithDomain:@"com.orainteractive.errors.missingInformation" code:10404 userInfo:@{@"message": @"Missing required name, e-mail, password or password confirm value."}]);
        
        return;
    }
    
    //Blank Passwords if Invalid
    if(!password || password.length == 0 || !confirm || confirm.length == 0 || ![password isEqualToString:confirm])
    {
        password = @"";
        confirm = @"";
    }
    
    [[[ORAHTTPClient defaultClient] sessionManager] PUT:@"users/me"
                                             parameters:@{@"name": self.name, @"email": self.email, @"password": password, @"confirm": confirm}
                                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                                                        {
                                                            NSLog(@"Save Succeeded!");
                                                            NSLog(@"Response Information:\n %@", responseObject);
                                                            
                                                            if(responseObject && [responseObject isKindOfClass:[NSDictionary class]])
                                                            {
                                                                NSArray *properties = [(NSDictionary *)responseObject allKeys];
                                                                
                                                                if([properties containsObject:@"data"])
                                                                    [self parseData:responseObject[@"data"]];
                                                            }
                                                            
                                                            if(complete)
                                                                complete(YES, self, nil);
                                                        }
                                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
                                                        {
                                                            NSLog(@"Save Failed with Errors: %@", error.localizedDescription);
                                                            
                                                            if(complete)
                                                                complete(NO, self, error);
                                                        }];
}

- (void)revert
{
    NSLog(@"Reverting User Information");
    [[[ORAHTTPClient defaultClient] sessionManager] GET:@"users/me"
                                             parameters:nil
                                               progress:nil
                                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                                                        {
                                                            NSLog(@"User Successfully Reverted");
                                                            
                                                            if(responseObject && [responseObject isKindOfClass:[NSDictionary class]])
                                                            {
                                                                NSArray *properties = [(NSDictionary *)responseObject allKeys];
                                                                
                                                                if([properties containsObject:@"data"])
                                                                    [self parseData:responseObject[@"data"]];
                                                            }
                                                        }
                                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
                                                        {
                                                            NSLog(@"Error While Reverting User: %@", error.localizedDescription);
                                                        }];
    
}

@end
