//
//  UMDnsLocalServer.m
//  ulibdns
//
//  Created by Andreas Fink on 23.08.16.
//  Copyright © 2016 Andreas Fink. All rights reserved.
//

#import "UMDnsLocalServer.h"
#include <unistd.h>

@implementation UMDnsLocalServer


-  (UMDnsLocalServer *)initWithPort:(int)port
{
    self = [super init];
    if(self)
    {
        localSocketUdp = [[UMSocket alloc]initWithType:UMSOCKET_TYPE_UDP];
        localSocketUdp.localPort = port;
        localSocketTcp = [[UMSocket alloc]initWithType:UMSOCKET_TYPE_TCP];
        localSocketTcp.localPort = port;
    }
    return self;
}

- (void)start
{
    mustQuit=NO;
    [NSThread detachNewThreadSelector:@selector(socketListenerUdp)
                             toTarget:self
                           withObject:NULL];
    [NSThread detachNewThreadSelector:@selector(socketListenerTcp)
                             toTarget:self
                           withObject:NULL];
}

- (void)stop
{
    mustQuit=YES;
    while((localSocketUdp.isConnected) && (localSocketTcp.isConnected))
    {
        usleep(100000);
    }
}

- (void)socketListenerTcp
{
    [localSocketTcp bind];
    [localSocketTcp listen];
    
    while(mustQuit == NO)
    {
        UMSocketError err = UMSocketError_no_error;
        UMSocket *connection = [localSocketTcp accept:&err];
        if(connection)
        {
            [NSThread detachNewThreadSelector:@selector(handleTcpConnection:)
                                     toTarget:self
                                   withObject:connection];
        }
    }
    [localSocketTcp close];
}

- (void)socketListenerUdp
{
    [localSocketUdp bind];
    [localSocketUdp listen];

    while(mustQuit == NO)
    {
        UMSocketError err = UMSocketError_no_error;
        UMSocket *connection = [localSocketUdp accept:&err];
        if(connection)
        {
            [NSThread detachNewThreadSelector:@selector(handleUdpConnection:)
                                     toTarget:self
                                   withObject:connection];
        }
    }
    [localSocketUdp close];
}


- (void)handleUdpConnection:(UMSocket *)connection
{
    
}

- (void)handleTcpConnection:(UMSocket *)connection
{
    UMSocketError err;
    int timeoutInMs = 20000;
    err = [connection dataIsAvailable:timeoutInMs];
    while((err == UMSocketError_has_data) || (err==UMSocketError_has_data_and_hup))
    {
        /* handleTcapData */
        if(err==UMSocketError_has_data_and_hup)
        {
            break;
        }
        err = [connection dataIsAvailable:timeoutInMs];
        
    }
    [connection close];
}

@end

