//
//  UMDnsClient
//  ulibdns
//
//  Created by Andreas Fink on 20/11/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsClient.h"
#import "UMDnsRemoteServer.h"
#import "UMDnsResolvingRequest.h"

@implementation UMDnsClient

- (void)addServer:(UMDnsRemoteServer *)server
{
    [remoteServers addObject:server];
}

- (void)removeServer:(UMDnsRemoteServer *)server
{
    [remoteServers removeObject:server];
}

- (void)start
{
    for(UMDnsRemoteServer *server in remoteServers.arrayCopy)
    {
        [server startBackgroundTask];
    }
}

- (void)stop
{
    for(UMDnsRemoteServer *server in remoteServers.arrayCopy)
    {
        [server shutdownBackgroundTask];
    }
}

-(void)sendUserQuery:(UMDnsResolvingRequest *)req
{
    UMDnsRemoteServer *server;
    @synchronized (self)
    {
        UMDnsRemoteServer *server = [remoteServers removeFirst];
        [remoteServers addObject:server];
    }
    [pendingUserQueries addObject:req];
    NSData *data = req.requestData;
    [server sendDatagramRequest:data];
}

- (void) resolverCallback:(UMDnsResolvingRequest *)request
{
    NSMutableString *s = [[NSMutableString alloc]init];
    for(UMDnsResourceRecord *rec in request.responses)
    {
        [s appendFormat:@"%@\n",rec.visualRepresentation];
    }
    fprintf(stdout,"Responses:\n%s\n",s.UTF8String);
}

- (void) resolverTimeout:(UMDnsResolvingRequest *)request
{
    fprintf(stdout,"Timeout\n");
}

- (void)processReceivedData:(NSData *)data
{
    int offset = 0;
    UMDnsResourceRecord *rec = [[UMDnsResourceRecord alloc]initWithRawData:data atOffset:&offset];
    NSLog(@"Response: %@",rec.visualRepresentation);
}
@end
