//
//  ulibdnsTests.m
//  ulibdnsTests
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright (c) 2016 Andreas Fink
//

#import <XCTest/XCTest.h>
#import "ulibdns/ulibdns.h"
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

@interface ulibdnsTests : XCTestCase
{
    NSString *projectDir;
}

@end

@implementation ulibdnsTests

- (void)setUp
{
    [super setUp];
    
    char savedir[_POSIX_PATH_MAX+1];
    memset(savedir,0x00,_POSIX_PATH_MAX+1);
    getcwd(savedir,_POSIX_PATH_MAX);
    
    const char *p = getenv("PROJECTDIR");
    if(p)
    {
        projectDir = [NSString stringWithFormat:@"%s/",p];
    }
    else
    {
        /* this is a ugly hack to find out the project directory */
        /* 
            we start off with an environment variable like this:
        DYLD_FRAMEWORK_PATH=/Users/afink/development/git/ulibdns/Build/Products/Debug:/Applications/Xcode-beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks
        */
        NSString *dyld_framework_path = @(getenv("DYLD_FRAMEWORK_PATH"));
        NSArray *parts = [dyld_framework_path componentsSeparatedByString:@":"];
        NSMutableString *projectDir2 = [[NSMutableString alloc]init];
        if([parts count]>0)
        {
            NSString *path1 = parts[0];
            /* we have something like this now:   /Users/afink/development/git/ulibdns/Build/Products/Debug */
            NSArray *pathComponents = [path1 componentsSeparatedByString:@"/"];
            NSUInteger remainingCount = pathComponents.count - 3;
            NSUInteger i;
            for(i=0;i<remainingCount;i++)
            {
                [projectDir2 appendFormat:@"%@/",pathComponents[i]];
            }
        }
        projectDir = projectDir2;
    }
    if(projectDir.length > 1)
    {
        chdir(projectDir.UTF8String);
    }
    else
    {
        chdir("/Users/afink/development/git/ulibdns/");
    }

    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCharacterString
{
    UMDnsCharacterString *cs = [[UMDnsCharacterString alloc]initWithString:@"hello"];
    
    NSData *binary = cs.binary;
    const unsigned char *bytes = binary.bytes;
    int len = (int)binary.length;
    
    unsigned char expectedBytes[] = {
        0x05, 'h','e','l','l','o'};
    XCTAssert(len==sizeof(expectedBytes),@"returned binary data is not correct length");
    
    XCTAssert( memcmp(expectedBytes,bytes,sizeof(expectedBytes))== 0, @"returned bytes dont match");

}

- (void)testDnsName
{
    UMDnsName *dn = [[UMDnsName alloc]initWithVisualName:@"hello"];
    XCTAssert([[dn visualName] isEqualToString:@"hello"]==YES,@"visual strings dont match");

    dn = [[UMDnsName alloc]initWithVisualName:@"hello."];
    XCTAssert([[dn visualName] isEqualToString:@"hello"]==YES,@"visual strings dont match");

    dn = [[UMDnsName alloc]initWithVisualName:@"hello.world"];
    XCTAssert([[dn visualName] isEqualToString:@"hello.world"]==YES,@"visual strings dont match");

    dn = [[UMDnsName alloc]initWithVisualName:@"hello.world."];
    XCTAssert([[dn visualName] isEqualToString:@"hello.world"]==YES,@"visual strings dont match");

    dn = [[UMDnsName alloc]initWithVisualName:@"hello" relativeToZone:@"world"];
    XCTAssert([[dn visualName] isEqualToString:@"hello.world"]==YES,@"visual strings dont match");

    dn = [[UMDnsName alloc]initWithVisualName:@"hello" relativeToZone:@"world."];
    XCTAssert([[dn visualName] isEqualToString:@"hello.world"]==YES,@"visual strings dont match");

    dn = [[UMDnsName alloc]initWithVisualName:@"hello.moon." relativeToZone:@"world"];
    XCTAssert([[dn visualName] isEqualToString:@"hello.moon"]==YES,@"visual strings dont match");

    dn = [[UMDnsName alloc]initWithVisualName:@"hello.moon." relativeToZone:@"world."];
    XCTAssert([[dn visualName] isEqualToString:@"hello.moon"]==YES,@"visual strings dont match");

    dn = [[UMDnsName alloc]initWithVisualName:@"hello.moon" relativeToZone:@"world."];
    XCTAssert([[dn visualName] isEqualToString:@"hello.moon.world"]==YES,@"visual strings dont match");

    dn = [[UMDnsName alloc]initWithVisualName:@"hello.world"];
    NSString *v = [dn visualNameRelativeTo:@"world"];
    XCTAssert([v isEqualToString:@"hello"]==YES,@"visual strings dont match");
    
    dn = [[UMDnsName alloc]initWithVisualName:@"hello.world"];
    v = [dn visualNameRelativeTo:@"world."];
    XCTAssert([v isEqualToString:@"hello"]==YES,@"visual strings dont match");

    dn = [[UMDnsName alloc]initWithVisualName:NULL];
    v = [dn visualNameRelativeTo:@"world"];
    NSLog(@"v=%@",v);
    dn = [[UMDnsName alloc]initWithVisualName:@""];
    v = [dn visualNameRelativeTo:@"world"];
    NSLog(@"v=%@",v);


}

- (void)testRecordA
{
    UMDnsResourceRecord *r = [UMDnsResourceRecord recordOfType:@"A" params:@[@"1.0.3.4"] zone:@"example.com"];

    XCTAssert(r != NULL,@"record is null");
    XCTAssert(r.recordType==UlibDnsResourceRecordType_A,@"its not an A record");
    NSData *binary = r.resourceData;
    const char *bytes = binary.bytes;
    int len = (int)binary.length;
    
    XCTAssert(len==4,@"returned binary data is not 4 bytes");
    XCTAssert(((bytes[0]==0x01) && (bytes[1]==0x00) &&(bytes[2]==0x03) &&(bytes[3]==0x04)),
                @"returned bytes dont match");
    XCTAssert([r.visualRepresentation isEqualToString:@"A\t1.0.3.4"],@"visual representation doesnt match");
}

- (void)testRecordAAAA
{
    UMDnsResourceRecord *r = [UMDnsResourceRecord recordOfType:@"AAAA" params:@[@"2001:1234:5678::1b:aa7f"] zone:@"example.com"];
    
    XCTAssert(r != NULL,@"record is null");
    XCTAssert(r.recordType==UlibDnsResourceRecordType_AAAA,@"its not an AAAA record");
    NSData *binary = r.resourceData;
    const unsigned char *bytes = binary.bytes;
    int len = (int)binary.length;
    
    XCTAssert(len==16,@"returned binary data is not 16 bytes");
    
    unsigned char expectedBytes[] = { 0x20, 0x01, 0x12, 0x34, 0x56, 0x78, 0x00, 0x00,0x00,0x00,0x00,0x00,0x00,0x1b,0xaa, 0x7f };
    
    XCTAssert( memcmp(expectedBytes,bytes,16)== 0, @"returned bytes dont match");
    XCTAssert([r.visualRepresentation isEqualToString:@"AAAA\t2001:1234:5678::1b:aa7f"],@"visual representation doesnt match");
}

- (void)testRecordNS
{
    UMDnsResourceRecord *r = [UMDnsResourceRecord recordOfType:@"NS" params:@[@"ns1.example.com"] zone:@"example.com"];
    
    XCTAssert(r != NULL,@"record is null");
    XCTAssert(r.recordType==UlibDnsResourceRecordType_NS,@"its not an NS record");
    NSData *binary = r.resourceData;
    const unsigned char *bytes = binary.bytes;
    int len = (int)binary.length;
    
    unsigned char expectedBytes[] = {   0x03, 'n','s','1',
                                        0x07,'e','x','a','m','p','l','e',
                                        0x03,'c','o','m',
                                        0x00 };
    
    XCTAssert(len==sizeof(expectedBytes),@"returned binary data is not correct length");

    XCTAssert( memcmp(expectedBytes,bytes,sizeof(expectedBytes))== 0, @"returned bytes dont match");
    XCTAssert([r.visualRepresentation isEqualToString:@"NS\tns1.example.com."],@"visual representation doesnt match");
}


- (void)testRecordMX
{
    UMDnsResourceRecord *r = [UMDnsResourceRecord recordOfType:@"MX" params:@[@"1234",@"ns1.example.com"] zone:@""];
    
    XCTAssert(r != NULL,@"record is null");
    XCTAssert(r.recordType==UlibDnsResourceRecordType_MX,@"its not an MX record");
    NSData *binary = r.resourceData;
    const unsigned char *bytes = binary.bytes;
    int len = (int)binary.length;
    
    unsigned char expectedBytes[] = {
        0x04,0xD2, /*preference as 16bit int */
        0x03, 'n','s','1',
        0x07,'e','x','a','m','p','l','e',
        0x03,'c','o','m',
        0x00 };
    
    XCTAssert(len==sizeof(expectedBytes),@"returned binary data is not correct length");
    
    XCTAssert( memcmp(expectedBytes,bytes,sizeof(expectedBytes))== 0, @"returned bytes dont match");
    XCTAssert([r.visualRepresentation isEqualToString:@"MX\t1234\tns1.example.com."],@"visual representation doesnt match");
}

- (void)testRecordPTR
{
    UMDnsResourceRecord *r = [UMDnsResourceRecord recordOfType:@"PTR" params:@[@"ns1.example.com"] zone:@""];
    
    XCTAssert(r != NULL,@"record is null");
    XCTAssert(r.recordType==UlibDnsResourceRecordType_PTR,@"its not an PTR record");
    NSData *binary = r.resourceData;
    const unsigned char *bytes = binary.bytes;
    int len = (int)binary.length;
    
    unsigned char expectedBytes[] = {
        0x03, 'n','s','1',
        0x07,'e','x','a','m','p','l','e',
        0x03,'c','o','m',
        0x00 };
    
    XCTAssert(len==sizeof(expectedBytes),@"returned binary data is not correct length");
    
    XCTAssert( memcmp(expectedBytes,bytes,sizeof(expectedBytes))== 0, @"returned bytes dont match");
    XCTAssert([r.visualRepresentation isEqualToString:@"PTR\tns1.example.com."],@"visual representation doesnt match");
}


- (void)testRecordHINFO
{
    UMDnsResourceRecord *r = [UMDnsResourceRecord recordOfType:@"HINFO" params:@[@"mac",@"osx"] zone:@""];
    
    XCTAssert(r != NULL,@"record is null");
    XCTAssert(r.recordType==UlibDnsResourceRecordType_HINFO,@"its not an HINFO record");
    NSData *binary = r.resourceData;
    const unsigned char *bytes = binary.bytes;
    int len = (int)binary.length;
    
    unsigned char expectedBytes[] =
    {
        0x03,'m','a','c',
        0x03,'o','s','x'
    };
    
    NSLog(@"b: %@",binary);

    XCTAssert(len==sizeof(expectedBytes),@"returned binary data is not correct length");
    
    int compareResult = memcmp(&expectedBytes[0],&bytes[0],sizeof(expectedBytes));
    
    XCTAssert(compareResult== 0, @"returned bytes dont match");
    NSString *a = [r visualRepresentation];
    NSString *b = @"HINFO\tmac\tosx";
    BOOL visualMatch = [a isEqualToString:b];
    
    XCTAssert(visualMatch,@"visual representation doesnt match");
}

- (void)testRecordSOA
{
    UMDnsResourceRecord *r = [UMDnsResourceRecord recordOfType:@"SOA" params:
                              @[@"master",
                                @"responsible",
                                @"2015032710",
                                @"28800",
                                @"7200",
                                @"1209600",
                                @"86400"]
                                zone:@""];
    
    XCTAssert(r != NULL,@"record is null");
    XCTAssert(r.recordType==UlibDnsResourceRecordType_SOA,@"its not an SOA record");
    
    NSData *binary = r.resourceData;
    const unsigned char *bytes = binary.bytes;
    int len = (int)binary.length;
    
    unsigned char expectedBytes[] =
    {
        0x06,'m','a','s','t','e','r',0x00, /* MNAME */
        0x0B,'r','e','s','p','o','n','s','i','b','l','e',0x00, /* RNAME */
        0x78, 0x1A, 0xF5, 0x86, /* SERIAL */
        0x00, 0x00, 0x70, 0x80, /* REFRESH */
        0x00, 0x00, 0x1c, 0x20, /* RETRY */
        0x00, 0x12, 0x75, 0x00, /* EXPIRE */
        0x00, 0x01,  0x51, 0x80, /* MINIMUM */
    };
    
    NSLog(@"b: %@",binary);
    
    XCTAssert(len==sizeof(expectedBytes),@"returned binary data is not correct length");
    
    int compareResult = memcmp(&expectedBytes[0],&bytes[0],sizeof(expectedBytes));
    
    XCTAssert(compareResult== 0, @"returned bytes dont match");
    NSString *a = [r visualRepresentation];
    NSString *b = @"SOA master. responsible. (\n"
    "\t2015032710; serial INCREMENT AFTER CHANGE\n"
    "\t     28800; refresh every 8 hours\n"
    "\t      7200; if refres fails, retry all 120 minutes\n"
    "\t   1209600; expire secondary after 14 days\n"
    "\t     86400; minimum in cache\n"
    "\t);\n";
    BOOL visualMatch = [a isEqualToString:b];
  
    XCTAssert(visualMatch==YES,@"visual representation doesnt match");
}

- (void)testZonefile
{
    
    UMDnsZone *zone = [[UMDnsZone alloc]initWithFile:@"testfiles/test1.example.com.txt" origin:@"example.com" defaultTtl:3600];
    XCTAssert(zone!=NULL,@"error while reading zone file");

    NSLog(@"Zone: %@",zone);

}
@end
