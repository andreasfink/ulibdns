//
//  UMDnsLabel.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright (c) 2016 Andreas Fink
//

#import "UMDnsLabel.h"
#import "ulibdns_types.h"

@implementation UMDnsLabel

- (NSString *)label
{
    return _label;
}

- (void)setLabel:(NSString *)label
{
    return [self setLabel:label enforceLengthLimit:YES];
}

- (void)setLabel:(NSString *)label enforceLengthLimit:(BOOL) enforceLimits
{
    NSUInteger n = [label length];
    if(( n > ULIBDNS_MAX_LABEL_LENGTH) && (enforceLimits))
    {
        @throw ([NSException exceptionWithName:@"invalidLabelLength" reason:@"label is longer than ULIBDNS_MAX_LABEL_LENGTH" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
    
    NSUInteger i;
    for(i=0;i<n;i++)
    {
        unichar c = [label characterAtIndex:i];
        if(c > 0xFF)
        {
            @throw ([NSException exceptionWithName:@"invalidLabel0" reason:@"invalid character in label" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
        }
        if((c >= 'a') && (c <='z'))
        {
            continue;
        }
        if((c >= 'A') && (c <='Z'))
        {
            continue;
        }
        if((c >= '0') && (c <='9'))
        {
            continue;
        }
        if(c == '_') /* needed for SRV records */
        {
            continue;
        }
        if(c == '-')
        {
            break;
        }
        @throw ([NSException exceptionWithName:@"invalidLabel1" reason:@"invalid character in label" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
    _label = label;
}

- (NSData *)binary
{
    NSMutableData *binary = [[NSMutableData alloc]init];
    [binary appendBytes:"\0" length:1];
    NSUInteger n = [_label length];
    if(n > ULIBDNS_MAX_LABEL_LENGTH)
    {
        @throw ([NSException exceptionWithName:@"invalidLabel2" reason:@"label is longer than ULIBDNS_MAX_LABEL_LENGTH" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }

    NSUInteger i;
    char c;
    for(i=0;i<n;i++)
    {
        unichar uc = [_label characterAtIndex:i];
        if(uc > 0xFF)
        {
            @throw ([NSException exceptionWithName:@"invalidLabel3" reason:@"invalid chacrater in label" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
        }
        c = uc & 0xFF;
    
        if((c >= 'a') && (c <='z'))
        {
            [binary appendBytes:&c length:1];
        }
        if((c >= 'A') && (c <='Z'))
        {
            c = tolower(c);
            [binary appendBytes:&c length:1];
        }
        if((c >= '0') && (c <='9'))
        {
            [binary appendBytes:&c length:1];
        }
        if(c == '-')
        {
            [binary appendBytes:&c length:1];
        }
    }
    c = i;
    [binary replaceBytesInRange:NSMakeRange(0,1) withBytes:&c length:1];
    return binary;
}


- (void)setBinary:(NSData *)binary
{
    [self setBinary:binary enforceLengthLimit:YES];
}

- (void)setBinary:(NSData *)binary enforceLengthLimit:(BOOL) enforceLimits;
{
    const char *bytes = [binary bytes];
    NSUInteger len = [binary length];
    if((len > ULIBDNS_MAX_LABEL_LENGTH) && (enforceLimits))
    {
        @throw ([NSException exceptionWithName:@"invalidLabel" reason:@"label is longer than ULIBDNS_MAX_LABEL_LENGTH" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
    if(len > 256)
    {
        /* we can't put a length > 255  into one byte so this is a hard limit. including the length byte this is 256 */
        @throw ([NSException exceptionWithName:@"invalidLabel" reason:@"label is longer than 256 bytes." userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
    if(len < 2)
    {
        @throw ([NSException exceptionWithName:@"invalidLabel" reason:@"label is zero length" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
    char c = bytes[0];
    if(len != c+1)
    {
        @throw ([NSException exceptionWithName:@"invalidLabel" reason:@"label length doesnt match" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
    NSString *s = [[NSString alloc] initWithBytes:&bytes[1] length:(len-1) encoding:NSASCIIStringEncoding];
    if(s==NULL)
    {
        @throw ([NSException exceptionWithName:@"invalidLabel" reason:@"label is not ASCII" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
    [self setLabel:s enforceLengthLimit:enforceLimits];
    
}

@end
