//
//  UMDnsResolver.h
//  ulibdns
//
//  Created by Andreas Fink on 07/09/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>

@interface UMDnsResolver : UMBackgrounder
{
    UMQueueSingle *newRequests;
    UMSynchronizedDictionary *pendingRequestsByKey;
    UMSocket *socket_u4; /* sockets used for UDP IPv4 */
    UMSocket *socket_u6; /* sockets used for UDP IPv6 */
    /* Note: TCP IPv4/IPv6 sockets are defined in the UMDnsServer object */
}

@end
