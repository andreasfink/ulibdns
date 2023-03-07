//
//  UMDnsMessage.h
//  ulibdns
//
//  Created by Andreas Fink on 31.08.15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>
#import "UMDnsResourceRecord.h"
#import "UMDnsQuery.h"
#import "UMDnsHeader.h"

@interface UMDnsMessage : UMObject
{
    UMDnsHeader                     *_header;
    NSArray<UMDnsQuery*>            *_queries; /* array of UMDnsQuery objects */
    NSArray<UMDnsResourceRecord *>  *_answers; /* array of UMDnsResourceRecord objects */
    NSArray<UMDnsResourceRecord *>  *_authority;
    NSArray<UMDnsResourceRecord *>  *_additional;
}

@property(readwrite,strong,atomic)  UMDnsHeader                     *header;
@property(readwrite,strong,atomic)  NSArray<UMDnsQuery*>            *queries;
@property(readwrite,strong,atomic)  NSArray<UMDnsResourceRecord *>  *answers;
@property(readwrite,strong,atomic)  NSArray<UMDnsResourceRecord *>  *authority;
@property(readwrite,strong,atomic)  NSArray<UMDnsResourceRecord *>  *additional;

- (UMDnsMessage *)initWithData:(NSData *)binary offset:(size_t *)offset; /* can throw NSException */
- (NSString *)visualRepresentation;
- (NSData *)encodedData;
@end
