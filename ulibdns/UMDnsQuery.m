//
//  UMDnsQuery.m
//  ulibdns
//
//  Created by Andreas Fink on 31.08.15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsQuery.h"

@implementation UMDnsQuery

- (UMDnsQuery *)initWithData:(NSData *)data offset:(size_t *)offset
{
    self = [super init];
    if(self)
    {
        _name = [[UMDnsName alloc]initWithData:data offset:offset];
        const uint8_t *bytes = data.bytes;
        if((*offset + 4) <= data.length)
        {
            _recordType  = (bytes[*offset+0] << 8) | (bytes[*offset+1] << 0);
            _recordClass = (bytes[*offset+2] << 8) | (bytes[*offset+3] << 0);
        }
    }
    return self;
}

- (NSData *)encodedData
{
    NSMutableData *binary = [[NSMutableData alloc]init];
    
    [binary appendData:[_name binary]];
    unsigned char typeBytes[2];
    typeBytes[0] = (_recordType & 0xFF00)>> 8;
    typeBytes[1] = (_recordType & 0x00FF);
    [binary appendBytes:typeBytes length:2];
    
    unsigned char classBytes[2];
    classBytes[0] = (_recordClass & 0xFF00)>> 8;
    classBytes[1] = (_recordClass & 0x00FF);
    [binary appendBytes:classBytes length:2];
    return binary;
}


@end
