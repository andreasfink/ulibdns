//
//  UMDnsHeader.h
//  ulibdns
//
//  Created by Andreas Fink on 31.08.15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>

@interface UMDnsHeader : UMObject
{
    uint16_t    _requestId;
    BOOL        _isResponse;
    uint8_t     _opCode; /* 4 bits */
    BOOL        _authoritativeAnswer;
    BOOL        _trunCation;
    BOOL        _recursionDesired;
    BOOL        _recursionAvailable;
    uint8_t     _zBits;
    uint8_t     _responseCode;
    uint16_t    _qdcount;
    uint16_t    _ancount;
    uint16_t    _nscount;
    uint16_t    _arcount;
}

@property(readwrite,assign) uint16_t    requestId;
@property(readwrite,assign) BOOL        isResponse;
@property(readwrite,assign) uint8_t     opCode; /* 4 bits */
@property(readwrite,assign) BOOL        authoritativeAnswer;
@property(readwrite,assign) BOOL        trunCation;
@property(readwrite,assign) BOOL        recursionDesired;
@property(readwrite,assign) BOOL        recursionAvailable;
@property(readwrite,assign) uint8_t     zBits;
@property(readwrite,assign) uint8_t     responseCode;
@property(readwrite,assign) uint16_t    qdcount;
@property(readwrite,assign) uint16_t    ancount;
@property(readwrite,assign) uint16_t    nscount;
@property(readwrite,assign) uint16_t    arcount;

- (NSData *)encodedData;

+ (uint16_t)uniqueRequestId;
+ (void)returnUniqueRequestId:(uint16_t)i;

@end


