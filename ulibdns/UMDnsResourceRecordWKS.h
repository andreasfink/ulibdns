//
//  UMDnsResourceRecordWKS.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright (c) 2016 Andreas Fink
//

#import "UMDnsResourceRecord.h"

@interface UMDnsResourceRecordWKS : UMDnsResourceRecord
{
    uint32_t    address;
    uint8_t     protocol;
    NSData      *bitmap;
}


@property(readwrite,assign) uint32_t    address;
@property(readwrite,assign) uint8_t     protocol;
@property(readwrite,strong) NSData      *bitmap;

- (UMDnsResourceRecordWKS *)initWithParams:(NSArray *)params zone:(NSString *)zone;

@end
