//
//  UMDnsResourceRecordMX.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright (c) 2016 Andreas Fink
//

#import "UMDnsResourceRecord.h"

@interface UMDnsResourceRecordMX : UMDnsResourceRecord
{
    uint16_t    preference;
    UMDnsName   *exchanger;
}

@property(readwrite,assign) uint16_t    preference;
@property(readwrite,strong) UMDnsName   *exchanger;

- (UMDnsResourceRecordMX *)initWithParams:(NSArray *)params zone:(NSString *)zone;

@end
