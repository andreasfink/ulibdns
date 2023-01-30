//
//  UMDnsResourceRecordMD.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecord.h"


@interface UMDnsResourceRecordMD : UMDnsResourceRecord
{
    UMDnsName *_madname;
}

@property (readwrite,strong) UMDnsName *madname;

- (UMDnsResourceRecordMD *)initWithMadname:(UMDnsName *)a;
- (UMDnsResourceRecordMD *)initWithParams:(NSArray *)params zone:(NSString *)zone;

@end
