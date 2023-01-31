//
//  UMDnsResolvingRequest.m
//  ulibdns
//
//  Created by Andreas Fink on 07/09/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResolvingRequest.h"
#import "UMDnsName.h"
#import "UMDnsRemoteServer.h"
#import "UMDnsResourceRecord.h"


#define UMDNS_RESOLVING_REQUEST_DEFAULT_TIMEOUT_MICROSECONDS    3000000LL    /* default timeout is 3 seconds */

@implementation UMDnsResolvingRequest

-(UMDnsResolvingRequest *)init
{
    self = [super init];
    if(self)
    {
        _requestCreated = ulib_microsecondTime();
        _requestTimeoutDelay = UMDNS_RESOLVING_REQUEST_DEFAULT_TIMEOUT_MICROSECONDS;
    }
    return self;
}

- (NSString *)key
{
    if(_key==NULL)
    {
        if((_serverToQuery==NULL) || (_nameToResolve==NULL) || (_resourceType==0))
        {
            _key = [NSString stringWithFormat:@"%@:%d:%@",_serverToQuery.address,_resourceType,_nameToResolve.visualName];
        }
    }
    return _key;
}

- (NSData *)requestData
{
    NSArray *params = @[_nameToResolve];
    NSString *zone = NULL;
    
    _request = [UMDnsResourceRecord recordOfType:_resourceType
                                          params:params
                                            zone:zone];
    _requestSent = ulib_microsecondTime();
    return [_request resourceData];
}
@end
