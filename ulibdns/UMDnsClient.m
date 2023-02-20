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

- (id)init
{
    self = [super init];
    if(self)
    {
        _remoteServers = [[UMSynchronizedArray alloc]init];
        _pendingUserQueries = [[UMSynchronizedArray alloc]init];
    }
    return self;
}

- (void)addServer:(UMDnsRemoteServer *)server
{
    [_remoteServers addObject:server];
    server.delegate = self;
}

- (void)removeServer:(UMDnsRemoteServer *)server
{
    server.delegate = NULL;
    [_remoteServers removeObject:server];
}

- (void)start
{
    for(UMDnsRemoteServer *server in _remoteServers.arrayCopy)
    {
        [server startBackgroundTask];
    }
}

- (void)stop
{
    for(UMDnsRemoteServer *server in _remoteServers.arrayCopy)
    {
        [server shutdownBackgroundTask];
    }
}

-(void)sendUserQuery:(UMDnsResolvingRequest *)req
{
    UMDnsRemoteServer *server;
    @synchronized (self)
    {
        server = [_remoteServers removeFirst];
        [_remoteServers addObject:server];
    }
    [server startBackgroundTask];
    while(server.socket.isBound == NO)
    {
        usleep(100000);
    }
    UMDnsQuery *query = [[UMDnsQuery alloc]init];
    query.name          = req.nameToResolve;
    query.recordType    = req.resourceType;
    query.recordClass   = UlibDnsClass_IN;
    
    UMDnsMessage *msg = [[UMDnsMessage alloc]init];
    msg.header = [[UMDnsHeader alloc]init];
    msg.header.requestId = [UMDnsClient getNewRequestIdFor:msg];
    msg.header.isResponse = NO;
    msg.queries = @[query];
    msg.answers = @[];
    msg.authority = @[];
    msg.additional = @[];
    [_pendingUserQueries addObject:req];
    NSData *data = [msg encodedData];
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
    size_t offset = 0;
    while(offset < data.length)
    {
        @try
        {
            UMDnsMessage *msg = [[UMDnsMessage alloc]initWithData:data offset:&offset];
            if(msg)
            {
                NSLog(@"Response: %@",msg.visualRepresentation);
            }
            else
            {
                break;
            }
        }
        @catch(NSException *e)
        {
            NSLog(@"Exception: %@",e);
        }
    }
}


static  UMSynchronizedArray         *_unusedRequestIds = NULL;
static  UMSynchronizedDictionary    *_usedRequestIds  = NULL;

+ (uint16_t)getNewRequestIdFor:(id)obj
{
    if(_unusedRequestIds==NULL)
    {
        _unusedRequestIds   = [[UMSynchronizedArray alloc]init];
        _usedRequestIds     = [[UMSynchronizedDictionary alloc]init];
        for(uint16_t i=1;i<0xFFF0;i++)
        {
            [_unusedRequestIds addObject:@(i)];
        }
    }
    NSNumber *n = [_unusedRequestIds removeFirst];
    _usedRequestIds[n] = obj;
    return (uint16_t)n.unsignedShortValue;
}

+ (void)returnRequestId:(uint16_t)rid
{
    [_usedRequestIds removeObjectForKey:@(rid)];
    [_unusedRequestIds addObject:@(rid)];
}

+ (id)getObjectForRequestId:(uint16_t)rid
{
    return  _usedRequestIds [@(rid)];
}


@end
