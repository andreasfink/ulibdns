//
//  UMDnsResourceRecordWKS.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecord.h"

@interface UMDnsResourceRecordWKS : UMDnsResourceRecord
{
    uint32_t    _address;
    uint8_t     _protocol;
    NSData      *_bitmap;
}


@property(readwrite,assign) uint32_t    address;
@property(readwrite,assign) uint8_t     protocol;
@property(readwrite,strong) NSData      *bitmap;

- (UMDnsResourceRecordWKS *)initWithParams:(NSArray *)params zone:(NSString *)zone;

@end
