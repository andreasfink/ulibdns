//
//  UMDnsResolvingRequestDelegateProtocol.h
//  ulibdns
//
//  Created by Andreas Fink on 07/09/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>
@class UMDnsResolvingRequest;

@protocol UMDnsResolvingRequestDelegateProtocol <NSObject>
- (void) resolverCallback:(UMDnsResolvingRequest *)request;
@end

