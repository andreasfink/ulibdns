//
//  UMDnsResolvingRequest.h
//  ulibdns
//
//  Created by Andreas Fink on 07/09/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>
#import "ulibdns_types.h"
#import "UMDnsResolvingRequestDelegateProtocol.h"
#import "UMDnsResourceRecord.h"

@class UMDnsRemoteServer;
@class UMDnsName;
@class UMDnsResourceRecord;

@interface UMDnsResolvingRequest : UMObject
{
    NSString                                    *_key;
    UlibDnsResourceRecordType                   _resourceType;
    UlibDnsQueryType                            _queryType;
    UMDnsName                                   *_nameToResolve;
    UMDnsRemoteServer                           *_serverToQuery;
    id<UMDnsResolvingRequestDelegateProtocol>   _delegate;   /* callback delegate */
    UMMicroSec                                  _requestCreated;
    UMMicroSec                                  _requestSent;
    UMMicroSec                                  _requestAnswered;
    UMMicroSec                                  _requestTimeoutDelay;
    UMMicroSec                                  _requestTimeoutTime;
    BOOL                                        _useStream;
    NSArray<UMDnsResourceRecord *>              *_responses;
    int                                         _errorCode;
}

- (NSString *)key;

@property (readwrite,assign,atomic)    UlibDnsResourceRecordType                    resourceType;
@property (readwrite,assign,atomic)    UlibDnsQueryType                             queryType;
@property (readwrite,strong,atomic)    UMDnsName                                    *nameToResolve;
@property (readwrite,strong,atomic)    UMDnsRemoteServer                            *serverToQuery;
@property (readwrite,strong,atomic)    id<UMDnsResolvingRequestDelegateProtocol>    delegate;   /* callback delegate */
@property (readwrite,assign,atomic)    UMMicroSec                                   requestCreated;
@property (readwrite,assign,atomic)    UMMicroSec                                   requestSent;
@property (readwrite,assign,atomic)    UMMicroSec                                   requestAnswered;
@property (readwrite,assign,atomic)    UMMicroSec                                   requestTimeoutDelay;
@property (readwrite,assign,atomic)    UMMicroSec                                   requestTimeoutTime;
@property (readwrite,assign,atomic)    BOOL                                         useStream;
@property (readwrite,strong,atomic)    NSArray<UMDnsResourceRecord *>               *responses;
@property (readwrite,assign,atomic)    int                                          errorCode;

@end
