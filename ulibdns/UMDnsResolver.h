//
//  UMDnsResolver.h
//  ulibdns
//
//  Created by Andreas Fink on 07/09/15.
//  Copyright (c) 2016 Andreas Fink
//

#import <ulib/ulib.h>

@interface UMDnsResolver : UMBackgrounder
{
    UMQueue *newRequests;
    UMSynchronizedDictionary *pendingRequestsByKey;
    UMSocket *socket_u4; /* sockets used for UDP IPv4 */
    UMSocket *socket_u6; /* sockets used for UDP IPv6 */
    /* Note: TCP IPv4/IPv6 sockets are defined in the UMDnsServer object */
}

@end
