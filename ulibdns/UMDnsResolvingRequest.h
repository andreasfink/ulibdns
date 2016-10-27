//
//  UMDnsResolvingRequest.h
//  ulibdns
//
//  Created by Andreas Fink on 07/09/15.
//  Copyright (c) 2016 Andreas Fink
//

#import <ulib/ulib.h>
#import "ulibdns_types.h"
#import "UMDnsResolvingRequestDelegateProtocol.h"

@class UMDnsRemoteServer;
@class UMDnsName;

@interface UMDnsResolvingRequest : UMObject
{
    NSString                    *key;
    UlibDnsResourceRecordType   resourceType;
    UlibDnsQueryType            queryType;
    UMDnsName                   *nameToResolve;
    UMDnsRemoteServer           *serverToQuery;
    id<UMDnsResolvingRequestDelegateProtocol> delegate;   /* callback delegate */
    UMMicroSec                  requestCreated;
    UMMicroSec                  requestSent;
    UMMicroSec                  requestAnswered;
    UMMicroSec                  requestTimeoutDelay;
    UMMicroSec                  requestTimeoutTime;
    BOOL                        useStream;
}

- (NSString *)key;

@property (readwrite,assign)    UlibDnsResourceRecordType   resourceType;
@property (readwrite,assign)    UlibDnsQueryType            queryType;
@property (readwrite,strong)    UMDnsName                   *nameToResolve;
@property (readwrite,strong)    UMDnsRemoteServer           *serverToQuery;
@property (readwrite,strong)    id<UMDnsResolvingRequestDelegateProtocol> delegate;   /* callback delegate */
@property (readwrite,assign)    UMMicroSec                  requestCreated;
@property (readwrite,assign)    UMMicroSec                  requestSent;
@property (readwrite,assign)    UMMicroSec                  requestAnswered;
@property (readwrite,assign)    UMMicroSec                  requestTimeoutDelay;
@property (readwrite,assign)    UMMicroSec                  requestTimeoutTime;
@property (readwrite,assign)    BOOL                        useStream;

@end
