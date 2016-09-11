//
//  ORAHTTPClient.m
//  OraComm
//
//  Created by trent.harvey on 9/10/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import "ORAHTTPClient.h"

@implementation ORAHTTPClient

static ORAHTTPClient *defaultClient;

+ (instancetype)defaultClient
{
    return defaultClient;
}

+ (instancetype)defaultClientWithURL:(NSURL *)baseURL sharedHeaders:(NSDictionary *)sharedHeaders
{
    defaultClient = [[ORAHTTPClient alloc] initWithBaseURL:baseURL sharedHeaders:sharedHeaders];
    
    return defaultClient;
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL sharedHeaders:(NSDictionary *)sharedHeaders
{
    self = [super init];
    if(self && baseURL)
    {
        [self initializeSessionManagerWithURL:baseURL headers:sharedHeaders];
    }
    return self;
}

- (void)initializeSessionManagerWithURL:(NSURL *)url headers:(NSDictionary *)headers
{
    //Create Session Configuration Object
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //Set Headers (if provided)
    if(headers && headers.count > 0)
        [sessionConfiguration setHTTPAdditionalHeaders:headers];
    
    //Create Session Manager
    _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:sessionConfiguration];
    _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];

}
@end
