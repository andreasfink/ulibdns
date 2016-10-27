//
//  UMDnsResourceRecordPTR.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright (c) 2016 Andreas Fink
//

#import "UMDnsResourceRecord.h"

@interface UMDnsResourceRecordPTR : UMDnsResourceRecord
{
    UMDnsName *ptrname;
}

@property (readwrite,strong) UMDnsName *ptrname;
- (UMDnsResourceRecordPTR *)initWithPtrName:(UMDnsName *)a;

@end
