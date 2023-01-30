
//
//  UMDnsResourceRecordWKS.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecordWKS.h"
/*
 
 3.4.2. WKS RDATA format
 
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 |                    ADDRESS                    |
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 |       PROTOCOL        |                       |
 +--+--+--+--+--+--+--+--+                       |
 |                                               |
 /                   <BIT MAP>                   /
 /                                               /
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 
 where:
 
 ADDRESS         An 32 bit Internet address
 
 PROTOCOL        An 8 bit IP protocol number
 
 <BIT MAP>       A variable length bit map.  The bit map must be a
 multiple of 8 bits long.
 
 The WKS record is used to describe the well known services supported by
 a particular protocol on a particular internet address.  The PROTOCOL
 field specifies an IP protocol number, and the bit map has one bit per
 port of the specified protocol.  The first bit corresponds to port 0,
 the second to port 1, etc.  If the bit map does not include a bit for a
 protocol of interest, that bit is assumed zero.  The appropriate values
 and mnemonics for ports and protocols are specified in [RFC-1010].
 
 For example, if PROTOCOL=TCP (6), the 26th bit corresponds to TCP port
 25 (SMTP).  If this bit is set, a SMTP server should be listening on TCP
 port 25; if zero, SMTP service is not supported on the specified
 address.
 
 The purpose of WKS RRs is to provide availability information for
 servers for TCP and UDP.  If a server supports both TCP and UDP, or has
 multiple Internet addresses, then multiple WKS RRs are used.
 
 WKS RRs cause no additional section processing.
 
 In master files, both ports and protocols are expressed using mnemonics
 or decimal numbers.

 */

@implementation UMDnsResourceRecordWKS


- (NSString *)recordTypeString
{
    return @"WKS";
}


- (UlibDnsResourceRecordType)recordType
{
    return UlibDnsResourceRecordType_WKS;
}

- (NSData *)resourceData
{
    unsigned char s[5];
    s[0] = (_address & 0xFF000000) >> 24;
    s[1] = (_address & 0x00FF0000) >> 16;
    s[2] = (_address & 0x0000FF00) >> 8;
    s[3] = (_address & 0x000000FF) >> 0;
    s[4] = (_protocol & 0xFF);
    NSMutableData *binary = [NSMutableData dataWithBytes:&s[0] length:5];
    [binary appendData:_bitmap];
    return binary;
}

- (void)setAddressFromString:(NSString *)str
{
    int a;
    int b;
    int c;
    int d;
    sscanf(str.UTF8String, "%d.%d.%d.%d",&a,&b,&c,&d);
    if(    (a<0) || (a > 0xFF)
       || (b<0) || (b > 0xFF)
       || (c<0) || (c > 0xFF)
       || (d<0) || (d > 0xFF))
    {
        @throw ([NSException exceptionWithName:@"invalid_address" reason:@"parts are not within 0...255" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
    self.address = a << 24 | b << 16 | c << 8 | d;
}

- (UMDnsResourceRecordWKS *)initWithAddressString:(NSString *)addr protocol:(uint8_t)p bitmap:(NSData *)bm;
{
    self = [super init];
    if(self)
    {
        [self setAddressFromString:addr];
        _protocol = p;
        _bitmap = bm;
    }
    return self;
}

- (UMDnsResourceRecordWKS *)initWithParams:(NSArray *)params zone:(NSString *)zone
{
    /* FIXME: how is this encoded in zone files? */
    return NULL;
}

@end
