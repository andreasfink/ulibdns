//
//  UMDnsResourceRecordNAPTR.h
//  ulibdns
//
//  Created by Andreas Fink on 01.11.21.
//  Copyright © 2021 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulibdns/ulibdns.h>

@interface UMDnsResourceRecordNAPTR : UMDnsResourceRecord
{
    int a;
    int b;
    int port;
    UMDnsName *host;
}

@property(readwrite,strong) NSData *data;

- (UMDnsResourceRecordNAPTR *)initWithString:(NSData *)string;
- (UMDnsResourceRecordNAPTR *)initWithStrings:(NSArray *)strings;

@end
