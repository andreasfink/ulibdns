//
//  UMDnsMessage.m
//  ulibdns
//
//  Created by Andreas Fink on 31.08.15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsMessage.h"

@implementation UMDnsMessage




- (UMDnsMessage *)initWithData:(NSData *)binary offset:(size_t *)offset; /* can throw NSException */
{
    size_t max = binary.length;
    size_t current;
    
    if(offset)
    {
        size_t current = *offset;
    }
    else
    {
        current = 0;
    }
    self = [super init];
    if(self)
    {
        _header = [[UMDnsHeader alloc]initWithData:binary offset:&current];
        
        if(_header == NULL)
        {
            current = binary.length;
            if(*offset)
            {
                *offset = current;
            }
            return NULL;
        }
        NSMutableArray<UMDnsQuery *> *queries = [[NSMutableArray alloc]init];
        for(NSUInteger i=0;i<_header.qdcount;i++)
        {
            UMDnsQuery *query = [[UMDnsQuery alloc]initWithData:binary offset:&current];
            [queries addObject:query];
        }
        _queries = queries;
        
        
        NSMutableArray<UMDnsResourceRecord *> *an = [[NSMutableArray alloc]init];
        for(NSUInteger i=0;i<_header.ancount;i++)
        {
            UMDnsResourceRecord *rr = [[UMDnsResourceRecord alloc]initWithRawData:binary atOffset:&current];
            [an addObject:rr];
        }
        _answers = an;
        
        NSMutableArray<UMDnsResourceRecord *> *ns = [[NSMutableArray alloc]init];
        for(NSUInteger i=0;i<_header.nscount;i++)
        {
            UMDnsResourceRecord *rr = [[UMDnsResourceRecord alloc]initWithRawData:binary atOffset:&current];
            [ns addObject:rr];
        }
        _authority = an;

        NSMutableArray<UMDnsResourceRecord *> *ad = [[NSMutableArray alloc]init];
        for(NSUInteger i=0;i<_header.arcount;i++)
        {
            UMDnsResourceRecord *rr = [[UMDnsResourceRecord alloc]initWithRawData:binary atOffset:&current];
            [ad addObject:rr];
        }
        _additional = ad;
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
    const uint8_t *bytes = data.bytes;
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
