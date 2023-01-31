//
//  UMDnsServer.m
//  ulibdns
//
//  Created by Andreas Fink on 07/09/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsRemoteServer.h"

@implementation UMDnsRemoteServer


- (UMDnsRemoteServer *)initWithAddress:(NSString *)addr useUDP:(BOOL)udp
{
    self = [super init];
    if(self)
    {
        _address = addr;
        _isUDP = udp;
        _port = 53;
        _waitTimeoutInMs = 100;
        if(_isUDP)
        {
            if([_address isIPv4])
            {
                _socket = [[UMSocket alloc]initWithType:UMSOCKET_TYPE_TCP4ONLY];
                _socket.objectStatisticsName = @"UMSocket(UMDnsRemoteServer-tcp4)";
                
            }
            else if([_address isIPv6])
            {
                _socket = [[UMSocket alloc]initWithType:UMSOCKET_TYPE_TCP6ONLY];
                _socket.objectStatisticsName = @"UMSocket(UMDnsRemoteServer-tcp6)";
            }
            else
            {
                NSLog(@"Unknown address type for %@",_address);
                return NULL;
            }
        }
        else
        {
            if([_address isIPv4])
            {
                _socket = [[UMSocket alloc]initWithType:UMSOCKET_TYPE_UDP4ONLY];
                _socket.objectStatisticsName = @"UMSocket(UMDnsRemoteServer-udp4)";
                
            }
            else if([_address isIPv6])
            {
                _socket = [[UMSocket alloc]initWithType:UMSOCKET_TYPE_UDP6ONLY];
                _socket.objectStatisticsName = @"UMSocket(UMDnsRemoteServer-udp6)";
            }
            else
            {
                NSLog(@"Unknown address type for %@",_address);
                return NULL;
            }
        }
        _socket.remoteHost = [[UMHost alloc]initWithAddress:_address];
        _socket.requestedRemotePort = 53;
    }
    return self;
}

- (void)sendDatagramRequest:(NSData *)data
{
    if([data length]>512)
    {
        @throw([NSException exceptionWithName:@"packet_too_big" reason:@"udp packet is over 512" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }

    UMSocketError err = [_socket sendData:data toAddress:_address toPort:_port];
    if(err)
    {
        @throw([NSException exceptionWithName:@"write_error" reason:
                [NSString stringWithFormat:@"error %d" ,err] userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
}

- (void)sendStreamRequest:(NSData *)data
{
    UMSocketError err;

    UMAssert(_socket!=NULL,@"cant send on NULL socket");
    if(_socket.isConnected == NO)
    {
        err = [_socket connect];
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
    err = [_socket sendData:d];
    if(err)
    {
        @throw([NSException exceptionWithName:@"write_error" reason:
                [NSString stringWithFormat:@"error %d" ,err] userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
}

- (void)sendRequest:(NSData *)data
{
    if(_isUDP)
    {
        [self sendDatagramRequest:data];
    }
    else
    {
        [self sendStreamRequest:data];
    }
}

- (void)backgroundInit
{
    if(_isUDP)
    {
        [_socket bind];
    }
    else
    {
        [_socket connect];
    }
}

- (void)backgroundExit
{
    [_socket close];
}

- (int)work
{
    int i =0;
    UMSocketError err =  [_socket dataIsAvailable:_waitTimeoutInMs];
    while((err == UMSocketError_has_data) || (err==UMSocketError_has_data_and_hup))
    {
        /* handle data */
        i++;
        err = [self receiveAndProcessData];
        /* handleTcapData */
        if((err==UMSocketError_has_data_and_hup) && (err != UMSocketError_has_data))
        {
            break;
        }
        err =  [_socket dataIsAvailable:_waitTimeoutInMs];
    }
    return i;
}

- (UMSocketError)receiveAndProcessData
{
    NSData *data = NULL;
    size_t size = 0;
    UMSocketError err = [_socket receiveEverythingTo:&data];
    if(err==UMSocketError_no_error)
    {
        [self processReceivedData:data];
    }
    return err;
}

- (void)processReceivedData:(NSData *)data
{
    [_delegate processReceivedData:data];
}

@end
