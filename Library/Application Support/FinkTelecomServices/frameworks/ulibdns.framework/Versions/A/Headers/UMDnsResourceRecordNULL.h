//
//  UMDnsResourceRecordNULL.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecord.h"

@interface UMDnsResourceRecordNULL : UMDnsResourceRecord
{
    NSData *_data;
}

@property(readwrite,strong) NSData *data;

- (UMDnsResourceRecordNULL *)initWithData:(NSData *)d;
- (UMDnsResourceRecordNULL *)initWithParams:(NSArray *)params zone:(NSString *)zone;

@end;
