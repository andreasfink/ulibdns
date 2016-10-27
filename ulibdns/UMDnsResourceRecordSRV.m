//
//  UMDnsResourceRecordSRV.m
//  ulibdns
//
//  Created by Andreas Fink on 08/09/15.
//  Copyright (c) 2016 Andreas Fink
//

#import "UMDnsResourceRecordSRV.h"
#import "UMDnsCharacterString.h"

@implementation UMDnsResourceRecordSRV

- (NSString *)recordTypeString
{
    return @"SRV";
}


- (UlibDnsResourceRecordType)recordType
{
    return UlibDnsResourceRecordType_SRV;
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


- (UMDnsResourceRecordSRV *)initWithString:(NSData *)string
{
    return [self initWithStrings:@[string]];
}

- (UMDnsResourceRecordSRV *)initWithStrings:(NSArray *)strings
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

- (UMDnsResourceRecordSRV *)initWithParams:(NSArray *)params zone:(NSString *)zone
{
    return [self initWithStrings:params];
}

- (NSString *)visualRepresentation
{
    NSMutableString *s =  [[NSMutableString alloc]init];
    [s appendFormat:@"SRV\t%d\t%d\t%d\t%@",a,b,port,host.visualNameAbsoluteWriting];
    return s;
}

@end
