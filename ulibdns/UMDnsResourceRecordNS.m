//
//  UMDnsResourceRecordNS.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecordNS.h"


/*
 
 3.3.11. NS RDATA format
 
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 /                   NSDNAME                     /
 /                                               /
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 
 where:
 
 NSDNAME         A <domain-name> which specifies a host which should be
 authoritative for the specified class and domain.
 
 NS records cause both the usual additional section processing to locate
 a type A record, and, when used in a referral, a special search of the
 zone in which they reside for glue information.
 
 The NS RR states that the named host should be expected to have a zone
 starting at owner name of the specified class.  Note that the class may
 not indicate the protocol family which should be used to communicate
 with the host, although it is typically a strong hint.  For example,
 hosts which are name servers for either Internet (IN) or Hesiod (HS)
 class information are normally queried using IN class protocols.
 
 
 */

@implementation UMDnsResourceRecordNS


- (NSString *)recordTypeString
{
    return @"NS";
}

- (UlibDnsResourceRecordType)recordType
{
    return UlibDnsResourceRecordType_NS;
}

- (NSData *)resourceData
{
    return [_nsname binary];
}


- (UMDnsResourceRecordNS *)initWithNSName:(NSString *)a
{
    self = [super init];
    if(self)
    {
        _nsname = [[UMDnsName alloc]initWithVisualName:a];
    }
    return self;
}

- (UMDnsResourceRecordNS*)initWithParams:(NSArray *)params zone:(NSString *)zone
{
    return [self initWithNSName:params[0]];
}

- (NSString *)visualRepresentation
{
    return [NSString stringWithFormat:@"NS\t%@",_nsname.visualNameAbsoluteWriting];
}

- (UMDnsResourceRecordNS *)initWithRawData:(NSData *)data atOffset:(int *)pos
{
    self = [super init];
    if(self)
    {
        
        _nsname = [[UMDnsName alloc] initWithRawData:data atOffset:pos];
    }
    
    return self;
}

@end
