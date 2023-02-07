//
//  UMDnsClient-h
//  ulibdns
//
//  Created by Andreas Fink on 20/11/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>
#import "UMDnsResolvingRequestDelegateProtocol.h"

@class UMDnsRemoteServer;
@class UMDnsResolvingRequest;

@interface UMDnsClient : UMObject<UMDnsResolvingRequestDelegateProtocol>
{
    UMSynchronizedArray *remoteServers;
    UMSynchronizedArray *pendingUserQueries;
}

- (void)addServer:(UMDnsRemoteServer *)server;
- (void)removeServer:(UMDnsRemoteServer *)server;
- (void)sendUserQuery:(UMDnsResolvingRequest *)q;

- (void) resolverCallback:(UMDnsResolvingRequest *)request;
- (void) resolverTimeout:(UMDnsResolvingRequest *)request;

- (void)processReceivedData:(NSData *)data;

+ (uint16_t)getNewRequestIdFor:(id)obj;
+ (void)returnRequestId:(uint16_t)rid;
+ (id)getObjectForRequestId:(uint16_t)rid;

@end
