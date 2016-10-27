//
//  UMDnsClient-h
//  ulibdns
//
//  Created by Andreas Fink on 20/11/15.
//  Copyright (c) 2016 Andreas Fink
//

#import <ulib/ulib.h>
@class UMDnsRemoteServer;
@class UMDnsResolvingRequest;

@interface UMDnsClient : UMObject
{
    NSMutableArray *remoteServers;
    NSMutableArray *pendingUserQueries;
}

- (void)addServer:(UMDnsRemoteServer *)server;
- (void)removeServer:(UMDnsRemoteServer *)server;

- (void)addUserQuery:(UMDnsResolvingRequest *)q;

@end
