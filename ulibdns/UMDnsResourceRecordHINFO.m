
//
//  UMDnsResourceRecordHINFO.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecordHINFO.h"

@implementation UMDnsResourceRecordHINFO


/*
 
 3.3.2. HINFO RDATA format
 
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 /                      CPU                      /
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 /                       OS                      /
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 
 where:
 
 CPU             A <character-string> which specifies the CPU type.
 
 OS              A <character-string> which specifies the operating
 system type.
 
 Standard values for CPU and OS can be found in [RFC-1010].
 
 HINFO records are used to acquire general information about a host.  The
 main use is for protocols such as FTP that can use special procedures
 when talking between machines or operating systems of the same type.
 
 */

- (NSString *)recordTypeString
{
    return @"HINFO";
}


- (UlibDnsResourceRecordType)recordType
{
    return UlibDnsResourceRecordType_HINFO;
}

- (NSData *)resourceData
{
    NSMutableData *binary = [[NSMutableData alloc]init];
    [binary appendData:[_cpu binary]];
    [binary appendData:[_os binary]];
    return binary;
}


- (UMDnsResourceRecordHINFO *)initCpu:(NSString *)xcpu operatingSystem:(NSString *)xos
{
    self = [super init];
    if(self)
    {
        _cpu = [[UMDnsCharacterString alloc]initWithString:xcpu];
        _os = [[UMDnsCharacterString alloc]initWithString:xos];
    }
    return self;
}


- (UMDnsResourceRecordHINFO *)initWithParams:(NSArray *)params zone:(NSString *)zone
{
    NSString *cpu1 = params[0];
    NSString *os1 = params[1];
    return [self initCpu:cpu1 operatingSystem:os1];
}



- (NSString *)visualRepresentation
{
    return [NSString stringWithFormat:@"HINFO\t%@\t%@",_cpu.visualRepresentation,_os.visualRepresentation];
}

@end
