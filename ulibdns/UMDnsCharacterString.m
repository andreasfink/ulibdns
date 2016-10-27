//
//  UMDnsCharacterString.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright (c) 2016 Andreas Fink
//

#import "UMDnsCharacterString.h"

@implementation UMDnsCharacterString

- (NSData *)binary
{
    NSUInteger len = chars[0] + 1;
    return [NSData dataWithBytes:chars length:len];
}

- (void) setCharacterString:(NSString *)s
{
    NSData *d =[s dataUsingEncoding:NSASCIIStringEncoding];
    
    NSUInteger len = [d length];
    if(len > 255)
    {
        @throw ([NSException exceptionWithName:@"invalidCharacterString" reason:@"character string longer than 255 bytes" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
    strncpy(&chars[1],[d bytes],len);
    chars[0]=len;
}

- (UMDnsCharacterString *)initWithString:(NSString *)s
{
    self = [super init];
    if(self)
    {
        [self setCharacterString:s];
    }
    return self;
}

- (NSString *)visualRepresentation
{
    NSString *s = [[NSString alloc ] initWithBytes:&chars[1] length:(int)chars[0] encoding:NSASCIIStringEncoding];
    return s;
}


@end
