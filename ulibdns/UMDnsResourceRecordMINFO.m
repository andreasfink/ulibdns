//
//  UMDnsResourceRecordMINFO.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecordMINFO.h"

@implementation UMDnsResourceRecordMINFO

@synthesize rMailBx;
@synthesize eMailBx;

/*
3.3.7. MINFO RDATA format (EXPERIMENTAL)

+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
/                    RMAILBX                    /
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
/                    EMAILBX                    /
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

where:

RMAILBX         A <domain-name> which specifies a mailbox which is
responsible for the mailing list or mailbox.  If this
domain name names the root, the owner of the MINFO RR is
responsible for itself.  Note that many existing mailing
lists use a mailbox X-request for the RMAILBX field of
mailing list X, e.g., Msgroup-request for Msgroup.  This
field provides a more general mechanism.


EMAILBX         A <domain-name> which specifies a mailbox which is to
receive error messages related to the mailing list or
mailbox specified by the owner of the MINFO RR (similar
                                                to the ERRORS-TO: field which has been proposed).  If
this domain name names the root, errors should be
returned to the sender of the message.

MINFO records cause no additional section processing.  Although these
records can be associated with a simple mailbox, they are usually used
with a mailing list.

*/
- (NSString *)recordTypeString
{
    return @"MINFO";
}


- (UlibDnsResourceRecordType)recordType
{
    return UlibDnsResourceRecordType_MINFO;
}

- (NSData *)resourceData
{
    NSMutableData *binary = [[NSMutableData alloc]init];
    [binary appendData:[rMailBx binary]];
    [binary appendData:[eMailBx binary]];
    return binary;
}


- (UMDnsResourceRecordMINFO *)initWithRMailBx:(UMDnsName *)a eMailBx:(UMDnsName *)b
{
    self = [super init];
    if(self)
    {
        rMailBx = a;
        eMailBx = b;
    }
    return self;
}

- (UMDnsResourceRecordMINFO *)initWithParams:(NSArray *)params zone:(NSString *)zone
{
    UMDnsName *a = [[UMDnsName alloc]initWithVisualName:params[0] relativeToZone:zone];
    UMDnsName *b = [[UMDnsName alloc]initWithVisualName:params[1] relativeToZone:zone];

    return [self initWithRMailBx:a eMailBx:b];
}

- (NSString *)visualRepresentation
{
    return [NSString stringWithFormat:@"MINFO\t%@\t%@",[rMailBx visualNameAbsoluteWriting],[eMailBx visualNameAbsoluteWriting]];
}

@end
