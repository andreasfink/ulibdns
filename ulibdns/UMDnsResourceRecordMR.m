
//
//  UMDnsResourceRecordMR.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecordMR.h"

/*
3.3.8. MR RDATA format (EXPERIMENTAL)

+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
/                   NEWNAME                     /
/                                               /
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

where:

NEWNAME         A <domain-name> which specifies a mailbox which is the
proper rename of the specified mailbox.

MR records cause no additional section processing.  The main use for MR
is as a forwarding entry for a user who has moved to a different
mailbox.


*/

@implementation UMDnsResourceRecordMR

@synthesize newname;

- (NSString *)recordTypeString
{
    return @"MR";
}


- (UlibDnsResourceRecordType)recordType
{
    return UlibDnsResourceRecordType_MR;
}



- (NSData *)resourceData
{
    return [newname binary];
}


- (UMDnsResourceRecordMR *)initWithNewname:(UMDnsName *)a
{
    self = [super init];
    if(self)
    {
        newname = a;
    }
    return self;
}

- (UMDnsResourceRecordMR *)initWithParams:(NSArray *)params zone:(NSString *)zone
{
    UMDnsName *a = [[UMDnsName alloc]initWithVisualName:params[0] relativeToZone:zone];
    return [self initWithNewname:a];
}

- (NSString *)visualRepresentation
{
    return [NSString stringWithFormat:@"MR\t%@",[newname visualNameAbsoluteWriting]];
}

@end
