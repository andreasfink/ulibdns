//
//  UMDnsServer.h
//  ulibdns
//
//  Created by Andreas Fink on 07/09/15.
//  Copyright (c) 2016 Andreas Fink
//

#import <ulib/ulib.h>

@interface UMDnsRemoteServer : UMObject
{
    BOOL        isActive;
    BOOL        isTcp;
    BOOL        isIPv6;
    NSString    *address;
    int         port;
    UMSocket    *socket;
}

@property (readwrite,strong)     NSString *address;
@property (readwrite,strong)     UMSocket *socket;

@property (readwrite,assign)    BOOL        isActive;
@property (readwrite,assign)    BOOL        isTcp;
@property (readwrite,assign)    BOOL        isIPv6;

- (void)sendDatagrammRequest:(NSData *)data stream:(UMSocket *)sock;
- (void)sendStreamRequest:(NSData *)data;

@end
