//
//  UMDnsResourceRecordNS.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecord.h"

@interface UMDnsResourceRecordNS : UMDnsResourceRecord
{
    UMDnsName *nsname;
}

@property (readwrite,strong) UMDnsName *nsname;
- (UMDnsResourceRecordNS *)initWithNSName:(NSString *)a;
- (UMDnsResourceRecordNS *)initWithParams:(NSArray *)params zone:(NSString *)zone;

@end
