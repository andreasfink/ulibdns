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
        if(argc < 4)
        {
            fprintf(stderr,"Syntax: %s <type (A, PTR etc)> <name (www.example.com)> <nameserver (9.9.9.9)>",argv[0]);
            exit(0);
        }
        NSString *recordType=@(argv[1]);
        NSString *name=@(argv[2]);
        NSString *nameserver=@(argv[3]);
#else
        NSString *recordType          = @"A";
        NSString *name          = @"www.apple.com";
        NSString *nameserver    = @"1.1.1.1";
#endif
        
    
        UMHost *host = [[UMHost alloc]initWithName:nameserver];
        [host resolve];
        NSArray *addresses = host.addresses;
        if(addresses.count == 0)
        {
            fprintf(stderr,"Unknown address for server %s",nameserver.UTF8String);
            exit(-1);
        }
        UMDnsRemoteServer *remoteServer = [[UMDnsRemoteServer alloc]initWithAddress:nameserver useUDP:YES];
        [client addServer:remoteServer];
        UMDnsResolvingRequest *request = [[UMDnsResolvingRequest alloc]init];
        
        request.resourceType    = [UMDnsResourceRecord resourceRecordTypeFromString:recordType];
        request.queryType       = UlibDnsQueryType_ANY;
        request.nameToResolve   = [[UMDnsName alloc]initWithVisualName:name];
        request.dnsClass        = UlibDnsClass_IN;
        request.serverToQuery   = remoteServer;
        request.delegate = client;
        request.useStream = NO;
        [client sendUserQuery:request];
        sleep(1000);
    }
    return 0;
}
