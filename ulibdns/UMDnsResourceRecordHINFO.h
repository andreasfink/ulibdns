//
//  UMDnsResourceRecordHINFO.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecord.h"
#import "UMDnsCharacterString.h"

@interface UMDnsResourceRecordHINFO : UMDnsResourceRecord
{
    UMDnsCharacterString *cpu;
    UMDnsCharacterString *os;
}

@property(readwrite,strong) UMDnsCharacterString *cpu;
@property(readwrite,strong) UMDnsCharacterString *os;

- (NSString *)visualRepresentation;
@end
