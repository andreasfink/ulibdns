//
//  UMDnsHeader.m
//  ulibdns
//
//  Created by Andreas Fink on 31.08.15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsHeader.h"

@implementation UMDnsHeader

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
