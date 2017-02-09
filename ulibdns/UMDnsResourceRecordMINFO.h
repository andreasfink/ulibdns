//
//  UMDnsResourceRecordMINFO.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecord.h"

@interface UMDnsResourceRecordMINFO : UMDnsResourceRecord
{
    UMDnsName *rMailBx;
    UMDnsName *eMailBx;
}

@property(readwrite,strong) UMDnsName *rMailBx;
@property(readwrite,strong) UMDnsName *eMailBx;


- (UMDnsResourceRecordMINFO *)initWithRMailBx:(UMDnsName *)a eMailBx:(UMDnsName *)b;
- (UMDnsResourceRecordMINFO *)initWithParams:(NSArray *)params zone:(NSString *)zone;


@end
