//
//  UMDnsResourceRecordNULL.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright (c) 2016 Andreas Fink
//

#import "UMDnsResourceRecord.h"

@interface UMDnsResourceRecordNULL : UMDnsResourceRecord
{
    NSData *data;
}

@property(readwrite,strong) NSData *data;

- (UMDnsResourceRecordNULL *)initWithData:(NSData *)d;
- (UMDnsResourceRecordNULL *)initWithParams:(NSArray *)params zone:(NSString *)zone;

@end;