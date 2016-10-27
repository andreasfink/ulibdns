//
//  UMDnsResourceRecordMF.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright (c) 2016 Andreas Fink
//

#import "UMDnsResourceRecord.h"

@interface UMDnsResourceRecordMF : UMDnsResourceRecord
{
    UMDnsName *madname;
}

@property (readwrite,strong) UMDnsName *madname;
- (UMDnsResourceRecordMF *)initWithMadname:(UMDnsName *)a;
- (UMDnsResourceRecordMF *)initWithParams:(NSArray *)params zone:(NSString *)zone;

@end
