//
//  UMDnsLocalServer.h
//  ulibdns
//
//  Created by Andreas Fink on 23.08.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>
#import "UMDnsResolvingRequestDelegateProtocol.h"

@interface UMDnsLocalServer : UMObject
{
    UMSocket                                    *_localSocketUdp;
    UMSocket                                    *_localSocketTcp;
    BOOL                                        _mustQuit;
    id<UMDnsResolvingRequestDelegateProtocol>   _resolvingDelegate;
}

@property(readwrite,strong,atomic)  id<UMDnsResolvingRequestDelegateProtocol>   resolvingDelegate;

- (UMDnsLocalServer *) initWithPort:(int)port;
- (void) start;
- (void) stop;
@end
