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
        [d appendData:[rr resourceData]];
    }
    for(UMDnsResourceRecord *rr in _authority)
    {
        [d appendData:[rr resourceData]];
    }
    for(UMDnsResourceRecord *rr in _additional)
    {
        [d appendData:[rr resourceData]];
    }
    return d;
}

@end
