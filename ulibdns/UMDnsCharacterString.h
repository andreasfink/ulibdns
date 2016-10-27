//
//  UMDnsCharacterString.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright (c) 2016 Andreas Fink
//

#import "UMDnsResourceRecord.h"

@interface UMDnsCharacterString : UMObject
{
    char chars[256]; /* byte 0 is length */
}


- (NSData *)binary;
- (void) setCharacterString:(NSString *)s;
- (UMDnsCharacterString *)initWithString:(NSString *)s;
- (NSString *)visualRepresentation;

@end
