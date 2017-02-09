//
//  UMDnsLocalServer.h
//  ulibdns
//
//  Created by Andreas Fink on 23.08.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>

@interface UMDnsLocalServer : UMObject
{
    UMSocket *localSocketUdp;
    UMSocket *localSocketTcp;
    BOOL     mustQuit;
}

-  (UMDnsLocalServer *)initWithPort:(int)port;

- (void)start;
- (void)stop;
@end
