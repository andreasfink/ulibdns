//
//  UMDnsName.m
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMDnsName.h"
#import "UMDnsLabel.h"
#import "ulibdns_types.h"

@implementation UMDnsName

- (NSString *)visualName
{
    NSUInteger n = [_labels count];
    if(n==0)
    {
        return @"";
    }
    NSUInteger i;
    UMDnsLabel *label = [_labels objectAtIndex:0];
    NSMutableString *visual = [[NSMutableString alloc]initWithString:[label label]];

    for(i=1;i<n;i++)
    {
        UMDnsLabel *label = [_labels objectAtIndex:i];
        [visual appendFormat:@".%@",[label label]];
    }
    return visual;
}

- (NSString *)visualNameAbsoluteWriting
{
    return [NSString stringWithFormat:@"%@.",self.visualName];
}


- (NSString *)visualNameRelativeTo:(NSString *)postfix
{
    if([postfix hasSuffix:@"."])
    {
        /* no last dot please */
        postfix = [postfix substringToIndex:(postfix.length -1)];
    }

    NSString *s = [self visualName];
    if([s hasCaseInsensitiveSuffix:postfix])
    {
        if(s.length > postfix.length)
        {
            return [s substringToIndex:(s.length -postfix.length-1)];
            /* we also remove the dot*/
        }
        else
        {
            return  @"";
        }
    }
    else
    {
        return s;
    }
}

- (void) setVisualName:(NSString *)vname
{
    [self setVisualName:vname enforceLengthLimits:YES];
}

- (void) setVisualName:(NSString *)vname enforceLengthLimits:(BOOL)enforceLengthLimits
{
    if(([vname length]>ULIBDNS_MAX_NAMES_LENGTH) && (enforceLengthLimits))
    {
        @throw ([NSException exceptionWithName:@"name_too_long" reason:@"name is longer than  ULIBDNS_MAX_NAMES_LENGTH" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
    
    NSArray *components = [vname componentsSeparatedByString:@"."];
    NSUInteger n = [components count];
    
    NSMutableArray *labels = [[NSMutableArray alloc]init];
    NSUInteger i;
    for(i=0;i<n;i++)
    {
        NSString *s = [components objectAtIndex:i];
        if(s.length > 0)
        {
            UMDnsLabel *label = [[UMDnsLabel alloc]init];
            [label setLabel:s enforceLengthLimit:enforceLengthLimits];
            [labels addObject:label];
        }
    }
    _labels = labels;
}

- (NSData *)binary
{
    NSMutableData *data = [[NSMutableData alloc]init];
    NSUInteger n = [_labels count];
    NSUInteger i;
    for(i=0;i<n;i++)
    {
        UMDnsLabel *label = [_labels objectAtIndex:i];
        NSData *d = [label binary];
        [data appendData:d];
    }
    [data appendBytes:"\0" length:1];
    return data;
}

- (NSUInteger)setBinary:(NSData *)binary
{
    return [self setBinary:binary enforceLengthLimits:YES];
}

- (NSUInteger)setBinary:(NSData *)binary enforceLengthLimits:(BOOL)enforceLengthLimits
{
    NSMutableArray *labels = [[NSMutableArray alloc]init];
    
    const unsigned char *bytes = [binary bytes];
    NSUInteger len = [binary length];
    if(len==0)
    {
        @throw ([NSException exceptionWithName:@"invalidName" reason:@"name length is zero" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
    NSUInteger pos = 0;
    while(1)
    {
        NSUInteger partLen = bytes[pos];
        pos++;
        if((pos + partLen) > len)
        {
            @throw ([NSException exceptionWithName:@"invalidName" reason:@"name length is larger than data" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
        }
        if(partLen == 0)
        {
            break;
        }
        NSData *part = [NSData dataWithBytes:&bytes[pos-1] length:partLen+1];
        UMDnsLabel *newLabel = [[UMDnsLabel alloc]init];
        [newLabel setBinary:part enforceLengthLimit:enforceLengthLimits];
        [labels addObject:newLabel];
    }
    _labels = labels;
    return pos;
}

- (UMDnsName *)initWithVisualName:(NSString *)name
{
    self = [super init];
    if(self)
    {
        [self setVisualName:name];
    }
    return self;
}

- (UMDnsName *)initWithVisualName:(NSString *)name relativeToZone:(NSString *)zone
{
    self = [super init];
    if(self)
    {
        
        if([name isEqualToString:@"@"])
        {
            name = zone;
        }
        if([name hasSuffix:@"."])
        {
            [self setVisualName:[name substringToIndex:(name.length-1)]];
        }
        else
        {
            if([zone hasSuffix:@"."])
            {
                zone = [zone substringToIndex:(zone.length-1)];
            }
            [self setVisualName:[NSString stringWithFormat:@"%@.%@",name,zone]];
        }
    }
    return self;
}

- (UMDnsName *)initWithRawData:(NSData *)data atOffset:(int *)pos
{
    self = [super init];
    if(self)
    {
        int datapos = *pos;
        NSMutableArray *labels = [[NSMutableArray alloc]init];
        int redirectionCounter = 0;
        
        const unsigned char *bytes = [data bytes];
        NSUInteger len = [data length];
        if(len==0)
        {
            @throw ([NSException exceptionWithName:@"invalidName" reason:@"name length is zero" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
        }
        /* first we find the end of the data to process         */
        /* second we find all the data it might have pointed to */
        
        /* find end of data */
        while(1)
        {
            if(datapos >= len)
            {
                @throw ([NSException exceptionWithName:@"invalidName" reason:@"reading beyond end of data" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
            }
            int partLen  = bytes[datapos];
            datapos++;
            if(partLen==0)
            {
                break;
            }
            else if((partLen & 0xC0)== 0xC0) /* a pointer */
            {
                if(datapos >= len)
                {
                    @throw ([NSException exceptionWithName:@"invalidName" reason:@"reading beyond end of data" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
                }
                datapos++; /* virtually read lower 8 bit of length */
                break; /* nothing more to read after pointer */
            }
            else
            {
                /* not a pointer, skip the string bytes */
                datapos = datapos + partLen;
            }
        }
        *pos = datapos;
        /* find canonical name */
        
        int readpos = *pos;
        while(1)
        {
            if(readpos >= len)
            {
                @throw ([NSException exceptionWithName:@"invalidName" reason:@"reading beyond end of data" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
            }
            int partLen  = bytes[readpos];
            readpos++;
            if(partLen==0)
            {
                break;
            }
            else if((partLen & 0xC0)== 0xC0) /* a pointer */
            {
                redirectionCounter++;
                if(redirectionCounter > 8)
                {
                    @throw ([NSException exceptionWithName:@"invalidName" reason:@"more than 8 redirections" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
                }
                int newpos = (partLen & 0x3F) << 8;
                newpos |= bytes[readpos];
                if(readpos >= len)
                {
                    @throw ([NSException exceptionWithName:@"invalidName" reason:@"reading beyond end of data" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
                }
                readpos = newpos;
                /* nothing more to read after pointer */
            }
            else
            {
                /* not a pointer, skip the string bytes */
                if((readpos + partLen) > len)
                {
                    @throw ([NSException exceptionWithName:@"invalidName" reason:@"reading beyond end of data" userInfo:NULL]);
                }
                
                NSData *part = [NSData dataWithBytes:&bytes[readpos-1] length:partLen+1]; /* we include the length byte too */
                UMDnsLabel *newLabel = [[UMDnsLabel alloc]init];
                [newLabel setBinary:part enforceLengthLimit:YES];
                [labels addObject:newLabel];
            }
            _labels = labels;
        }
    }
    return self;
}

@end
