//
//  UMDnsResourceRecordTXT.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright (c) 2016 Andreas Fink
//

#import "UMDnsResourceRecord.h"

@interface UMDnsResourceRecordTXT : UMDnsResourceRecord
{
    NSArray *txtRecords;
}

@property(readwrite,strong) NSData *data;

- (UMDnsResourceRecordTXT *)initWithString:(NSData *)string;
- (UMDnsResourceRecordTXT *)initWithStrings:(NSArray *)strings;


@end
