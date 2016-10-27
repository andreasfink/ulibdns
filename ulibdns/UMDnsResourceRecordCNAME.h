//
//  UMDnsResourceRecordCNAME.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright (c) 2016 Andreas Fink
//

#import "UMDnsResourceRecord.h"

@interface UMDnsResourceRecordCNAME : UMDnsResourceRecord
{
    UMDnsName *aliasName;
}

@property (readwrite,strong) UMDnsName *aliasName;

- (UMDnsResourceRecordCNAME *)initWithCname:(UMDnsName *)a;
- (UMDnsResourceRecordCNAME *)initWithParams:(NSArray *)params zone:(NSString *)zone;
@end
