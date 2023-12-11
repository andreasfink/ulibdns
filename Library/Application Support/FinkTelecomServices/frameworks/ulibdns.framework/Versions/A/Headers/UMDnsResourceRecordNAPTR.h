//
//  UMDnsResourceRecordNAPTR.h
//  ulibdns
//
//  Created by Andreas Fink on 01.11.21.
//  Copyright © 2021 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecord.h"
#import "UMDnsName.h"
#import "UMDnsCharacterString.h"

@interface UMDnsResourceRecordNAPTR : UMDnsResourceRecord
{
    uint16_t    _order;
    uint16_t    _preference;
    UMDnsCharacterString    *_flags;
    UMDnsCharacterString    *_service;
    UMDnsCharacterString    *_regexp;
    UMDnsName               *_replacement;
}

@property(readwrite,assign) uint16_t                order;
@property(readwrite,assign) uint16_t                preference;
@property(readwrite,strong) UMDnsCharacterString    *flags;
@property(readwrite,strong) UMDnsCharacterString    *service;
@property(readwrite,strong) UMDnsCharacterString    *regexp;
@property(readwrite,strong) UMDnsName               *replacement;

- (UMDnsResourceRecordNAPTR *)initWithString:(NSData *)string;
- (UMDnsResourceRecordNAPTR *)initWithStrings:(NSArray *)strings;

@end
