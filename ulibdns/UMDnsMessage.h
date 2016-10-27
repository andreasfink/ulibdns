//
//  UMDnsMessage.h
//  ulibdns
//
//  Created by Andreas Fink on 31.08.15.
//  Copyright (c) 2016 Andreas Fink
//

#import <ulib/ulib.h>
#import "UMDnsResourceRecord.h"
#import "UMDnsQuery.h"
#import "UMDnsHeader.h"

@interface UMDnsMessage : UMObject
{
    UMDnsHeader         *header;
    NSArray             *queries; /* array of UMDnsQuery objects */
    NSArray             *answers; /* array of UMDnsResourceRecord objects */
    UMDnsResourceRecord *authority;
    UMDnsResourceRecord *additional;
}

@end
