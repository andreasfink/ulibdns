//
//  UMDnsServer.m
//  ulibdns
//
//  Created by Andreas Fink on 07/09/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsRemoteServer.h"

@implementation UMDnsRemoteServer

@synthesize address;
@synthesize socket;

@synthesize isActive;
@synthesize isTcp;
@synthesize isIPv6;


- (UMDnsRemoteServer *)initWithAddress:(NSString *)addr
{
    self = [super init];
    if(self)
    {
        address = addr;
        if([address isIPv4])
        {
            socket = [[UMSocket alloc]initWithType:UMSOCKET_TYPE_TCP4ONLY];
        }
        else if([address isIPv6])
        {
            socket = [[UMSocket alloc]initWithType:UMSOCKET_TYPE_TCP4ONLY];

        }
        else
        {
            return NULL;
        }
    }
    return self;
}

- (void)sendDatagrammRequest:(NSData *)data stream:(UMSocket *)sock
{
    if([data length]>512)
    {
        @throw([NSException exceptionWithName:@"packet_too_big" reason:@"udp packet is over 512" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }

    UMSocketError err = [sock sendData:data];
    if(err)
    {
        @throw([NSException exceptionWithName:@"write_error" reason:
                [NSString stringWithFormat:@"error %d" ,err] userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
}

- (void)sendStreamRequest:(NSData *)data

{
    UMSocketError err;

    UMAssert(socket!=NULL,@"cant send on NULL socket");
    if(socket.isConnected == NO)
    {
        err = [socket connect];
        if(err)
        {
            @throw([NSException exceptionWithName:@"connect_error" reason:
                    [NSString stringWithFormat:@"error %d" ,err] userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
        }
    }

    NSMutableData *d = [[NSMutableData alloc]init];
    int len = (int) data.length;
    if(len <= 0xFFFF)
    {
        NSMutableData *d = [[NSMutableData alloc]init];
        [d appendByte:((len & 0xFF00) >> 8)];
        [d appendByte:((len & 0x00FF) >> 0)];
        [d appendData:data];
    }
    else
    {
        @throw([NSException exceptionWithName:@"packet_too_big" reason:@"tcp packet is over 64k" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
    err = [socket sendData:d];
    if(err)
    {
        @throw([NSException exceptionWithName:@"write_error" reason:
                [NSString stringWithFormat:@"error %d" ,err] userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
}

@end
