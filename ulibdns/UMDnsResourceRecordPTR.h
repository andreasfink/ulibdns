//
//  UMDnsResourceRecordPTR.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecord.h"

@interface UMDnsResourceRecordPTR : UMDnsResourceRecord
{
    UMDnsName *ptrname;
}

@property (readwrite,strong) UMDnsName *ptrname;
- (UMDnsResourceRecordPTR *)initWithPtrName:(UMDnsName *)a;

@end
