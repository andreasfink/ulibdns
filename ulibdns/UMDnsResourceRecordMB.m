//
//  UMDnsResourceRecordMB.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecordMB.h"

/*
 3.3.3. MB RDATA format (EXPERIMENTAL)
 
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 /                   MADNAME                     /
 /                                               /
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 
 where:
 
 MADNAME         A <domain-name> which specifies a host which has the
 specified mailbox.

 MB records cause additional section processing which looks up an A type
 RRs corresponding to MADNAME.
 */


@implementation UMDnsResourceRecordMB

- (NSString *)recordTypeString
{
    return @"MB";
}

- (UlibDnsResourceRecordType)recordType
{
    return UlibDnsResourceRecordType_MB;
}

- (NSData *)resourceData
{
    return [_madname binary];
}


- (UMDnsResourceRecordMB *)initWithMadname:(UMDnsName *)a
{
    self = [super init];
    if(self)
    {
        _madname = a;
    }
    return self;
}


- (UMDnsResourceRecordMB *)initWithParams:(NSArray *)params zone:(NSString *)zone
{
    UMDnsName *a = [[UMDnsName alloc]initWithVisualName:params[0] relativeToZone:zone];
    return [self initWithMadname:a];
}

- (NSString *)visualRepresentation
{
    return [NSString stringWithFormat:@"MB\t%@",[_madname visualNameAbsoluteWriting]];
}

@end
