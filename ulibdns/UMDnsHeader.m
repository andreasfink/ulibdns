//
//  UMDnsHeader.m
//  ulibdns
//
//  Created by Andreas Fink on 31.08.15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsHeader.h"

@implementation UMDnsHeader

- (UMDnsHeader *)initWithData:(NSData *)data offset:(size_t *)offset
{
    self = [super init];
    if(self)
    {
        if(data.length < 12)
        {
            return NULL;
        }
        unsigned char header[12];
        memcpy(&header[0],data.bytes,12);
        if(offset)
        {
            *offset += 12;
        }
        _requestId = (header[0] << 8) | header[1];
        int flags = (header[2] << 8) | header[3];
        _isResponse = (flags & (1 << 15) ) ? YES :  NO;
        _authoritativeAnswer = (flags & (1 << 10) ) ? YES :  NO;
        _trunCation = (flags & (1 << 9) ) ? YES :  NO;
        _recursionDesired = (flags & (1 << 8) ) ? YES :  NO;
        _recursionAvailable = (flags & (1 << 7) ) ? YES :  NO;
        _zBits = (flags  >> 4) & 0x07;
        _qdcount = (header[0] << 4) | header[5];
        _ancount = (header[0] << 6) | header[7];
        _nscount = (header[0] << 8) | header[9];
        _arcount = (header[0] << 10) | header[11];
    }
    return self;
}

- (NSData *)encodedData
{
    unsigned char header[12];
    
    header[0] = (_requestId & 0xFF00) >> 8;
    header[1] = (_requestId & 0x00FF);
    
    uint16_t flags = 0;

    if(_isResponse)
    {
        flags = flags | (1 << 15);
    }
    flags = flags | ((_opCode & 0x0F)<< 11);
    if(_authoritativeAnswer)
    {
        flags = flags | (1<< 10);
    }
    if(_trunCation)
    {
        flags = flags | (1<< 9);
    }
    if(_recursionDesired)
    {
        flags = flags | (1<< 8);
    }
    if(_recursionAvailable)
    {
        flags = flags | (1<< 7);
    }
    if(_zBits>0)
    {
        flags = flags | ((_zBits & 0x07)<< 4);
    }
    
    header[2] = (flags & 0xFF00) >> 8;
    header[3] = (flags & 0x00FF);

    header[4] = (_qdcount & 0xFF00) >> 8;
    header[5] = (_qdcount & 0x00FF);

    header[6] = (_ancount & 0xFF00) >> 8;
    header[7] = (_ancount & 0x00FF);

    header[8] = (_nscount & 0xFF00) >> 8;
    header[9] = (_nscount & 0x00FF);

    header[10] = (_arcount & 0xFF00) >> 8;
    header[11] = (_arcount & 0x00FF);
    
    return [NSData dataWithBytes:&header[0] length:12];
}

+ (size_t)headerSize
{
    return 12;
}

- (UMDnsHeader *)initWithBytes:(uint8_t *)h
{
    self = [super init];
    if(self)
    {
        _requestId = (h[0] <<8) | h[1];
        int flags  = (h[2] <<8) | h[3];
        _qdcount   = (h[4] <<8) | h[5];
        _ancount   = (h[6] <<8) | h[7];
        _nscount   = (h[8] <<8) | h[9];
        _arcount   = (h[10] <<8) | h[11];
        if(flags & (1 << 15))
        {
            _isResponse =YES;
        }
        _opCode = (flags >> 11) & 0x0F;
        if(flags & (1<< 10))
        {
            _authoritativeAnswer = YES;
        }
        if(flags & (1<< 9))
        {
            _trunCation = YES;
        }
        if(flags & (1<< 8))
        {
            _recursionDesired = YES;
        }
        if(flags & (1<< 7))
        {
            _recursionAvailable = YES;
        }
        _zBits = (flags >>4) & 0x07;
    }
    return self;
}

UMSynchronizedArray *_ulibdns_requestIds = NULL;

+ (uint16_t)uniqueRequestId
{
    if(_ulibdns_requestIds==NULL)
    {
        _ulibdns_requestIds = [[UMSynchronizedArray alloc]init];
        for(uint16_t i=1;i<0xFFF0;i++)
        {
            [_ulibdns_requestIds addObject:@(i)];
        }
    }
    NSNumber *n = [_ulibdns_requestIds removeFirst];
    return n.intValue;
}

+ (void)returnUniqueRequestId:(uint16_t)i
{
    [_ulibdns_requestIds addObject:@(i)];
}

@end
