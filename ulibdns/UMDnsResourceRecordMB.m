//
//  UMDnsResourceRecordMB.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright (c) 2016 Andreas Fink
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
@synthesize madname;

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
    return [madname binary];
}


- (UMDnsResourceRecordMB *)initWithMadname:(UMDnsName *)a
{
    self = [super init];
    if(self)
    {
        madname = a;
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
    return [NSString stringWithFormat:@"MB\t%@",[madname visualNameAbsoluteWriting]];
}

@end
