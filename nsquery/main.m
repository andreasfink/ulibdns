//
//  main.m
//  nsquery
//
//  Created by Andreas Fink on 27.11.15.
//  Copyright (c) 2016 Andreas Fink
//

#import <Foundation/Foundation.h>
#import <ulibdns/ulibdns.h>

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        UMDnsClient *client = [[UMDnsClient alloc]init];
        if(argc < 5)
        {
            fprintf(stderr,"Syntax: %s <class> <type> <name> <nameserver>",argv[0]);
            exit(0);
        }
        NSString *class=@(argv[1]);
        NSString *type=@(argv[2]);
        NSString *name=@(argv[3]);
        NSString *server=@(argv[4]);
        
    }
    return 0;
}
