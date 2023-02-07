//
//  UMDnsResourceRecordNAPTR.m
//  ulibdns
//
//  Created by Andreas Fink on 01.11.21.
//  Copyright © 2021 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecordNAPTR.h"
#import "UMDnsCharacterString.h"

@implementation UMDnsResourceRecordNAPTR


- (NSString *)recordTypeString
{
    return @"NAPTR";
}


- (UlibDnsResourceRecordType)recordType
{
    return UlibDnsResourceRecordType_NAPTR;
}

- (NSData *)resourceData
{
    NSMutableData *binary = [[NSMutableData alloc]init];
    uint8_t bytes[6];
    bytes[0] = (_order >> 8) & 0xFF;
    bytes[1] = (_order >> 0) & 0xFF;
    bytes[2] = (_preference >> 8) & 0xFF;
    bytes[3] = (_preference >> 0) & 0xFF;
    [binary appendBytes:&bytes length:4];
    [binary appendData:[_flags binary]];
    [binary appendData:[_service binary]];
    [binary appendData:[_regexp binary]];
    [binary appendData:[_replacement binary]];
    return binary;
}


- (UMDnsResourceRecordNAPTR *)initWithString:(NSString *)line
{
    NSArray *items = [line componentsSeparatedByCharactersInSet:[UMObject whitespaceAndNewlineCharacterSet]];
    if(items.count != 6)
    {
        return NULL;
    }
    return [self initWithStrings:items];
}

- (UMDnsResourceRecordNAPTR *)initWithStrings:(NSArray *)items
{
    if(items.count != 6)
    {
        return NULL;
    }

    self = [super init];
    if(self)
    {
        NSString *s1 = items[0];
        NSString *s2 = items[1];
        NSString *s3 = items[2];
        NSString *s4 = items[3];
        NSString *s5 = items[4];
        NSString *s6 = items[5];
        _order = atoi(s1.UTF8String);
        _preference = atoi(s2.UTF8String);
        _flags = [[UMDnsCharacterString alloc]initWithString:s3];
        _service = [[UMDnsCharacterString alloc]initWithString:s4];
        _regexp = [[UMDnsCharacterString alloc]initWithString:s5];
        _replacement = [[UMDnsName alloc]initWithVisualName:s6];
        
    }
    return self;
}

- (UMDnsResourceRecordNAPTR *)initWithParams:(NSArray *)params zone:(NSString *)zone
{
    return [self initWithStrings:params];
}

- (NSString *)visualRepresentation
{
    NSMutableString *s =  [[NSMutableString alloc]init];
    [s appendFormat:@"NAPTR\t%u\t%u\t%@\t%@\t%@\t%@",
        _order,
        _preference,
        _flags.visualRepresentation,
        _service.visualRepresentation,
        _regexp.visualRepresentation,
        _replacement.visualNameAbsoluteWriting];
    return s;
}

@end
