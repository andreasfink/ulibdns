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
/*    for(UMDnsCharacterString *s in txtRecords)
    {
        [binary appendData:[s binary]];
    }
 */
    return binary;
}


- (UMDnsResourceRecordNAPTR *)initWithString:(NSData *)string
{
    return [self initWithStrings:@[string]];
}

- (UMDnsResourceRecordNAPTR *)initWithStrings:(NSArray *)strings
{
    self = [super init];
    if(self)
    {
        NSMutableArray *recs = [[NSMutableArray alloc]init];
        for( NSString *s in strings)
        {
            [recs addObject:[[UMDnsCharacterString alloc]initWithString:s]];
        }
       // txtRecords = recs;
        
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
    [s appendFormat:@"NAPTR\t%d\t%d\t%d\t%@",a,b,port,host.visualNameAbsoluteWriting];
    return s;
}

@end
