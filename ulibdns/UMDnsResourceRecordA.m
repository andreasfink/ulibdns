//
//  UMDnsResourceRecordA.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright (c) 2016 Andreas Fink
//

#import "UMDnsResourceRecordA.h"

#include <arpa/inet.h>

/*
 
 3.4.1. A RDATA format
 
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 |                    ADDRESS                    |
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 
 where:
 
 ADDRESS         A 32 bit Internet address.
 
 Hosts that have multiple Internet addresses will have multiple A
 records.
 
 */

@implementation UMDnsResourceRecordA

- (NSString *)recordTypeString
{
    return @"A";
}

- (UlibDnsResourceRecordType)recordType
{
    return UlibDnsResourceRecordType_A;
}

- (NSData *)resourceData
{
    unsigned char addrBytes[4];
    char buffer[INET_ADDRSTRLEN+1];
    memset(buffer,0x00,INET_ADDRSTRLEN+1);
    inet_ntop(AF_INET, &addr, &buffer[0], sizeof(buffer));
    int a,b,c,d;
    sscanf(buffer,"%d.%d.%d.%d",&a,&b,&c,&d);
    
    addrBytes[0] = a;
    addrBytes[1] = b;
    addrBytes[2] = c;
    addrBytes[3] = d;
    return [[NSData alloc]initWithBytes:addrBytes length:4];
}

- (void)setAddressFromString:(NSString *)str
{
    int result = inet_pton(AF_INET,str.UTF8String, &addr);
    if(result==0)
    {
        @throw ([NSException exceptionWithName:@"invalid_address" reason:@"inet_pton fails to parse it" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
}

- (UMDnsResourceRecordA *)initWithAddressString:(NSString *)a
{
    self = [super init];
    if(self)
    {
        [self setAddressFromString:a];
    }
    return self;
}


- (UMDnsResourceRecordA *)initWithParams:(NSArray *)params  zone:(NSString *)zone
{
    return [self initWithAddressString:params[0]];
}


- (NSString *)visualRepresentation
{
    char buffer[INET_ADDRSTRLEN+1];
    memset(buffer,0x00,INET_ADDRSTRLEN+1);
    inet_ntop(AF_INET, &addr, &buffer[0], sizeof(buffer));
    NSString *ip = @(buffer);
    return [NSString stringWithFormat:@"A\t%@",ip];
}

- (UMDnsResourceRecordA *)initWithRawData:(NSData *)data atOffset:(int *)pos
{
    self = [super init];
    if(self)
    {
        NSUInteger len = [data length];
        const unsigned char *bytes = [data bytes];
        if(*pos + 4 > len)
        {
            @throw ([NSException exceptionWithName:@"invalid_address" reason:@"not enough bytes left to read" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
            return NULL;
        }
        int a = bytes[*pos++];
        int b = bytes[*pos++];
        int c = bytes[*pos++];
        int d = bytes[*pos++];
        NSString *str = [NSString stringWithFormat:@"%d.%d.%d.%d",a,b,c,d];
        int result = inet_pton(AF_INET,str.UTF8String, &addr);
        if(result==0)
        {
            @throw ([NSException exceptionWithName:@"invalid_address" reason:@"inet_pton fails to parse it" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
            return NULL;
        }
    }
    return self;
}
@end
