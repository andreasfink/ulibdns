//
//  UMDnsResourceRecordMG.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecordMG.h"

/*
 3.3.6. MG RDATA format (EXPERIMENTAL)
 
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 /                   MGMNAME                     /
 /                                               /
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 
 where:
 
 MGMNAME         A <domain-name> which specifies a mailbox which is a
 member of the mail group specified by the domain name.
 
 MG records cause no additional section processing.
 */

@implementation UMDnsResourceRecordMG


- (NSString *)recordTypeString
{
    return @"MG";
}


- (UlibDnsResourceRecordType)recordType
{
    return UlibDnsResourceRecordType_MG;
}

- (NSData *)resourceData
{
    return [_mgmname binary];
}


- (UMDnsResourceRecordMG *)initWithMgmname:(UMDnsName *)a
{
    self = [super init];
    if(self)
    {
        _mgmname = a;
    }
    return self;
}

- (UMDnsResourceRecordMG *)initWithParams:(NSArray *)params zone:(NSString *)zone
{
    UMDnsName *a = [[UMDnsName alloc]initWithVisualName:params[0] relativeToZone:zone];
    return [self initWithMgmname:a];
}

- (NSString *)visualRepresentation
{
    return [NSString stringWithFormat:@"MG\t%@",[_mgmname visualNameAbsoluteWriting]];
}

@end
