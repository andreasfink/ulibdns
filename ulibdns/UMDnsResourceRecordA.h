//
//  UMDnsResourceRecordA.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecord.h"

@interface UMDnsResourceRecordA : UMDnsResourceRecord
{
    struct in_addr addr;
}


- (NSData *)resourceData;
- (void)setAddressFromString:(NSString *)str;
- (UMDnsResourceRecordA *)initWithAddressString:(NSString *)a;
- (UMDnsResourceRecordA *)initWithParams:(NSArray *)params zone:(NSString *)zone;
- (NSString *)recordTypeString;

@end
