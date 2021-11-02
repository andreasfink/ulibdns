//
//  UMDnsLocalServer.m
//  ulibdns
//
//  Created by Andreas Fink on 23.08.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsLocalServer.h"
#include <unistd.h>

@implementation UMDnsLocalServer


-  (UMDnsLocalServer *)initWithPort:(int)port
{
    self = [super init];
    if(self)
    {
        _localSocketUdp = [[UMSocket alloc]initWithType:UMSOCKET_TYPE_UDP];
        _localSocketUdp.objectStatisticsName = @"UMSocket(UMDnsLocalserver-udp)";

        _localSocketUdp.localPort = port;
        _localSocketTcp = [[UMSocket alloc]initWithType:UMSOCKET_TYPE_TCP];
        _localSocketTcp.objectStatisticsName = @"UMSocket(UMDnsLocalserver-tcp)";
        _localSocketTcp.localPort = port;
    }
    return self;
}

- (void)start
{
    _mustQuit=NO;
    [NSThread detachNewThreadSelector:@selector(socketListenerUdp)
                             toTarget:self
                           withObject:NULL];
    [NSThread detachNewThreadSelector:@selector(socketListenerTcp)
                             toTarget:self
                           withObject:NULL];
}

- (void)stop
{
    _mustQuit=YES;
    while((_localSocketUdp.isConnected) && (_localSocketTcp.isConnected))
    {
        usleep(100000);
    }
}

- (void)socketListenerTcp
{
    [_localSocketTcp bind];
    [_localSocketTcp listen];

    while(_mustQuit == NO)
    {
        UMSocketError err = UMSocketError_no_error;
        UMSocket *connection = [_localSocketTcp accept:&err];
        if(connection)
        {
            [NSThread detachNewThreadSelector:@selector(handleTcpConnection:)
                                     toTarget:self
                                   withObject:connection];
        }
    }
    [_localSocketTcp close];
}

- (void)socketListenerUdp
{
    [_localSocketUdp bind];
    [_localSocketUdp listen];

    while(_mustQuit == NO)
    {
        UMSocketError err = UMSocketError_no_error;
        UMSocket *connection = [_localSocketUdp accept:&err];
        if(connection)
        {
            [NSThread detachNewThreadSelector:@selector(handleUdpConnection:)
                                     toTarget:self
                                   withObject:connection];
        }
    }
    [_localSocketUdp close];
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

