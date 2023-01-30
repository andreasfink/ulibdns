//
//  UMDnsResourceRecordMD.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecordMD.h"

/*
 3.3.4. MD RDATA format (Obsolete)
 
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 /                   MADNAME                     /
 /                                               /
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 
 where:
 
 MADNAME         A <domain-name> which specifies a host which has a mail
 agent for the domain which should be able to deliver
 mail for the domain.
 
 MD records cause additional section processing which looks up an A type
 record corresponding to MADNAME.
 
 MD is obsolete.  See the definition of MX and [RFC-974] for details of
 the new scheme.  The recommended policy for dealing with MD RRs found in
 a master file is to reject them, or to convert them to MX RRs with a
 preference of 0.
 */

@implementation UMDnsResourceRecordMD


- (NSString *)recordTypeString
{
    return @"MD";
}

- (UlibDnsResourceRecordType)recordType
{
    return UlibDnsResourceRecordType_MD;
}

- (NSData *)resourceData
{
    return [_madname binary];
}


- (UMDnsResourceRecordMD *)initWithMadname:(UMDnsName *)a
{
    self = [super init];
    if(self)
    {
        _madname = a;
    }
    return self;
}

- (UMDnsResourceRecordMD *)initWithParams:(NSArray *)params zone:(NSString *)zone
{
    UMDnsName *a = [[UMDnsName alloc]initWithVisualName:params[0] relativeToZone:zone];
    return [self initWithMadname:a];
}

- (NSString *)visualRepresentation
{
    return [NSString stringWithFormat:@"MD\t%@",[_madname visualNameAbsoluteWriting]];
}

@end
