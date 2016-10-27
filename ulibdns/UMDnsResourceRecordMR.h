//
//  UMDnsResourceRecordMR.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright (c) 2016 Andreas Fink
//

#import "UMDnsResourceRecord.h"

@interface UMDnsResourceRecordMR : UMDnsResourceRecord
{
    UMDnsName *newname;
}

@property (readwrite,strong) UMDnsName *newname;

- (UMDnsResourceRecordMR *)initWithNewname:(UMDnsName *)a;
- (UMDnsResourceRecordMR *)initWithParams:(NSArray *)params zone:(NSString *)zone;

@end
