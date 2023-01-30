//
//  UMDnsResourceRecordAAAA.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecordAAAA.h"
#include <arpa/inet.h>

/*
 
 3.4.1. A RDATA format
 
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 |                    ADDRESS                    |
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 
 where:
 
 ADDRESS         A 128 bit Internet address.
 
 Hosts that have multiple Internet addresses will have multiple A
 records.
 
 */

@implementation UMDnsResourceRecordAAAA

- (NSString *)recordTypeString
{
    return @"AAAA";
}

- (UlibDnsResourceRecordType)recordType
{
    return UlibDnsResourceRecordType_AAAA;
}

- (NSData *)resourceData
{
    return [[NSData alloc]initWithBytes:&_addr6.s6_addr length:16];
}

- (void)setAddressFromString:(NSString *)str
{
    int result = inet_pton(AF_INET6,str.UTF8String, &_addr6);
    if(result==0)
    {
        @throw ([NSException exceptionWithName:@"invalid_address" reason:@"inet_pton fails to parse ipv6 address" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
}

- (UMDnsResourceRecordAAAA *)initWithAddressString:(NSString *)a
{
    self = [super init];
    if(self)
    {
        [self setAddressFromString:a];
    }
    return self;
}

- (UMDnsResourceRecordAAAA *)initWithParams:(NSArray *)params  zone:(NSString *)zone
{
    return [self initWithAddressString:params[0]];
}

- (NSString *)visualRepresentation
{
    char buffer[INET6_ADDRSTRLEN+1];
    memset(buffer,0x00,INET6_ADDRSTRLEN+1);
    inet_ntop(AF_INET6, &_addr6, &buffer[0], sizeof(buffer));
    NSString *ip6 = @(buffer);
    return [NSString stringWithFormat:@"AAAA\t%@",ip6];
}


- (UMDnsResourceRecordAAAA *)initWithRawData:(NSData *)data atOffset:(int *)pos
{
    self = [super init];
    if(self)
    {
        NSUInteger len = [data length];
        const unsigned char *bytes = [data bytes];
        if(*pos + 16 > len)
        {
            @throw ([NSException exceptionWithName:@"invalid_address" reason:@"not enough bytes left to read" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
            return NULL;
        }
        memcpy(&_addr6.s6_addr,&bytes[*pos],16);
        *pos = *pos + 16;
    }

    return self;
}

@end
