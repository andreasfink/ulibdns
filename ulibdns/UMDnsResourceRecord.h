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
    UMDnsName                   *_name;
    UlibDnsResourceRecordType   _recordType;
    UlibDnsClass                _recordClass;
    NSInteger                   _ttl;
}


@property(readwrite,strong) UMDnsName                   *name;
@property(readwrite,assign) UlibDnsResourceRecordType   recordType;
@property(readwrite,assign) UlibDnsClass                recordClass;
@property(readwrite,assign) NSInteger                   ttl;
@property(readwrite,strong) NSData                      *rData;

- (NSData *)encodedData;
- (void)setEncodedData:(NSData *)data;
- (NSData *)resourceData;
- (NSString *)recordTypeString;

+ (UMDnsResourceRecord *)recordOfType:(UlibDnsResourceRecordType)rrtype
                               params:(NSArray<NSString *>*)params
                                 zone:(NSString *)zone;

+ (UMDnsResourceRecord *)recordOfTypeString:(NSString *)rrtype
                                     params:(NSArray *)params
                                       zone:(NSString *)zone;
+(UlibDnsResourceRecordType)resourceRecordTypeFromString:(NSString *)rrtypeName;

- (UMDnsResourceRecord *)initWithParams:(NSArray *)params zone:(NSString *)zone;
- (UMDnsResourceRecord *)initWithRawData:(NSData *)data atOffset:(size_t *)pos;
- (NSString *)visualRepresentation;
- (NSString *)recordClassString;

@end
