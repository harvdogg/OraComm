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

- (void)setAccessToken:(NSString *)accessToken
{
    //Retain Access Token Value for Reference
    _accessToken = accessToken.copy;
    
    //Obtain Existing Header Configuration
    NSMutableDictionary *headers = (self.sessionManager && self.sessionManager.session.configuration.HTTPAdditionalHeaders ? self.sessionManager.session.configuration.HTTPAdditionalHeaders.mutableCopy : [NSMutableDictionary new]);
    
    //Add or Remove Authorization Header
    if(!accessToken || accessToken.length == 0)
    {
        if([headers.allKeys containsObject:@"Authorization"])
            [headers removeObjectForKey:@"Authorization"];
    }
    else
        [headers setObject:[NSString stringWithFormat:@"Bearer %@", accessToken] forKey:@"Authorization"];
    
    //Reinitialize Session
    [self initializeSessionManagerWithURL:self.sessionManager.baseURL headers:headers];
    
}
@end
