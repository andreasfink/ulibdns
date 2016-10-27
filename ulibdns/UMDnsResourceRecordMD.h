//
//  UMDnsResourceRecordMD.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright (c) 2016 Andreas Fink
//

#import "UMDnsResourceRecord.h"


@interface UMDnsResourceRecordMD : UMDnsResourceRecord
{
    UMDnsName *madname;
}

@property (readwrite,strong) UMDnsName *madname;

- (UMDnsResourceRecordMD *)initWithMadname:(UMDnsName *)a;
- (UMDnsResourceRecordMD *)initWithParams:(NSArray *)params zone:(NSString *)zone;

@end
