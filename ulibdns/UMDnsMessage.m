//
//  UMDnsMessage.m
//  ulibdns
//
//  Created by Andreas Fink on 31.08.15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsMessage.h"

@implementation UMDnsMessage

- (UMDnsMessage *)initWithData:(NSData *)data
{
    self = [super init];
    if(self)
    {
        _header = [[UMDnsHeader alloc]init];
    }
    return self;
}

- (NSData *)encodedData
{
    _header.qdcount = _queries.count;
    _header.ancount = _answers.count;
    _header.nscount = _authority.count;
    _header.arcount = _additional.count;
    NSMutableData *d = [[NSMutableData alloc]init];
    [d appendData:[_header encodedData]];
    for(UMDnsQuery *query in _queries)
    {
        [d appendData:[query encodedData]];
    }
    for(UMDnsResourceRecord *rr in _answers)
    {
        [d appendData:[rr encodedData]];
    }
    for(UMDnsResourceRecord *rr in _authority)
    {
        [d appendData:[rr encodedData]];
    }
    for(UMDnsResourceRecord *rr in _additional)
    {
        [d appendData:[rr encodedData]];
    }
    return d;
}

- (size_t)grabData:(NSData *)data
{
    uint8_t *bytes = data.bytes;
    size_t maxlen = data.length;
    return 0;
}

- (UMDnsMessage *)initWithData:(NSData *)data atOffset:(size_t *)offset
{
    self = [super init];
    if(self)
    {
        NSData *sub;
        size_t pos = *offset;
        if(pos >= data.length)
        {
            return NULL;
        }
        if(pos==0)
        {
            sub = data;
        }
        else
        {
            size_t remaining = data.length - pos;
            sub = [data subdataWithRange:NSMakeRange(pos,remaining)];
        }
        size_t bytesCount = [self grabData:sub];
        *offset += bytesCount;
    }
    return self;
}

- (NSString *)visualRepresentation
{
    return @"";
}

@end
