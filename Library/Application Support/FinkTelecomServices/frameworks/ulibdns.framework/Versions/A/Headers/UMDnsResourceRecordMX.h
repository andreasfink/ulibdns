//
//  UMDnsResourceRecordMX.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecord.h"

@interface UMDnsResourceRecordMX : UMDnsResourceRecord
{
    uint16_t    _preference;
    UMDnsName   *_exchanger;
}

@property(readwrite,assign) uint16_t    preference;
@property(readwrite,strong) UMDnsName   *exchanger;

- (UMDnsResourceRecordMX *)initWithParams:(NSArray *)params zone:(NSString *)zone;

@end
