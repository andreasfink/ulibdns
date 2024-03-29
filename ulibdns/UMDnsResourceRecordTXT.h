//
//  UMDnsResourceRecordTXT.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecord.h"

@interface UMDnsResourceRecordTXT : UMDnsResourceRecord
{
    NSArray *_txtRecords;
}

@property(readwrite,strong)     NSArray *txtRecords;

- (UMDnsResourceRecordTXT *)initWithString:(NSData *)string;
- (UMDnsResourceRecordTXT *)initWithStrings:(NSArray *)strings;


@end
