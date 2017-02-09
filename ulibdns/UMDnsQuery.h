//
//  UMDnsQuery.h
//  ulibdns
//
//  Created by Andreas Fink on 31.08.15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ulib/ulib.h>
#import "ulibdns_types.h"
#import "UMDnsName.h"

@interface UMDnsQuery : UMObject
{
    UMDnsName                   *name;
    UlibDnsResourceRecordType   recordType;
    UlibDnsClass                recordClass;
}

@property(readwrite,strong) UMDnsName                   *name;
@property(readwrite,assign) UlibDnsResourceRecordType   recordType;
@property(readwrite,assign) UlibDnsClass                recordClass;


@end
