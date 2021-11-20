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
    int _a;
    int _b;
    int _port;
    UMDnsName *_host;
}

@property(readwrite,assign) int a;
@property(readwrite,assign) int b;
@property(readwrite,assign) int port;
@property(readwrite,strong) UMDnsName *host;

@property(readwrite,strong) NSData *data;

- (UMDnsResourceRecordNAPTR *)initWithString:(NSData *)string;
- (UMDnsResourceRecordNAPTR *)initWithStrings:(NSArray *)strings;

@end
