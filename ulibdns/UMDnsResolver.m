//
//  UMDnsResolver.m
//  ulibdns
//
//  Created by Andreas Fink on 07/09/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResolver.h"
#import "UMDnsResolvingRequest.h"
#import "UMDnsRemoteServer.h"

@implementation UMDnsResolver

- (UMDnsResolver *)init
{
    self = [super initWithName:@"UMDnsResolver" workSleeper:[[UMSleeper alloc]initFromFile:__FILE__
                                                                                      line:__LINE__
                                                                                  function:__func__]];
    if(self)
    {
        newRequests = [[UMQueueSingle alloc]init];
    }
    return self;
}

- (void)backgroundInit
{
    ulib_set_thread_name([NSString stringWithFormat:@"%@",self.name]);
    socket_u4 = [[UMSocket alloc]initWithType:UMSOCKET_TYPE_UDP4ONLY];
    socket_u4.objectStatisticsName = @"UMSocket(UMDnsResolver-udp4)";

    socket_u6 = [[UMSocket alloc]initWithType:UMSOCKET_TYPE_UDP6ONLY];
    socket_u6.objectStatisticsName = @"UMSocket(UMDnsResolver-udp6)";

    if((socket_u4==NULL) && (socket_u6==NULL))
    {
        @throw([NSException exceptionWithName:@"socket_error" reason:@"can not open sockets" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
}

- (void)backgroundExit
{
    [socket_u4 close];
    [socket_u6 close];
}

- (int)work
{
    @autoreleasepool
    {
        UMDnsResolvingRequest *req = [newRequests getFirst];
        if(req)
        {
            UMSocket *socket = NULL;
            
            if(req.useStream)
            {
                socket = req.serverToQuery.socket;
            }
            else
            {
                if([req.serverToQuery.address isIPv4]==YES)
                {
                    socket = socket_u4;
                }
                else if([req.serverToQuery.address isIPv6]==YES)
                {
                    socket = socket_u6;
                }
                else
                {
                    @throw([NSException exceptionWithName:@"invalid_address" reason:@"server is neither ipv4 nor ipv6 address" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
                }
            }
            [self sendRequest:req socket:socket];
        }
    }
    return 0;
}

- (void)sendRequest:(UMDnsResolvingRequest *)req socket:(UMSocket *)socket
{
    
}

@end

