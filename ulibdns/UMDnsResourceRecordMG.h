//
//  UMDnsResourceRecordMG.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright (c) 2016 Andreas Fink
//

#import "UMDnsResourceRecord.h"

@interface UMDnsResourceRecordMG : UMDnsResourceRecord
{
    UMDnsName *mgmname;
}

@property (readwrite,strong) UMDnsName *mgmname;
- (UMDnsResourceRecordMG *)initWithMgmname:(UMDnsName *)a;
- (UMDnsResourceRecordMG *)initWithParams:(NSArray *)params zone:(NSString *)zone;

@end
