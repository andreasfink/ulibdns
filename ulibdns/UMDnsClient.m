//
//  UMDnsClient
//  ulibdns
//
//  Created by Andreas Fink on 20/11/15.
//  Copyright (c) 2016 Andreas Fink
//

#import "UMDnsClient.h"
#import "UMDnsRemoteServer.h"

@implementation UMDnsClient

- (void)addServer:(UMDnsRemoteServer *)server
{
    @synchronized(remoteServers)
    {
        [remoteServers addObject:server];
    }
}

- (void)removeServer:(UMDnsRemoteServer *)server
{
    @synchronized(remoteServers)
    {
        [remoteServers removeObject:server];
    }
    
}

-(void)addUserQuery:(UMDnsResolvingRequest *)q
{
    @synchronized(pendingUserQueries)
    {
        [pendingUserQueries addObject:q];
    }
}

- (void) resolve:(UMDnsResolvingRequest *)q
{
    
}
@end
