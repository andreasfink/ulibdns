//
//  UMDnsMessage.h
//  ulibdns
//
//  Created by Andreas Fink on 31.08.15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>
#import "UMDnsResourceRecord.h"
#import "UMDnsQuery.h"
#import "UMDnsHeader.h"

@interface UMDnsMessage : UMObject
{
    UMDnsHeader         *_header;
    NSArray             *_queries; /* array of UMDnsQuery objects */
    NSArray             *_answers; /* array of UMDnsResourceRecord objects */
    UMDnsResourceRecord *_authority;
    UMDnsResourceRecord *_additional;
}

@property(readwrite,strong,atomic)  UMDnsHeader         *header;
@property(readwrite,strong,atomic)  NSArray             *queries; /* array of UMDnsQuery objects */
@property(readwrite,strong,atomic)  NSArray             *answers; /* array of UMDnsResourceRecord objects */
@property(readwrite,strong,atomic)  UMDnsResourceRecord *authority;
@property(readwrite,strong,atomic)  UMDnsResourceRecord *additional;

@end
