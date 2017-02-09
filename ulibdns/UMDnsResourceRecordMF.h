//
//  UMDnsResourceRecordMF.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
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
