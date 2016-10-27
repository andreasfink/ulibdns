//
//  UMDnsLabel.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright (c) 2016 Andreas Fink
//

#import <ulib/ulib.h>

@interface UMDnsLabel : UMObject
{
    NSString *_label;
}

- (NSString *)label;
- (void)setLabel:(NSString *)label;
- (void)setLabel:(NSString *)label enforceLengthLimit:(BOOL) enforceLimits;

- (NSData *)binary;
- (void)setBinary:(NSData *)binary;
- (void)setBinary:(NSData *)binary enforceLengthLimit:(BOOL) enforceLimits; /* returns number of used bytes */


@end
