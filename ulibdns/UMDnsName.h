//
//  UMDnsName.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>

@interface UMDnsName : UMObject
{
    NSArray *_labels;
}

- (UMDnsName *)initWithData:(NSData *)binary offset:(size_t *)offset; /* can throw NSException */

- (NSString *)visualName; /* returns "host.example.com" */
- (NSString *)visualNameAbsoluteWriting; /* returns "host.example.com." */
- (NSString *)visualNameRelativeTo:(NSString *)postfix; /* returns   "host" if prefix is "example.com" */

- (NSArray<NSString *>*)visualComponents; /* returns array "host", "example", "com" */
- (NSArray<NSString *>*)visualComponentsRelativeTo:(NSString *)postfix; /* returns   "host" if prefix is "example.com" */

- (void) setVisualName:(NSString *)vname;
- (void) setVisualName:(NSString *)vname enforceLengthLimits:(BOOL)enforceLengthLimits;


- (NSData *)binary;
- (NSUInteger)setBinary:(NSData *)binary;
- (NSUInteger)setBinary:(NSData *)binary enforceLengthLimits:(BOOL)enforceLengthLimits;

- (UMDnsName *)initWithVisualName:(NSString *)name;
- (UMDnsName *)initWithRawData:(NSData *)data atOffset:(int *)pos;
- (UMDnsName *)initWithVisualName:(NSString *)name relativeToZone:(NSString *)zone;

@end
