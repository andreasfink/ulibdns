//
//  UMDnsHeader.m
//  ulibdns
//
//  Created by Andreas Fink on 31.08.15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsHeader.h"

@implementation UMDnsHeader

- (NSData *)binary
{
    unsigned char header[12];
    
    header[0] = (requestId & 0xFF00) >> 8;
    header[1] = (requestId & 0x00FF);
    
    uint16_t flags = 0;

    if(isResponse)
    {
        flags = flags | (1 << 15);
    }
    flags = flags | ((opCode & 0x0F)<< 11);
    if(authoritativeAnswer)
    {
        flags = flags | (1<< 10);
    }
    if(trunCation)
    {
        flags = flags | (1<< 9);
    }
    if(recursionDesired)
    {
        flags = flags | (1<< 8);
    }
    if(recursionAvailable)
    {
        flags = flags | (1<< 7);
    }
    if(zBits>0)
    {
        flags = flags | ((zBits & 0x07)<< 4);
    }
    
    header[2] = (flags & 0xFF00) >> 8;
    header[3] = (flags & 0x00FF);

    header[4] = (qdcount & 0xFF00) >> 8;
    header[5] = (qdcount & 0x00FF);

    header[6] = (ancount & 0xFF00) >> 8;
    header[7] = (ancount & 0x00FF);

    header[8] = (nscount & 0xFF00) >> 8;
    header[9] = (nscount & 0x00FF);

    header[10] = (arcount & 0xFF00) >> 8;
    header[11] = (arcount & 0x00FF);
    
    return [NSData dataWithBytes:&header[0] length:12];
}
@end
