//
//  UMDnsServer.h
//  ulibdns
//
//  Created by Andreas Fink on 07/09/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>

@interface UMDnsRemoteServer : UMBackgrounder
{
    BOOL        _isActive;
    BOOL        _isTcp;
    BOOL        _isIPv6;
    BOOL        _isUDP;
    NSString    *_address;
    int         _port;
    UMSocket    *_socket;
    int         _waitTimeoutInMs;
    id          _delegate;
}

@property (readwrite,strong)     NSString *address;
@property (readwrite,strong)     UMSocket *socket;

@property (readwrite,assign)    BOOL        isActive;
@property (readwrite,assign)    BOOL        isTcp;
@property (readwrite,assign)    BOOL        isIPv6;
@property (readwrite,assign)    BOOL        isUDP;
@property (readwrite,assign)    int         port;
@property (readwrite,assign)    int         waitTimeoutInMs;
@property (readwrite,strong)    id          delegate;

- (void)sendRequest:(NSData *)data;
- (void)sendDatagramRequest:(NSData *)data;
- (void)sendStreamRequest:(NSData *)data;

@end
