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
#import "UMDnsMessage.h"

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

    UMDnsQuery *query = [[UMDnsQuery alloc]init];
    query.name          = req.nameToResolve;
    query.recordType    = req.resourceType;
    query.recordClass   = UlibDnsClass_IN;
    
    UMDnsMessage *msg = [[UMDnsMessage alloc]init];
    msg.header = [[UMDnsHeader alloc]init];
    msg.header.requestId = [UMDnsHeader uniqueRequestId];
    msg.queries = @[query];
    msg.answers = @[];
    msg.authority = @[];
    msg.additional = @[];
    NSData *data = [msg encodedData];
    [pendingUserQueries addObject:req];
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
