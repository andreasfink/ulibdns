//
//  UMDnsZone.h
//  ulibdns
//
//  Created by Andreas Fink on 31.08.15.
//  Copyright (c) 2016 Andreas Fink
//

#import <ulib/ulib.h>

#import "UMDnsName.h"
#import "UMDnsResourceRecord.h"
#import "UMDnsResourceRecordNS.h"
#import "UMDnsResourceRecordSOA.h"

@interface UMDnsZone : UMObject
{
    UMDnsName *defaultOrigin;
    UMDnsResourceRecordSOA *soa;
    UMSynchronizedArray *rr; /* UMDnsResourceRecord objects */
    UMSynchronizedDictionary *rrByName; /* dictionary by name pointing to UMSynchronizedArray's */
    NSInteger   defaultTtl;
}

@property(readwrite,assign) NSInteger defaultTtl;

- (UMDnsZone *)initWithFile:(NSString *)filename origin:(NSString *)origin defaultTtl:(int)ttl;
- (NSArray *)parseData:(NSData *)zonedata forFile:(NSString *)filename origin:(NSString *)newOrigin;
- (void)processLine:(NSString *)filename lineNo:(int)lineno  line:(NSString *)currentLine last:(UMDnsName **)lastDnsName;

@end
