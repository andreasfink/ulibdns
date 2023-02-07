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

@property(readwrite,atomic,assign)  uint16_t    requestId;
@property(readwrite,atomic,assign)  BOOL        isResponse;
@property(readwrite,atomic,assign)  uint8_t     opCode; /* 4 bits */
@property(readwrite,atomic,assign)  BOOL        authoritativeAnswer;
@property(readwrite,atomic,assign)  BOOL        trunCation;
@property(readwrite,atomic,assign)  BOOL        recursionDesired;
@property(readwrite,atomic,assign)  BOOL        recursionAvailable;
@property(readwrite,atomic,assign)  uint8_t     zBits;
@property(readwrite,atomic,assign)  uint8_t     responseCode;
@property(readwrite,atomic,assign)  uint16_t    qdcount;
@property(readwrite,atomic,assign)  uint16_t    ancount;
@property(readwrite,atomic,assign)  uint16_t    nscount;
@property(readwrite,atomic,assign)  uint16_t    arcount;

- (NSData *)binary;
@end

