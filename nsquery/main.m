//
//  main.m
//  nsquery
//
//  Created by Andreas Fink on 27.11.15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ulibdns/ulibdns.h>

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        UMDnsClient *client = [[UMDnsClient alloc]init];
#if 0
        if(argc < 5)
        {
            fprintf(stderr,"Syntax: %s <class> <type> <name> <nameserver>",argv[0]);
            exit(0);
        }
        NSString *class=@(argv[1]);
        NSString *type=@(argv[2]);
        NSString *name=@(argv[3]);
        NSString *nameserver=@(argv[4]);
#else
        NSString *name=@"www.apple.com";
        NSString *nameserver=@"1.1.1.1";
#endif
        
        UMDnsRemoteServer *remoteServer = [[UMDnsRemoteServer alloc]initWithName:nameserver workSleeper:NULL];
        UMHost *host = [[UMHost alloc]initWithName:nameserver];
        [host resolve];
        NSArray *addresses = host.addresses;
        if(addresses.count == 0)
        {
            fprintf(stderr,"Unknown address for server %s",nameserver.UTF8String);
            exit(-1);
        }
        remoteServer.address = addresses[0];
        remoteServer.port = 53;
        remoteServer.isUDP = YES;
        [client addServer:remoteServer];
        UMDnsResolvingRequest *request = [[UMDnsResolvingRequest alloc]init];
        request.resourceType    = UlibDnsResourceRecordType_NAPTR;
        request.queryType       = UlibDnsQueryType_ANY;
        request.nameToResolve   = [[UMDnsName alloc]initWithVisualName:name];
        request.dnsClass        = UlibDnsClass_IN;
        request.serverToQuery   = remoteServer;
        request.delegate = client;
        request.useStream = NO;
        [client sendUserQuery:request];
    }
    return 0;
}
