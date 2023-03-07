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

- (NSData *)encodedData
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

- (void)setEncodedData:(NSData *)data
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


+ (UMDnsResourceRecord *)recordOfType:(UlibDnsResourceRecordType)rrtype
                               params:(NSArray<NSString *>*)params
                                 zone:(NSString *)zone
{
    UMDnsResourceRecord *rr = NULL;
    switch(rrtype)
    {
        case UlibDnsResourceRecordType_A:
        {
            rr = [[UMDnsResourceRecordA alloc]initWithParams:params zone:zone];
            break;
        }
        case UlibDnsResourceRecordType_NS:
        {
            rr = [[UMDnsResourceRecordNS alloc]initWithParams:params zone:zone];
            break;
        }
        case UlibDnsResourceRecordType_MD:
        {
            rr = [[UMDnsResourceRecordMD alloc]initWithParams:params zone:zone];
            break;
        }
        case UlibDnsResourceRecordType_MF:
        {
            rr = [[UMDnsResourceRecordMF alloc]initWithParams:params zone:zone];
            break;
        }
        case UlibDnsResourceRecordType_CNAME:
        {
            rr = [[UMDnsResourceRecordCNAME alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_SOA:
        {
            rr = [[UMDnsResourceRecordSOA alloc]initWithParams:params zone:zone];
            break;
        }
        case UlibDnsResourceRecordType_MB:
        {
            rr = [[UMDnsResourceRecordMB alloc]initWithParams:params zone:zone];
            break;
        }
        case UlibDnsResourceRecordType_MG:
        {
            rr = [[UMDnsResourceRecordMG alloc]initWithParams:params zone:zone];
            break;
        }
        case UlibDnsResourceRecordType_MR:
        {
            rr = [[UMDnsResourceRecordMR alloc]initWithParams:params zone:zone];
            break;
        }
        case UlibDnsResourceRecordType_NULL:
        {
            rr = [[UMDnsResourceRecordNULL alloc]initWithParams:params zone:zone];
            break;
        }
        case UlibDnsResourceRecordType_WKS:
        {
            rr = [[UMDnsResourceRecordWKS alloc]initWithParams:params zone:zone];
            break;
        }
        case UlibDnsResourceRecordType_PTR:
        {
            rr = [[UMDnsResourceRecordPTR alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_HINFO:
        {
            rr = [[UMDnsResourceRecordHINFO alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_MINFO:
        {
            rr = [[UMDnsResourceRecordMINFO alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_MX:
        {
            rr = [[UMDnsResourceRecordMX alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_TXT:
        {
            rr = [[UMDnsResourceRecordTXT alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_RP:
        {
            rr = [[UMDnsResourceRecordRP alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_AFSDB:
        {
            rr = [[UMDnsResourceRecordAFSDB alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_X25:
        {
            rr = [[UMDnsResourceRecordX25 alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_ISDN:
        {
            rr = [[UMDnsResourceRecordISDN alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_RT:
        {
            rr = [[UMDnsResourceRecordRT alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_NSAP:
        {
            rr = [[UMDnsResourceRecordNSAP alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_NSAP_PTR:
        {
            rr = [[UMDnsResourceRecordNSAP_PTR alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_SIG:
        {
            rr = [[UMDnsResourceRecordSIG alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_KEY:
        {
            rr = [[UMDnsResourceRecordKEY alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_PX:
        {
            rr = [[UMDnsResourceRecordPX alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_GPOS:
        {
            rr = [[UMDnsResourceRecordGPOS alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_AAAA:
        {
            rr = [[UMDnsResourceRecordAAAA alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_LOC:
        {
            rr = [[UMDnsResourceRecordLOC alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_NXT:
        {
            rr = [[UMDnsResourceRecordNXT alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_EID:
        {
            rr = [[UMDnsResourceRecordEID alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_NIMLOC:
        {
            rr = [[UMDnsResourceRecordNIMLOC alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_SRV:
        {
            rr = [[UMDnsResourceRecordSRV alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_ATMA:
        {
            rr = [[UMDnsResourceRecordATMA alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_NAPTR:
        {
            rr = [[UMDnsResourceRecordNAPTR alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_KX:
        {
            rr = [[UMDnsResourceRecordKX alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_CERT:
        {
            rr = [[UMDnsResourceRecordCERT alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_A6:
        {
            rr = [[UMDnsResourceRecordA6 alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_DNAME:
        {
            rr = [[UMDnsResourceRecordDNAME alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_SINK:
        {
            rr = [[UMDnsResourceRecordSINK alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_OPT:
        {
            rr = [[UMDnsResourceRecordOPT alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_APL:
        {
            rr = [[UMDnsResourceRecordAPL alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_DS:
        {
            rr = [[UMDnsResourceRecordDS alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_SSHFP:
        {
            rr = [[UMDnsResourceRecordSSHFP alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_IPSECKEY:
        {
            rr = [[UMDnsResourceRecordIPSECKEY alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_RRSIG:
        {
            rr = [[UMDnsResourceRecordRRSIG alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_NSEC:
        {
            rr = [[UMDnsResourceRecordNSEC alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_DNSKEY:
        {
            rr = [[UMDnsResourceRecordDNSKEY alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_DHCID:
        {
            rr = [[UMDnsResourceRecordDHCID alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_NSEC3:
        {
            rr = [[UMDnsResourceRecordNSEC3 alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_NSEC3PARAM:
        {
            rr = [[UMDnsResourceRecordNSEC3PARAM alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_TLSA:
        {
            rr = [[UMDnsResourceRecordTLSA alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_HIP:
        {
            rr = [[UMDnsResourceRecordHIP alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_NINFO:
        {
            rr = [[UMDnsResourceRecordNINFO alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_RKEY:
        {
            rr = [[UMDnsResourceRecordRKEY alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_TALINK:
        {
            rr = [[UMDnsResourceRecordTALINK alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_CDS:
        {
            rr = [[UMDnsResourceRecordCDS alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_CDNSKEY:
        {
            rr = [[UMDnsResourceRecordCDNSKEY alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_OPENPGPKEY:
        {
            rr = [[UMDnsResourceRecordOPENPGPKEY alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_CSYNC:
        {
            rr = [[UMDnsResourceRecordCSYNC alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_SPF:
        {
            rr = [[UMDnsResourceRecordSPF alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_UINFO:
        {
            rr = [[UMDnsResourceRecordUINFO alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_UID:
        {
            rr = [[UMDnsResourceRecordUID alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_GID:
        {
            rr = [[UMDnsResourceRecordGID alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_UNSPEC:
        {
            rr = [[UMDnsResourceRecordUNSPEC alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_NID:
        {
            rr = [[UMDnsResourceRecordNID alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_L32:
        {
            rr = [[UMDnsResourceRecordL32 alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_L64:
        {
            rr = [[UMDnsResourceRecordL64 alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_LP:
        {
            rr = [[UMDnsResourceRecordLP alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_EUI48:
        {
            rr = [[UMDnsResourceRecordEUI48 alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_EUI64:
        {
            rr = [[UMDnsResourceRecordEUI64 alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_TKEY:
        {
            rr = [[UMDnsResourceRecordTKEY alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_TSIG:
        {
            rr = [[UMDnsResourceRecordTSIG alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_IXFR:
        {
            rr = [[UMDnsResourceRecordIXFR alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_AXFR:
        {
            rr = [[UMDnsResourceRecordAXFR alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_MAILB:
        {
            rr = [[UMDnsResourceRecordMAILB alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_MAILA:
        {
            rr = [[UMDnsResourceRecordMAILA alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_URI:
        {
            rr = [[UMDnsResourceRecordURI alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_CAA:
        {
            rr = [[UMDnsResourceRecordCAA alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_TA:
        {
            rr = [[UMDnsResourceRecordTA alloc]initWithParams:params zone:zone];
            break;
        }

        case UlibDnsResourceRecordType_DLV:
        {
            rr = [[UMDnsResourceRecordDLV alloc]initWithParams:params zone:zone];
            break;
        }
        case    UlibDnsResourceRecordType_UNKNOWN:
        default:
            break;
    }
    return rr;
}

+ (UMDnsResourceRecord *)recordOfTypeString:(NSString *)rrtype
                                     params:(NSArray *)params
                                       zone:(NSString *)zone
{
    UlibDnsResourceRecordType rt = [UMDnsResourceRecord resourceRecordTypeFromString:rrtype];
    return [UMDnsResourceRecord recordOfType:rt
                                      params:params
                                        zone:zone];
}

+(UlibDnsResourceRecordType)resourceRecordTypeFromString:(NSString *)str
{
    if( [str caseInsensitiveCompare:@"A"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_A;
    }
    if( [str caseInsensitiveCompare:@"NS"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_NS;
    }
    if( [str caseInsensitiveCompare:@"MD"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_MD;
    }
    if( [str caseInsensitiveCompare:@"MF"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_MF;
    }
    if( [str caseInsensitiveCompare:@"CNAME"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_CNAME;
    }
    if( [str caseInsensitiveCompare:@"SOA"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_SOA;
    }
    if( [str caseInsensitiveCompare:@"MB"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_MB;
    }
    if( [str caseInsensitiveCompare:@"MG"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_MG;
    }
    if( [str caseInsensitiveCompare:@"MR"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_MR;
    }
    if( [str caseInsensitiveCompare:@"NULL"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_NULL;
    }
    if( [str caseInsensitiveCompare:@"WKS"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_WKS;
    }
    if( [str caseInsensitiveCompare:@"PTR"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_PTR;
    }
    if( [str caseInsensitiveCompare:@"HINFO"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_HINFO;
    }
    if( [str caseInsensitiveCompare:@"MINFO"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_MINFO;
    }
    if( [str caseInsensitiveCompare:@"MX"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_MX;
    }
    if( [str caseInsensitiveCompare:@"TXT"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_TXT;
    }
    if( [str caseInsensitiveCompare:@"RP"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_RP;
    }
    if( [str caseInsensitiveCompare:@"AFSDB"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_AFSDB;
    }
    if( [str caseInsensitiveCompare:@"X25"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_X25;
    }
    if( [str caseInsensitiveCompare:@"ISDN"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_ISDN;
    }
    if( [str caseInsensitiveCompare:@"RT"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_RT;
    }
    if( [str caseInsensitiveCompare:@"NSAP"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_NSAP;
    }
    if( [str caseInsensitiveCompare:@"NSAP_PTR"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_NSAP_PTR;
    }
    if( [str caseInsensitiveCompare:@"SIG"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_SIG;
    }
    if( [str caseInsensitiveCompare:@"KEY"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_KEY;
    }
    if( [str caseInsensitiveCompare:@"PX"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_PX;
    }
    if( [str caseInsensitiveCompare:@"GPOS"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_GPOS;
    }
    if( [str caseInsensitiveCompare:@"AAAA"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_AAAA;
    }
    if( [str caseInsensitiveCompare:@"LOC"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_LOC;
    }
    if( [str caseInsensitiveCompare:@"NXT"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_NXT;
    }
    if( [str caseInsensitiveCompare:@"EID"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_EID;
    }
    if( [str caseInsensitiveCompare:@"NIMLOC"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_NIMLOC;
    }
    if( [str caseInsensitiveCompare:@"SRV"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_SRV;
    }
    if( [str caseInsensitiveCompare:@"ATMA"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_ATMA;
    }
    if( [str caseInsensitiveCompare:@"NAPTR"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_NAPTR;
    }
    if( [str caseInsensitiveCompare:@"KX"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_KX;
    }
    if( [str caseInsensitiveCompare:@"CERT"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_CERT;
    }
    if( [str caseInsensitiveCompare:@"A6"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_A6;
    }
    if( [str caseInsensitiveCompare:@"DNAME"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_DNAME;
    }
    if( [str caseInsensitiveCompare:@"SINK"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_SINK;
    }
    if( [str caseInsensitiveCompare:@"OPT"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_OPT;
    }
    if( [str caseInsensitiveCompare:@"APL"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_APL;
    }
    if( [str caseInsensitiveCompare:@"DS"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_DS;
    }
    if( [str caseInsensitiveCompare:@"SSHFP"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_SSHFP;
    }
    if( [str caseInsensitiveCompare:@"IPSECKEY"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_IPSECKEY;
    }
    if( [str caseInsensitiveCompare:@"RRSIG"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_RRSIG;
    }
    if( [str caseInsensitiveCompare:@"NSEC"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_NSEC;
    }
    if( [str caseInsensitiveCompare:@"DNSKEY"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_DNSKEY;
    }
    if( [str caseInsensitiveCompare:@"DHCID"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_DHCID;
    }
    if( [str caseInsensitiveCompare:@"NSEC3"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_NSEC3;
    }
    if( [str caseInsensitiveCompare:@"NSEC3PARAM"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_NSEC3PARAM;
    }
    if( [str caseInsensitiveCompare:@"TLSA"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_TLSA;
    }
    if( [str caseInsensitiveCompare:@"HIP"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_HIP;
    }
    if( [str caseInsensitiveCompare:@"NINFO"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_NINFO;
    }
    if( [str caseInsensitiveCompare:@"RKEY"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_RKEY;
    }
    if( [str caseInsensitiveCompare:@"TALINK"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_TALINK;
    }
    if( [str caseInsensitiveCompare:@"CDS"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_CDS;
    }
    if( [str caseInsensitiveCompare:@"CDNSKEY"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_CDNSKEY;
    }
    if( [str caseInsensitiveCompare:@"OPENPGPKEY"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_OPENPGPKEY;
    }
    if( [str caseInsensitiveCompare:@"CSYNC"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_CSYNC;
    }
    if( [str caseInsensitiveCompare:@"SPF"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_SPF;
    }
    if( [str caseInsensitiveCompare:@"UINFO"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_UINFO;
    }
    if( [str caseInsensitiveCompare:@"UID"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_UID;
    }
    if( [str caseInsensitiveCompare:@"GID"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_GID;
    }
    if( [str caseInsensitiveCompare:@"UNSPEC"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_UNSPEC;
    }
    if( [str caseInsensitiveCompare:@"NID"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_NID;
    }
    if( [str caseInsensitiveCompare:@"L32"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_L32;
    }
    if( [str caseInsensitiveCompare:@"L64"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_L64;
    }
    if( [str caseInsensitiveCompare:@"LP"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_LP;
    }
    if( [str caseInsensitiveCompare:@"EUI48"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_EUI48;
    }
    if( [str caseInsensitiveCompare:@"EUI64"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_EUI64;
    }
    if( [str caseInsensitiveCompare:@"TKEY"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_TKEY;
    }
    if( [str caseInsensitiveCompare:@"TSIG"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_TSIG;
    }
    if( [str caseInsensitiveCompare:@"IXFR"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_IXFR;
    }
    if( [str caseInsensitiveCompare:@"AXFR"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_AXFR;
    }
    if( [str caseInsensitiveCompare:@"MAILB"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_MAILB;
    }
    if( [str caseInsensitiveCompare:@"MAILA"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_MAILA;
    }
    if( [str caseInsensitiveCompare:@"URI"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_URI;
    }
    if( [str caseInsensitiveCompare:@"CAA"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_CAA;
    }
    if( [str caseInsensitiveCompare:@"TA"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_TA;
    }
    if( [str caseInsensitiveCompare:@"DLV"]==NSOrderedSame)
    {
        return     UlibDnsResourceRecordType_DLV;
    }
    return UlibDnsResourceRecordType_UNKNOWN;
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

- (UMDnsResourceRecord *)initWithRawData:(NSData *)data atOffset:(size_t *)pos
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
