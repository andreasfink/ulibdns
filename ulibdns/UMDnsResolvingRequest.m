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

#define UMDNS_RESOLVING_REQUEST_DEFAULT_TIMEOUT_MICROSECONDS    3000000LL    /* default timeout is 3 seconds */

@implementation UMDnsResolvingRequest

@synthesize resourceType;
@synthesize queryType;
@synthesize delegate;
@synthesize serverToQuery;
@synthesize nameToResolve;
@synthesize requestCreated;
@synthesize requestSent;
@synthesize requestAnswered;
@synthesize requestTimeoutDelay;
@synthesize requestTimeoutTime;
@synthesize useStream;

-(UMDnsResolvingRequest *)init
{
    self = [super init];
    if(self)
    {
        requestCreated = ulib_microsecondTime();
        requestTimeoutDelay = UMDNS_RESOLVING_REQUEST_DEFAULT_TIMEOUT_MICROSECONDS;
    }
    return self;
}

- (NSString *)key
{
    if(key==NULL)
    {
        if((serverToQuery==NULL) || (nameToResolve==NULL) || (resourceType==0))
        {
            key = [NSString stringWithFormat:@"%@:%d:%@",serverToQuery.address,resourceType,nameToResolve.visualName];
        }
    }
    return key;
}

@end
