
//
//  UMDnsResourceRecordPTR.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecordPTR.h"


/*
3.3.12. PTR RDATA format

+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
/                   PTRDNAME                    /
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

where:

PTRDNAME        A <domain-name> which points to some location in the
domain name space.

PTR records cause no additional section processing.  These RRs are used
in special domains to point to some other location in the domain space.
These records are simple data, and don't imply any special processing
similar to that performed by CNAME, which identifies aliases.  See the
description of the IN-ADDR.ARPA domain for an example.

 */

@implementation UMDnsResourceRecordPTR


- (NSString *)recordTypeString
{
    return @"PTR";
}


- (UlibDnsResourceRecordType)recordType
{
    return UlibDnsResourceRecordType_PTR;
}

- (NSData *)resourceData
{
    return [_ptrname binary];
}


- (UMDnsResourceRecordPTR *)initWithPtrName:(UMDnsName *)a
{
    self = [super init];
    if(self)
    {
        _ptrname = a;
    }
    return self;
}

- (UMDnsResourceRecordPTR *)initWithParams:(NSArray *)params zone:(NSString *)zone
{
    UMDnsName *a = [[UMDnsName alloc]initWithVisualName:params[0] relativeToZone:zone];
    return [self initWithPtrName:a];
}

- (NSString *)visualRepresentation
{
    return [NSString stringWithFormat:@"PTR\t%@",_ptrname.visualNameAbsoluteWriting];
}

@end
