//
//  UMDnsHeader.h
//  ulibdns
//
//  Created by Andreas Fink on 31.08.15.
//  Copyright (c) 2016 Andreas Fink
//

#import <ulib/ulib.h>

@interface UMDnsHeader : UMObject
{
    uint16_t    requestId;
    BOOL        isResponse;
    uint8_t     opCode; /* 4 bits */
    BOOL        authoritativeAnswer;
    BOOL        trunCation;
    BOOL        recursionDesired;
    BOOL        recursionAvailable;
    uint8_t     zBits;
    uint8_t     responseCode;
    uint16_t    qdcount;
    uint16_t    ancount;
    uint16_t    nscount;
    uint16_t    arcount;
}

- (NSData *)binary;
@end

