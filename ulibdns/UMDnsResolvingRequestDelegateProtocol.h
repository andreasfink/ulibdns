//
//  UMDnsResolvingRequestDelegateProtocol.h
//  ulibdns
//
//  Created by Andreas Fink on 07/09/15.
//  Copyright (c) 2016 Andreas Fink
//

#import <ulib/ulib.h>
@class UMResolvingRequest;

@protocol UMDnsResolvingRequestDelegateProtocol <NSObject>
- (void) resolverCallback:(UMResolvingRequest *)request;
@end

