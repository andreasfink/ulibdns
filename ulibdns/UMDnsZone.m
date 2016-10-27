//
//  UMDnsZone.m
//  ulibdns
//
//  Created by Andreas Fink on 31.08.15.
//  Copyright (c) 2016 Andreas Fink
//

#import "UMDnsZone.h"

#include <ctype.h>

@implementation UMDnsZone

@synthesize defaultTtl;

- (UMDnsZone *) initWithFile:(NSString *)filename origin:(NSString *)or defaultTtl:(int)ttl
{
    self = [super init];
    if(self)
    {
        rr =[[UMSynchronizedArray alloc]init];
        rrByName = [[UMSynchronizedDictionary alloc]init];
        defaultTtl = ttl;
        NSData *zonedata = [NSData dataWithContentsOfFile:filename];
        NSArray *parsedLines = [self parseData:zonedata forFile:filename origin:or];
        parsedLines = [self processIncludes:parsedLines forFile:filename origin:or stack:0];
        [self processLines:parsedLines];
    }
    return self;
}

- (void)parseLineInFile:(NSString *)filename lineNo:(int)lineno line:(NSString *)line parsedLinesArray:(NSMutableArray *)xparsedLines
{
    if([line length]>0)
    {
        NSDictionary *d =@{ @"filename": filename,
                        @"lineNo": @(lineno),
                        @"line": line,
                     };
        [xparsedLines addObject:d];
    }
}

- (void)processLines:(NSArray *)lines
{
    NSUInteger i;
    NSUInteger n = [lines count];
    UMDnsName *lastDnsName = [[UMDnsName alloc]init];
    for(i=0;i<n;i++)
    {
        NSDictionary *d = lines[i];
        
        NSString *filename = d[@"filename"];
        int lineNo = (int)[d[@"lineNo"] integerValue];
        NSString *line = d[@"line"];
        [self processLine:filename lineNo:lineNo  line:line last:&lastDnsName];
    }
}

- (void)processLine:(NSString *)filename lineNo:(int)lineno  line:(NSString *)currentLine last:(UMDnsName **)lastDnsName
{
    /* In the compare: methods, the range argument specifies the subrange, rather than the whole, of the receiver to use in the comparison. The range is not applied to the search string.  For example, [@"AB" compare:@"ABC" options:0 range:NSMakeRange(0,1)] compares "A" to "ABC", not "A" to "A", and will return NSOrderedAscending.
     */

    NSLog(@"%@:%d %@",filename,lineno,currentLine);
    NSArray *items = [currentLine componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    items = [self trimArray:items];

    int i=0;
    for(NSString *s in items)
    {
        NSLog(@"[%d]%@",i++,s);
    }
    if(items.count >= 2)
    {
        NSString *first  = [items objectAtIndex:0];
        NSString *second = [items objectAtIndex:1];
        if( [first caseInsensitiveCompare:@"$ORIGIN"] == NSOrderedSame)
        {
            if(items.count == 2)
            {
                defaultOrigin = [[UMDnsName alloc]initWithVisualName:second relativeToZone:@"."];
            }
            else
            {
                @throw ([NSException exceptionWithName:@"invalidZoneFile"
                                            reason:[NSString stringWithFormat:@"can't process $ORIGIN statement in file %@ line %d",filename,lineno]
                                          userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
            }
        }
        else if( [first caseInsensitiveCompare:@"$TTL"] == NSOrderedSame)
        {
            if(items.count == 2)
            {
                defaultTtl = [second integerValue];
            }
            else
            {
                @throw ([NSException exceptionWithName:@"invalidZoneFile"
                                                reason:[NSString stringWithFormat:@"can't process $TTL statement in file %@ line %d",filename,lineno]
                                              userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
            }
        }
        else if( [first caseInsensitiveCompare:@"$GENERATE"] == NSOrderedSame) /* Syntax: $GENERATE range lhs [ttl] [class] type rhs [comment] */
        {
            @throw ([NSException exceptionWithName:@"invalidZoneFile"
                                                reason:[NSString stringWithFormat:@"$GENERATE (bind extension) not implemented yet.file %@ line %d",filename,lineno]
                                              userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
        }
        else if([first compare:@"$" options:NSCaseInsensitiveSearch
                                 range:NSMakeRange(0,1)] == NSOrderedSame)
        {
            @throw ([NSException exceptionWithName:@"invalidZoneFile"
                                        reason:[NSString stringWithFormat:@"unknown $ symbol in file %@ line %d",filename,lineno]
                                      userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
        }
        else
        {
            //NSString *name;
            UlibDnsClass class = UlibDnsClass_IN;
            NSInteger ttl;
            NSInteger i=0;
            NSString *item = NULL;
            #define GRAB(item,items,i) { if (i < items.count) { item = [items objectAtIndex:i]; } else { item = NULL; } i++; }
            
            i=0;
            GRAB(item,items,i);
            
            //name = [self fullyQualify:item usingOrigin:defaultOrigin.visualName saveName:YES];

            UMDnsName *dnsName;
            if(item.length==0)
            {
                dnsName = *lastDnsName;
            }
            else if ([item isEqualToString:@"@"])
            {
                dnsName = [[UMDnsName alloc]initWithVisualName:defaultOrigin.visualName];
                *lastDnsName = dnsName;
            }
            else
            {
                dnsName = [[UMDnsName alloc]initWithVisualName:item relativeToZone:defaultOrigin.visualName];
                *lastDnsName = dnsName;
            }
            
            GRAB(item,items,i);  /* this is either TTL or CLASS or already a RR identifier */
            {
                ttl = (NSInteger)atoi(item.UTF8String);
                if((ttl > 0) && ([item isEqualToString:[NSString stringWithFormat:@"%d",(int)ttl] ]))
                {
                    /* TTL is correctly set */
                    GRAB(item,items,i);  /* now look for CLASS or already a RR identifier */
                        ;
                }
                else
                {
                    ttl = defaultTtl;
                }
            }
            
            if([item caseInsensitiveCompare:@"IN"]==NSOrderedSame)
            {
                class = UlibDnsClass_IN;
                GRAB(item,items,i);  /* now look for RR identifier */
            }
            else if([item caseInsensitiveCompare:@"CS"]==NSOrderedSame)
            {
                class = UlibDnsClass_CS;
                GRAB(item,items,i);  /* now look for RR identifier */
            }
            else if([item caseInsensitiveCompare:@"CH"]==NSOrderedSame)
            {
                class = UlibDnsClass_CH;
                GRAB(item,items,i);  /* now look for RR identifier */
            }
            else if([item caseInsensitiveCompare:@"HS"]==NSOrderedSame)
            {
                class = UlibDnsClass_HS;
                GRAB(item,items,i);  /* now look for RR identifier */
            }
            
            /* the rest are params */

            NSMutableArray *array = [[NSMutableArray alloc]init];
            for(;i<items.count;i++)
            {
                [array addObject:[items objectAtIndex:i]];
            }
            
            UMDnsResourceRecord *rrec = [UMDnsResourceRecord recordOfType:item params:array zone:defaultOrigin.visualName];
            if([rrec isKindOfClass:[UMDnsResourceRecordSOA class]])
            {
                soa = (UMDnsResourceRecordSOA *)rrec;
            }
            rrec.name = dnsName;
            rrec.recordClass = class;
            rrec.ttl = ttl;
            [rr addObject:rrec];
            
            @synchronized(rrByName)
            {
                UMSynchronizedArray *arr = rrByName[dnsName.visualName];
                if(arr == NULL)
                {
                    arr = [[UMSynchronizedArray alloc]init];
                }
                [arr addObject:rrec];
                rrByName[dnsName.visualName] = arr;
            }
        }
    }
}

- (NSArray *)trimArray:(NSArray *)in
{
    if(in==NULL)
    {
        return NULL;
    }
    if(in.count==1)
    {
        return in;
    }
    
    NSMutableArray *out = [[NSMutableArray alloc]init];
    NSUInteger i;
    NSUInteger n;
    n = [in count];
    [out addObject: in[0]];
    for(i=1;i<n;i++)
    {
        NSString *item = in[i];
        if([item length]>0)
        {
            [out addObject:item];
        }
    }
    return out;
}

- (NSArray *)processIncludes:(NSArray *)in forFile:(NSString *)filename origin:(NSString *)newOrigin stack:(int)stack
{
    NSMutableArray *out = [[NSMutableArray alloc]init];
    NSUInteger i;
    NSUInteger n;
    n = [in count];
    for(i=0;i<n;i++)
    {
        NSDictionary *entry = in[i];
        NSString *line  = entry[@"line"];
        if((line.length >8) && ([[line substringToIndex:8] isEqualToString:@"$INCLUDE"]))
        {
            NSArray *items = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            items = [self trimArray:items];
            if([items count] < 2)
            {
                @throw([NSException exceptionWithName:@"invalid_include_statement" reason:@"include statement is missing filename" userInfo:entry]);
            }
            NSString *includeFileName = items[1];
            NSData *zonedata = [NSData dataWithContentsOfFile:includeFileName];
            if(zonedata==NULL)
            {
                @throw([NSException exceptionWithName:@"invalid_include_file" reason:@"can not read include file" userInfo:entry]);
            }

            NSString *origin = newOrigin;
            if([items count] >=3)
            {
                origin = items[2];
            }
            /* FIXME: what should the origin be? param3 maybe ? */
            NSArray *includedLines = [self parseData:zonedata forFile:includeFileName origin:origin];
            stack++;
            if(stack > 32)
            {
                @throw([NSException exceptionWithName:@"too_many_nested_includes" reason:@"include has reached 32  nested include levels" userInfo:entry]);
            }
            includedLines = [self processIncludes:includedLines forFile:includeFileName origin:origin stack:stack+1];
            NSUInteger j;
            NSUInteger m;
            m = [includedLines count];
            for(j=0;j<m;j++)
            {
                NSDictionary *entry2 = includedLines[j];
                [out addObject:entry2];
            }
        }
        else
        {
            [out addObject:entry];
        }
    }
    return out;
}

- (NSArray *)parseData:(NSData *)zonedata forFile:(NSString *)filename origin:(NSString *)newOrigin
{
    NSMutableArray *xparsedLines = [[NSMutableArray alloc]init];

    UMDnsName *oldOrigin = defaultOrigin;
    if(newOrigin)
    {
        defaultOrigin = [[UMDnsName alloc]initWithVisualName:newOrigin];
    }

    int lineno = 1;
    NSUInteger len = [zonedata length];
    const unsigned char *bytes = [zonedata bytes];
    NSMutableString *currentLine = [[NSMutableString alloc]init];
    BOOL _parseInEscape = NO;
    BOOL _parseInComment = NO;
    BOOL _parseInQuote = NO;
    BOOL _parseInOpenBrace=NO;
    BOOL _parseInWhiteSpace=NO;
    int _parseLineNo=0;
    
    for(NSUInteger i=0;i<len;i++)
    {

        char c = bytes[i];
        //NSLog(@"c=%d %c",c,c);
        /* if we are in a comment we ignore everything until end of line */
        if(_parseInComment)
        {
            if(c!='\n')
            {
                continue;
            }
            _parseInComment=NO;
        }
        switch(c)
        {
            case '\r': /* we ignore CR and act on LF only */
                break;
            case '\n':
                if(_parseInEscape)
                {
                    [currentLine appendFormat:@"%c",c];
                    _parseInEscape = NO;
                    _parseInQuote = NO;
                    lineno++;
                    break;
                }
                if(_parseInQuote)
                {
                    if(c=='"')
                    {
                        _parseInQuote=NO;
                    }
                }
                if(_parseInOpenBrace)
                {
                    [currentLine appendString:@" "];
                    lineno++; /* increase the line number for scanning but dont end the line */
                    break;
                }
                else
                {
                    [self parseLineInFile:filename lineNo:lineno line:currentLine parsedLinesArray:xparsedLines] ;
                    currentLine = [[NSMutableString alloc]init];
                    lineno++;
                }
                break;
            case '(':
                if(_parseInEscape)
                {
                    [currentLine appendFormat:@"%c",c];
                    _parseInEscape = NO;
                    break;
                }
                if(_parseInOpenBrace)
                {
                    @throw ([NSException exceptionWithName:@"invalidZoneFile"
                                                    reason:[NSString stringWithFormat:@"opening brace in opening brace in file %@ line %d",filename,_parseLineNo]
                                                  userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
                    break;
                }
                _parseInOpenBrace=YES;
                break;
            case ')':
                _parseInWhiteSpace=NO;
                if(_parseInEscape)
                {
                    [currentLine appendFormat:@"%c",c];
                    _parseInEscape = NO;
                    break;
                }
                if(_parseInOpenBrace)
                {
                    _parseInOpenBrace = NO;
                    break;
                }
                break;
            case ';':
                _parseInWhiteSpace=NO;
                if(_parseInEscape)
                {
                    [currentLine appendFormat:@"%c",c];
                    _parseInEscape = NO;
                    break;
                }
                _parseInComment=YES;
                _parseInWhiteSpace=NO;
                break;
                
            /* limit to one whitespace */
            case ' ':
            case '\t':
                if(_parseInWhiteSpace==NO)
                {
                    [currentLine appendFormat:@" "];
                    _parseInWhiteSpace=YES;
                }
                break;

            default:
                _parseInWhiteSpace=NO;
                [currentLine appendFormat:@"%c",c];
                break;

        }
    }
    defaultOrigin = oldOrigin;
    return xparsedLines;
}

- (NSString *)description
{
    NSMutableString *s = [[NSMutableString alloc]init];
    [s appendFormat:@"Zone:\n"];
    [s appendFormat:@" defaultOrigin:%@\n",defaultOrigin.visualName];
    [s appendFormat:@" soa:%@\n",soa.visualRepresentation];
    NSUInteger i=0;
    NSUInteger n=rr.count;
    for(i=0;i<n;i++)
    {
        UMDnsResourceRecord *r = rr[i];
        NSString *v = r.visualRepresentation;
        [s appendFormat:@"%@ %@ %d %@\n",r.name.visualNameAbsoluteWriting,r.recordClassString,(int)r.ttl,v];
    }
    return s;
}



@end
