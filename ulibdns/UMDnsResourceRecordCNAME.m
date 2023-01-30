//
//  UMDnsResourceRecordCNAME.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecordCNAME.h"

/*
 
 3.3.1. CNAME RDATA format
 
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 /                     CNAME                     /
 /                                               /
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 
 where:
 
 CNAME           A <domain-name> which specifies the canonical or primary
 name for the owner.  The owner name is an alias.
 
 CNAME RRs cause no additional section processing, but name servers may
 choose to restart the query at the canonical name in certain cases.  See
 the description of name server logic in [RFC-1034] for details.
 
 */

@implementation UMDnsResourceRecordCNAME


- (NSString *)recordTypeString
{
    return @"CNAME";
}

- (UlibDnsResourceRecordType)recordType
{
    return UlibDnsResourceRecordType_CNAME;
}

- (NSData *)resourceData
{
    return [_aliasName binary];
}


- (UMDnsResourceRecordCNAME *)initWithCname:(UMDnsName *)a
{
    self = [super init];
    if(self)
    {
        self.aliasName = a;
    }
    return self;
}

- (UMDnsResourceRecordCNAME *)initWithParams:(NSArray *)params zone:(NSString *)zone
{
    UMDnsName *a = [[UMDnsName alloc]initWithVisualName:params[0] relativeToZone:zone];
    return [self initWithCname:a];
}

- (NSString *)visualRepresentation
{
    return [NSString stringWithFormat:@"CNAME\t%@",_aliasName.visualNameAbsoluteWriting];
}

@end
