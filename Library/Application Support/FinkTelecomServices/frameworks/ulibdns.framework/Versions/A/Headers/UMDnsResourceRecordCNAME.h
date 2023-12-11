//
//  UMDnsResourceRecordCNAME.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecord.h"

@interface UMDnsResourceRecordCNAME : UMDnsResourceRecord
{
    UMDnsName *_aliasName;
}

@property (readwrite,strong) UMDnsName *aliasName;

- (UMDnsResourceRecordCNAME *)initWithCname:(UMDnsName *)a;
- (UMDnsResourceRecordCNAME *)initWithParams:(NSArray *)params zone:(NSString *)zone;
@end
