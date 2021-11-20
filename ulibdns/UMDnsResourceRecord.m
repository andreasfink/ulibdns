//
//  UMDnsResourceRecord.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecord.h"

#import "UMDnsResourceRecord_all.h"

@implementation UMDnsResourceRecord


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

NAME            an owner name, i.e., the name of the node to which this
resource record pertains.

TYPE            two octets containing one of the RR TYPE codes.

CLASS           two octets containing one of the RR CLASS codes.

TTL             a 32 bit signed integer that specifies the time interval
                that the resource record may be cached before the source
                of the information should again be consulted.  Zero
                values are interpreted to mean that the RR can only be
                used for the transaction in progress, and should not be
                cached.  For example, SOA records are always distributed
                with a zero TTL to prohibit caching.  Zero values can
                also be used for extremely volatile data.

RDLENGTH        an unsigned 16 bit integer that specifies the length in
                octets of the RDATA field.

RDATA           a variable length string of octets that describes the
resource.  The format of this information varies
according to the TYPE and CLASS of the resource record.

*/

- (NSData *)binary
{
    NSMutableData *binary = [[NSMutableData alloc]init];
    
    [binary appendData:[_name binary]];
    
    unsigned char typeBytes[2];
    typeBytes[0] = (_recordType & 0xFF00)>> 8;
    typeBytes[1] = (_recordType & 0x00FF);
    [binary appendBytes:typeBytes length:2];
    
    unsigned char classBytes[2];
    classBytes[0] = (_recordClass & 0xFF00)>> 8;
    classBytes[1] = (_recordClass & 0x00FF);
    [binary appendBytes:classBytes length:2];

    unsigned char ttlBytes[4];
    ttlBytes[0] = (_ttl & 0xFF000000)>> 24;
    ttlBytes[1] = (_ttl & 0x00FF0000)>> 16;
    ttlBytes[2] = (_ttl & 0x0000FF00)>> 8;
    ttlBytes[3] = (_ttl & 0x000000FF);
    [binary appendBytes:ttlBytes length:2];

    NSData *rData = [self resourceData];
    NSUInteger dataLen = [rData length];
    unsigned char dataLenBytes[2];
    dataLenBytes[0] = (dataLen & 0xFF00)>> 8;
    dataLenBytes[1] = (dataLen & 0x00FF);
    [binary appendBytes:dataLenBytes length:2];

    [binary appendData:rData];
    return binary;
}

- (void)setBinary:(NSData *)data
{
    UMAssert(0,@"WTF are we doing here?");
    /*
     NSUInteger pos = 0;
    UMDnsName *n = [[UMDnsName alloc]init];
    if(n)
    {
        pos = [n setBinary:data];
    }
     */
}

- (NSString *)recordClassString
{
    switch (_recordClass)
    {
        case UlibDnsClass_RESERVED:
            return @"RESERVED";
        case UlibDnsClass_IN:
            return @"IN";
        case UlibDnsClass_CS:
            return @"CS";
        case UlibDnsClass_CH:
            return @"CH";
        case UlibDnsClass_HS:
            return @"HS";
        default:
            return @"undefined";
    }
}
/* this should be overwritten by the specific subclass */
- (NSData *)resourceData
{
    return [[NSData alloc]init];
}


+ (UMDnsResourceRecord *)recordOfType:(NSString *)rrtypeName params:(NSArray *)params zone:(NSString *)zone
{
    UMDnsResourceRecord *rr = NULL;
    if( [rrtypeName caseInsensitiveCompare:@"A"]==NSOrderedSame)
    {
        rr = [[UMDnsResourceRecordA alloc]initWithParams:params zone:zone];
    }
    else if( [rrtypeName caseInsensitiveCompare:@"NS"]==NSOrderedSame)
    {
        rr = [[UMDnsResourceRecordNS alloc]initWithParams:params zone:zone];
    }
    else if( [rrtypeName caseInsensitiveCompare:@"CNAME"]==NSOrderedSame)
    {
        rr = [[UMDnsResourceRecordCNAME alloc]initWithParams:params zone:zone];
    }
    else if( [rrtypeName caseInsensitiveCompare:@"SOA"]==NSOrderedSame)
    {
        rr = [[UMDnsResourceRecordSOA alloc]initWithParams:params zone:zone];
    }
    else if( [rrtypeName caseInsensitiveCompare:@"MB"]==NSOrderedSame)
    {
        rr = [[UMDnsResourceRecordMB alloc]initWithParams:params zone:zone];
    }
    else if( [rrtypeName caseInsensitiveCompare:@"MD"]==NSOrderedSame)
    {
        rr = [[UMDnsResourceRecordMD alloc]initWithParams:params zone:zone];
    }
    else if( [rrtypeName caseInsensitiveCompare:@"MF"]==NSOrderedSame)
    {
        rr = [[UMDnsResourceRecordMF alloc]initWithParams:params zone:zone];
    }
    else if( [rrtypeName caseInsensitiveCompare:@"MG"]==NSOrderedSame)
    {
        rr = [[UMDnsResourceRecordMG alloc]initWithParams:params zone:zone];
    }
    else if( [rrtypeName caseInsensitiveCompare:@"MINFO"]==NSOrderedSame)
    {
        rr = [[UMDnsResourceRecordMINFO alloc]initWithParams:params zone:zone];
    }
    else if( [rrtypeName caseInsensitiveCompare:@"MR"]==NSOrderedSame)
    {
        rr = [[UMDnsResourceRecordMR alloc]initWithParams:params zone:zone];
    }
    else if( [rrtypeName caseInsensitiveCompare:@"MX"]==NSOrderedSame)
    {
        rr = [[UMDnsResourceRecordMX alloc]initWithParams:params zone:zone];
    }
    else if( [rrtypeName caseInsensitiveCompare:@"NULL"]==NSOrderedSame)
    {
        rr = [[UMDnsResourceRecordNULL alloc]initWithParams:params zone:zone];
    }
    else if( [rrtypeName caseInsensitiveCompare:@"WKS"]==NSOrderedSame)
    {
        rr = [[UMDnsResourceRecordWKS alloc]initWithParams:params zone:zone];
    }
    else if( [rrtypeName caseInsensitiveCompare:@"PTR"]==NSOrderedSame)
    {
        rr = [[UMDnsResourceRecordPTR alloc]initWithParams:params zone:zone];
    }
    else if( [rrtypeName caseInsensitiveCompare:@"HINFO"]==NSOrderedSame)
    {
        rr = [[UMDnsResourceRecordHINFO alloc]initWithParams:params zone:zone];
    }
    else if( [rrtypeName caseInsensitiveCompare:@"TXT"]==NSOrderedSame)
    {
        rr = [[UMDnsResourceRecordTXT alloc]initWithParams:params zone:zone];
    }
    else if( [rrtypeName caseInsensitiveCompare:@"AAAA"]==NSOrderedSame)
    {
        rr = [[UMDnsResourceRecordAAAA alloc]initWithParams:params zone:zone];
    }
    else if( [rrtypeName caseInsensitiveCompare:@"SRV"]==NSOrderedSame)
    {
        rr = [[UMDnsResourceRecordSRV alloc]initWithParams:params zone:zone];
    }
    else if( [rrtypeName caseInsensitiveCompare:@"NAPTR"]==NSOrderedSame)
    {
        rr = [[UMDnsResourceRecordNAPTR alloc]initWithParams:params zone:zone];
    }
    else
    {
        @throw ([NSException exceptionWithName:@"unknown_resource_record_type" reason:rrtypeName userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
    return rr;
}

- (UMDnsResourceRecord *)initWithParams:(NSArray *)params zone:(NSString *)zone
{
    NSAssert(0,@"we do have a record type which doesnt implement method initWithParams:");
    return NULL;
}

-(NSString *)visualRepresentation
{
    NSAssert(0,@"we do have a record type which doesnt implement method visualRepresentation");
    return @"";
}

- (UMDnsResourceRecord *)initWithRawData:(NSData *)data atOffset:(int *)pos
{
    NSAssert(0,@"we do have a record type which doesnt implement method initWithRawData:atOffset");
    return NULL;
}

- (NSString *)recordTypeString
{
    NSAssert(0,@"we do have a record type which doesnt implement method recordTypeString");
   return NULL;
}


@end
