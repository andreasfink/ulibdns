//
//  UMDnsResourceRecordSRV.h
//  ulibdns
//
//  Created by Andreas Fink on 08/09/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulibdns/ulibdns.h>

@interface UMDnsResourceRecordSRV : UMDnsResourceRecord
{
    int a;
    int b;
    int port;
    UMDnsName *host;
}

@property(readwrite,strong) NSData *data;

- (UMDnsResourceRecordSRV *)initWithString:(NSData *)string;
- (UMDnsResourceRecordSRV *)initWithStrings:(NSArray *)strings;


@end
