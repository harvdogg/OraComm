//
//  ORAHTTPClient.h
//  OraComm
//
//  Created by trent.harvey on 9/10/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface ORAHTTPClient : NSObject

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, strong, readonly) AFHTTPSessionManager *sessionManager;

+ (instancetype)defaultClient;
+ (instancetype)defaultClientWithURL:(NSURL *)baseURL sharedHeaders:(NSDictionary *)sharedHeaders;

- (instancetype)initWithBaseURL:(NSURL *)baseURL sharedHeaders:(NSDictionary *)sharedHeaders;

@end
