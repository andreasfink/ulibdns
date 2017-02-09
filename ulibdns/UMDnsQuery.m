//
//  UMDnsQuery.m
//  ulibdns
//
//  Created by Andreas Fink on 31.08.15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsQuery.h"

@implementation UMDnsQuery

@synthesize recordType;
@synthesize recordClass;
@synthesize name;


- (NSData *)binary
{
    NSMutableData *binary = [[NSMutableData alloc]init];
    
    [binary appendData:[name binary]];
    
    unsigned char typeBytes[2];
    typeBytes[0] = (recordType & 0xFF00)>> 8;
    typeBytes[1] = (recordType & 0x00FF);
    [binary appendBytes:typeBytes length:2];
    
    unsigned char classBytes[2];
    classBytes[0] = (recordClass & 0xFF00)>> 8;
    classBytes[1] = (recordClass & 0x00FF);
    [binary appendBytes:classBytes length:2];
    
    return binary;
}
@end
