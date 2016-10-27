
//
//  UMDnsResourceRecordSOA.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright (c) 2016 Andreas Fink
//

#import "UMDnsResourceRecordSOA.h"
#import "UMDnsName.h"

/*
 
 3.3.13. SOA RDATA format
 
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 /                     MNAME                     /
 /                                               /
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 /                     RNAME                     /
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 |                    SERIAL                     |
 |                                               |
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 |                    REFRESH                    |
 |                                               |
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 |                     RETRY                     |
 |                                               |
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 |                    EXPIRE                     |
 |                                               |
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 |                    MINIMUM                    |
 |                                               |
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 
 where:
 
 MNAME           The <domain-name> of the name server that was the
 original or primary source of data for this zone.
 
 RNAME           A <domain-name> which specifies the mailbox of the
 person responsible for this zone.
 
 SERIAL          The unsigned 32 bit version number of the original copy
 of the zone.  Zone transfers preserve this value.  This
 value wraps and should be compared using sequence space
 arithmetic.
 
 REFRESH         A 32 bit time interval before the zone should be
 refreshed.
 
 RETRY           A 32 bit time interval that should elapse before a
 failed refresh should be retried.
 
 EXPIRE          A 32 bit time value that specifies the upper limit on
 the time interval that can elapse before the zone is no
 longer authoritative.
 
 MINIMUM         The unsigned 32 bit minimum TTL field that should be
 exported with any RR from this zone.
 
 SOA records cause no additional section processing.
 
 All times are in units of seconds.
 
 Most of these fields are pertinent only for name server maintenance
 operations.  However, MINIMUM is used in all query operations that
 retrieve RRs from a zone.  Whenever a RR is sent in a response to a
 query, the TTL field is set to the maximum of the TTL field from the RR
 and the MINIMUM field in the appropriate SOA.  Thus MINIMUM is a lower
 bound on the TTL field for all RRs in a zone.  Note that this use of
 MINIMUM should occur when the RRs are copied into the response and not
 when the zone is loaded from a master file or via a zone transfer.  The
 reason for this provison is to allow future dynamic update facilities to
 change the SOA RR with known semantics.

 */

@implementation UMDnsResourceRecordSOA

@synthesize mname;
@synthesize rname;
@synthesize serial;
@synthesize refresh;
@synthesize retry;
@synthesize expire;
@synthesize minimum;

- (NSString *)recordTypeString
{
    return @"SOA";
}

- (UlibDnsResourceRecordType)recordType
{
    return UlibDnsResourceRecordType_SOA;
}

- (NSData *)resourceData
{
    NSMutableData *binary = [[NSMutableData alloc]init];
    
    [binary appendData:[mname binary]];
    [binary appendData:[rname binary]];
    
    unsigned char s[20];
    s[0] = (serial & 0xFF000000) >> 24;
    s[1] = (serial & 0x00FF0000) >> 16;
    s[2] = (serial & 0x0000FF00) >> 8;
    s[3] = (serial & 0x000000FF) >> 0;

    s[4] = (refresh & 0xFF000000) >> 24;
    s[5] = (refresh & 0x00FF0000) >> 16;
    s[6] = (refresh & 0x0000FF00) >> 8;
    s[7] = (refresh & 0x000000FF) >> 0;

    s[8] = (retry & 0xFF000000) >> 24;
    s[9] = (retry & 0x00FF0000) >> 16;
    s[10] = (retry & 0x0000FF00) >> 8;
    s[11] = (retry & 0x000000FF) >> 0;

    s[12] = (expire & 0xFF000000) >> 24;
    s[13] = (expire & 0x00FF0000) >> 16;
    s[14] = (expire & 0x0000FF00) >> 8;
    s[15] = (expire & 0x000000FF) >> 0;

    s[16] = (minimum & 0xFF000000) >> 24;
    s[17] = (minimum & 0x00FF0000) >> 16;
    s[18] = (minimum & 0x0000FF00) >> 8;
    s[19] = (minimum & 0x000000FF) >> 0;

    [binary appendData:[NSData dataWithBytes:&s length:20]];

    return binary;
}


- (UMDnsResourceRecordSOA *)initWithMName:(UMDnsName *)a
                                    rName:(UMDnsName *)b
                                   serial:(uint32_t)s
                                  refresh:(uint32_t)r
                                    retry:(uint32_t)rtry
                                   expire:(uint32_t)exp
                                  minimum:(uint32_t)min
{
    self = [super init];
    if(self)
    {
        mname = a;
        rname = b;
        serial = s;
        refresh = r;
        retry = rtry;
        expire = exp;
        minimum = min;
    }
    return self;
}

- (UMDnsResourceRecordSOA *)initWithParams:(NSArray *)params zone:(NSString *)zone
{
    UMDnsName *m  = [[UMDnsName alloc]initWithVisualName:params[0] relativeToZone:zone];
    UMDnsName *r  = [[UMDnsName alloc]initWithVisualName:params[1] relativeToZone:zone];
    uint32_t s   = (uint32_t)([params[2] longLongValue]);
    uint32_t re  = (uint32_t)([params[3] longLongValue]);
    uint32_t ry  = (uint32_t)([params[4] longLongValue]);
    uint32_t ex  = (uint32_t)([params[5] longLongValue]);
    uint32_t mi  = (uint32_t)([params[6] longLongValue]);

    return [self initWithMName:m
                         rName:r
                        serial:s
                       refresh:re
                         retry:ry
                        expire:ex
                       minimum:mi ];


}

- (NSString *)visualRepresentation
{
    NSMutableString *s = [[NSMutableString alloc]init];
    
    [s appendFormat:@"SOA %@ %@ (\n",mname.visualNameAbsoluteWriting,rname.visualNameAbsoluteWriting];
    [s appendFormat:@"\t%10d; serial INCREMENT AFTER CHANGE\n",serial];
    [s appendFormat:@"\t%10d; refresh every %d hours\n",refresh,refresh/60/60];
    [s appendFormat:@"\t%10d; if refres fails, retry all %d minutes\n",retry,retry/60];
    [s appendFormat:@"\t%10d; expire secondary after %d days\n",expire,expire/60/60/24];
    [s appendFormat:@"\t%10d; minimum in cache\n",minimum];
    [s appendFormat:@"\t);\n"];
    return s;
}
@end
