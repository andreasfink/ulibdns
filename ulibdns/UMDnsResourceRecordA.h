//
//  UMDnsResourceRecordA.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright (c) 2016 Andreas Fink
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
