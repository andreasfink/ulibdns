//
//  UMDnsResourceRecordTXT.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsResourceRecordTXT.h"
#import "UMDnsCharacterString.h"

/*
 
 3.3.14. TXT RDATA format
 
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 /                   TXT-DATA                    /
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 
 where:
 
 TXT-DATA        One or more <character-string>s.
 
 TXT RRs are used to hold descriptive text.  The semantics of the text
 depends on the domain where it is found.

*/
 
@implementation UMDnsResourceRecordTXT

- (NSString *)recordTypeString
{
    return @"TXT";
}


- (UlibDnsResourceRecordType)recordType
{
    return UlibDnsResourceRecordType_TXT;
}

- (NSData *)resourceData
{
    NSMutableData *binary = [[NSMutableData alloc]init];
    for(UMDnsCharacterString *s in txtRecords)
    {
        [binary appendData:[s binary]];
    }
    return binary;
}


- (UMDnsResourceRecordTXT *)initWithString:(NSData *)string
{
    return [self initWithStrings:@[string]];
}

- (UMDnsResourceRecordTXT *)initWithStrings:(NSArray *)strings
{
    self = [super init];
    if(self)
    {
        NSMutableArray *recs = [[NSMutableArray alloc]init];
        for( NSString *s in strings)
        {
            [recs addObject:[[UMDnsCharacterString alloc]initWithString:s]];
        }
        txtRecords = recs;
        
    }
    return self;
}

- (UMDnsResourceRecordTXT *)initWithParams:(NSArray *)params zone:(NSString *)zone
{
    return [self initWithStrings:params];
}

- (NSString *)visualRepresentation
{
    NSMutableString *s =  [[NSMutableString alloc]init];
    [s appendString:@"TXT"];
    for(UMDnsCharacterString *cs in txtRecords)
    {
        [s appendString:@"\t"];
        [s appendString:[cs visualRepresentation]];
    }
    return s;
}

@end
