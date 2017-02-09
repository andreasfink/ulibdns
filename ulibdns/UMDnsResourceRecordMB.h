//
//  UMDnsResourceRecordMB.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecord.h"

@interface UMDnsResourceRecordMB : UMDnsResourceRecord
{
    UMDnsName *madname;
}

@property (readwrite,strong) UMDnsName *madname;

- (UMDnsResourceRecordMB *)initWithMadname:(UMDnsName *)a;
- (UMDnsResourceRecordMB *)initWithParams:(NSArray *)params zone:(NSString *)zone;


@end
