//
//  UMDnsResourceRecordAAAA.h
//  ulibdns
//
//  Created by Andreas Fink on 01/09/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecord.h"

@interface UMDnsResourceRecordAAAA : UMDnsResourceRecord
{
    struct in6_addr addr6;
}


- (NSData *)resourceData;
- (void)setAddressFromString:(NSString *)str;
- (UMDnsResourceRecordAAAA *)initWithAddressString:(NSString *)a;
- (UMDnsResourceRecordAAAA *)initWithParams:(NSArray *)params  zone:(NSString *)zone;
- (UMDnsResourceRecordAAAA *)initWithRawData:(NSData *)data atOffset:(int *)pos;

@end
