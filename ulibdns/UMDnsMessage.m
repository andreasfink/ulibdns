//
//  UMDnsMessage.m
//  ulibdns
//
//  Created by Andreas Fink on 31.08.15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsMessage.h"

@implementation UMDnsMessage

- (UMDnsMessage *)init
{
    self = [super init];
    if(self)
    {
        _header = [[UMDnsHeader alloc]init];
    }
    return self;
}

- (NSData *)binary
{
    _header.qdcount = [_queries count];
    _header.ancount = [_answers count];
    _header.nscount = [_authority count];
    _header.arcount = [_additional count];
    NSMutableData *binary = [[NSMutableData alloc]init];
    [binary appendData:[_header binary]];
    for(UMDnsQuery *query in _queries)
    {
        [binary appendData:[query binary]];
    }
    for(UMDnsResourceRecord *rec in _answers)
    {
        [binary appendData:[rec binary]];
    }
    for(UMDnsResourceRecord *rec in _authority)
    {
        [binary appendData:[rec binary]];
    }
    for(UMDnsResourceRecord *rec in _additional)
    {
        [binary appendData:[rec binary]];
    }
    return binary;
}


@end
