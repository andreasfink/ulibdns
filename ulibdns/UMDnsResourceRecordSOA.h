//
//  UMDnsResourceRecordSOA.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecord.h"

@interface UMDnsResourceRecordSOA : UMDnsResourceRecord
{
    UMDnsName   *mname;
    UMDnsName   *rname;
    uint32_t    serial;
    uint32_t    refresh;
    uint32_t    retry;
    uint32_t    expire;
    uint32_t    minimum;
}


@property(readwrite,strong) UMDnsName   *mname;
@property(readwrite,strong) UMDnsName   *rname;
@property(readwrite,assign) uint32_t    serial;
@property(readwrite,assign) uint32_t    refresh;
@property(readwrite,assign) uint32_t    retry;
@property(readwrite,assign) uint32_t    expire;
@property(readwrite,assign) uint32_t    minimum;


- (UMDnsResourceRecordSOA *)initWithMName:(UMDnsName *)a
                                    rName:(UMDnsName *)b
                                   serial:(uint32_t)s
                                  refresh:(uint32_t)r
                                    retry:(uint32_t)rtry
                                   expire:(uint32_t)exp
                                  minimum:(uint32_t)min;

- (UMDnsResourceRecordSOA *)initWithParams:(NSArray *)params zone:(NSString *)zone;


@end
