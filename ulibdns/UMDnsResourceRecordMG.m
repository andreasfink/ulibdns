//
//  UMDnsResourceRecordMG.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright (c) 2016 Andreas Fink
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

@synthesize mgmname;

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
    return [mgmname binary];
}


- (UMDnsResourceRecordMG *)initWithMgmname:(UMDnsName *)a
{
    self = [super init];
    if(self)
    {
        mgmname = a;
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
    return [NSString stringWithFormat:@"MG\t%@",[mgmname visualNameAbsoluteWriting]];
}

@end
