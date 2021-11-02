//
//  UMDnsError.h
//  ulibdns
//
//  Created by Andreas Fink on 02.11.21.
//  Copyright © 2021 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>

typedef enum UMDnsErrorCode
{
    UMDnsError_inProgress   = 0,
    UMDnsError_done         = 1,
    UMDnsError_notFound     = -1,
} UMDnsErrorCode;

