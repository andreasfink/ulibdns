//
//  UMDnsResourceRecordMX.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecordMX.h"

/*
 3.3.9. MX RDATA format
 
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 |                  PREFERENCE                   |
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 /                   EXCHANGE                    /
 /                                               /
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 
 where:
 
 PREFERENCE      A 16 bit integer which specifies the preference given to
 this RR among others at the same owner.  Lower values
 are preferred.
 
 EXCHANGE        A <domain-name> which specifies a host willing to act as
 a mail exchange for the owner name.
 
 MX records cause type A additional section processing for the host
 specified by EXCHANGE.  The use of MX RRs is explained in detail in
 [RFC-974].


*/

@implementation UMDnsResourceRecordMX

@synthesize preference;
@synthesize exchanger;

- (NSString *)recordTypeString
{
    return @"MX";
}


- (UlibDnsResourceRecordType)recordType
{
    return UlibDnsResourceRecordType_MX;
}

- (NSData *)resourceData
{
    char pref[2];
    pref[0] = (preference & 0xFF00) >> 8;
    pref[1] = (preference & 0x00FF);
    NSMutableData *binary = [[NSMutableData alloc]initWithBytes:pref length:2];
    [binary appendData: [exchanger binary]];
    return binary;
}


- (UMDnsResourceRecordMX *)initWithPreference:(uint16_t)p exchanger:(UMDnsName *)ex
{
    self = [super init];
    if(self)
    {
        preference = p;
        exchanger = ex;
    }
    return self;
}

- (UMDnsResourceRecordMX *)initWithParams:(NSArray *)params zone:(NSString *)zone
{
    uint16_t p = [params[0] integerValue];
    UMDnsName *a = [[UMDnsName alloc]initWithVisualName:params[1] relativeToZone:zone];

    return [self initWithPreference:p exchanger:a];
}

- (NSString *)visualRepresentation
{
    return [NSString stringWithFormat:@"MX\t%d\t%@",(int)preference,exchanger.visualNameAbsoluteWriting];
}

@end
