//
//  UMDnsQuery.h
//  ulibdns
//
//  Created by Andreas Fink on 31.08.15.
//  Copyright (c) 2016 Andreas Fink
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
