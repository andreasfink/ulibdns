//
//  UMDnsResourceRecordMF.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecordMF.h"

/*
 3.3.5. MF RDATA format (Obsolete)
 
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 /                   MADNAME                     /
 /                                               /
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 
 where:
 
 MADNAME         A <domain-name> which specifies a host which has a mail
 agent for the domain which will accept mail for
 forwarding to the domain.
 
 MF records cause additional section processing which looks up an A type
 record corresponding to MADNAME.
 
 MF is obsolete.  See the definition of MX and [RFC-974] for details ofw
 the new scheme.  The recommended policy for dealing with MD RRs found in
 a master file is to reject them, or to convert them to MX RRs with a
 preference of 10.

 */

@implementation UMDnsResourceRecordMF

- (NSString *)recordTypeString
{
    return @"MF";
}


- (UlibDnsResourceRecordType)recordType
{
    return UlibDnsResourceRecordType_MF;
}

- (NSData *)resourceData
{
    return [_madname binary];
}


- (UMDnsResourceRecordMF *)initWithMadname:(UMDnsName *)a
{
    self = [super init];
    if(self)
    {
        _madname = a;
    }
    return self;
}

- (UMDnsResourceRecordMF *)initWithParams:(NSArray *)params zone:(NSString *)zone
{
    UMDnsName *a = [[UMDnsName alloc]initWithVisualName:params[0] relativeToZone:zone];
    return [self initWithMadname:a];
}

- (NSString *)visualRepresentation
{
    return [NSString stringWithFormat:@"MF\t%@",[_madname visualNameAbsoluteWriting]];
}

@end
