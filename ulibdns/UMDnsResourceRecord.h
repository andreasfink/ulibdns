//
//  UMDnsResourceRecord.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ulib/ulib.h>
#import "ulibdns_types.h"
#import "UMDnsName.h"

/*
All RRs have the same top level format shown below:

1  1  1  1  1  1
0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                                               |
/                                               /
/                      NAME                     /
|                                               |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                      TYPE                     |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                     CLASS                     |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                      TTL                      |
|                                               |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                   RDLENGTH                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
/                     RDATA                     /
/                                               /
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
*/

@interface UMDnsResourceRecord : UMObject
{
    UMDnsName                   *name;
    UlibDnsResourceRecordType   recordType;
    UlibDnsClass                recordClass;
    NSInteger                   ttl;
}


@property(readwrite,strong) UMDnsName                   *name;
@property(readwrite,assign) UlibDnsResourceRecordType   recordType;
@property(readwrite,assign) UlibDnsClass                recordClass;
@property(readwrite,assign) NSInteger                   ttl;
@property(readwrite,strong) NSData                      *rData;

- (NSData *)binary;
- (NSData *)resourceData;
- (NSString *)recordTypeString;

+ (UMDnsResourceRecord *)recordOfType:(NSString *)rrtypeName params:(NSArray *)params zone:(NSString *)zone;
- (UMDnsResourceRecord *)initWithParams:(NSArray *)params zone:(NSString *)zone;
- (UMDnsResourceRecord *)initWithRawData:(NSData *)data atOffset:(int *)pos;
- (NSString *)visualRepresentation;
- (NSString *)recordClassString;

@end
