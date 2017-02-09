//
//  UMDnsResourceRecordNULL.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecordNULL.h"

/*
3.3.10. NULL RDATA format (EXPERIMENTAL)

+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
/                  <anything>                   /
/                                               /
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

Anything at all may be in the RDATA field so long as it is 65535 octets
or less.

NULL records cause no additional section processing.  NULL RRs are not
allowed in master files.  NULLs are used as placeholders in some
experimental extensions of the DNS.


*/

@implementation UMDnsResourceRecordNULL

@synthesize data;

- (NSString *)recordTypeString
{
    return @"NULL";
}


- (UlibDnsResourceRecordType)recordType
{
    return UlibDnsResourceRecordType_NULL;
}

- (NSData *)resourceData
{
    return data;
}


- (UMDnsResourceRecordNULL *)initWithData:(NSData *)d
{
    self = [super init];
    if(self)
    {
        if( [d length] > 65535)
        {
            @throw ([NSException exceptionWithName:@"invalidData" reason:@"tried to initialize resoureRecordNULL with data bigger than  65535" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
        }
        data = d;
    }
    return self;
}

- (UMDnsResourceRecordNULL *)initWithParams:(NSArray *)params zone:(NSString *)zone
{
    NSString *p = params[0];
    NSData *d = [p unhexedData];
    return [self initWithData:d];
}

- (NSString *)visualRepresentation
{
    return [NSString stringWithFormat:@"NULL\t%@",[data hexString]];
}

@end
