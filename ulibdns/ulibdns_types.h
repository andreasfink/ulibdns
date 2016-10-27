//
//  ulibdns_types.h
//  ulibdns
//
//  Created by Andreas Fink on 31/08/15.
//  Copyright (c) 2016 Andreas Fink
//

#import <ulib/ulib.h>

#include <ctype.h>

/* according to RFC 1035 page 12 */
typedef enum UlibDnsResourceRecordType
{
    UlibDnsResourceRecordType_UNKNOWN       = 0, /*  RRTYPE zero is used as a special indicator for the SIG RR [RFC2931], [RFC4034] and in other circumstances and must never be allocated for ordinary use. */
    UlibDnsResourceRecordType_A             = 1, /* RFC1035 */
    UlibDnsResourceRecordType_NS            = 2, /* RFC1035 */
        UlibDnsResourceRecordType_MD            = 3, /* mail destination RFC1035 , obsolted, use MX */
        UlibDnsResourceRecordType_MF            = 4, /* mail forwarder RFC1035 , obsolted, use MX */
    UlibDnsResourceRecordType_CNAME         = 5, /* RFC1035 canonical name for an alias */
    UlibDnsResourceRecordType_SOA           = 6, /* RFC1035 marks the start of a zone of authority */
        UlibDnsResourceRecordType_MB            = 7, /* RFC1035 mailbox domain name. experimental */
        UlibDnsResourceRecordType_MG            = 8, /* RFC1035 mailgroup member. experimental */
        UlibDnsResourceRecordType_MR            = 9, /* RFC1035 mailrename member. experimental */
        UlibDnsResourceRecordType_NULL          = 10, /* RFC1035 a NULL RR. experimental */
    UlibDnsResourceRecordType_WKS           = 11, /* RFC1035 a well known service description */
    UlibDnsResourceRecordType_PTR           = 12, /* RFC1035 a domain name pointer */
    UlibDnsResourceRecordType_HINFO         = 13, /* RFC1035 host information */
        UlibDnsResourceRecordType_MINFO         = 14, /* RFC1035 mailbox on mail list information */
    UlibDnsResourceRecordType_MX            = 15, /* RFC1035 mail exchange */
    UlibDnsResourceRecordType_TXT           = 16, /* RFC1035 text strings */
    UlibDnsResourceRecordType_RP            = 17, /* RFC1183 responsile person */
    UlibDnsResourceRecordType_AFSDB         = 18, /* RFC1183, RFC5864 for AFS Data Base location */
    UlibDnsResourceRecordType_X25           = 19, /* RFC1183 for X.25 PSDN address	 */
    UlibDnsResourceRecordType_ISDN          = 20, /* RFC1183 for ISDN address	 */
    UlibDnsResourceRecordType_RT            = 21, /* RFC1183 for route through address	 */
    UlibDnsResourceRecordType_NSAP          = 22, /* RFC1706 for NSAP address, NSAP style A record */
        UlibDnsResourceRecordType_NSAP_PTR      = 23, /* RFC1348,RFC1637,RFC1706 for domain name pointer, NSAP style */
    UlibDnsResourceRecordType_SIG           = 24, /* for security signature	[RFC4034][RFC3755][RFC2535][RFC2536][RFC2537][RFC2931][RFC3110][RFC3008] */
    UlibDnsResourceRecordType_KEY           = 25, /* for security key	[RFC4034][RFC3755][RFC2535][RFC2536][RFC2537][RFC2539][RFC3008][RFC3110]*/
    UlibDnsResourceRecordType_PX            = 26, /*.400 mail mapping information	[RFC2163] */
    UlibDnsResourceRecordType_GPOS          = 27, /* Geographical Position	[RFC1712] */
    UlibDnsResourceRecordType_AAAA          = 28, /* IP6 Address	[RFC3596] */
    UlibDnsResourceRecordType_LOC           = 29, /* Location Information	[RFC1876] */
    UlibDnsResourceRecordType_NXT           = 30, /* Next Domain (OBSOLETE)	[RFC3755][RFC2535] */
        UlibDnsResourceRecordType_EID           = 31, /* Endpoint Identifier	[Michael_Patton][http://ana-3.lcs.mit.edu/~jnc/nimrod/dns.txt] */
        UlibDnsResourceRecordType_NIMLOC        = 32, /* Nimrod Locator	[1][Michael_Patton][http://ana-3.lcs.mit.edu/~jnc/nimrod/dns.txt] */
    UlibDnsResourceRecordType_SRV           = 33, /* Server Selection	[1][RFC2782] */
        UlibDnsResourceRecordType_ATMA          = 34, /* ATM Address	[ ATM Forum Technical Committee, "ATM Name System, V2.0", Doc ID: AF-DANS-0152.000, held in escrow by IANA.] */
        UlibDnsResourceRecordType_NAPTR         = 35, /* Naming Authority Pointer	[RFC2915][RFC2168][RFC3403] */
    UlibDnsResourceRecordType_KX            = 36, /* Key Exchanger	[RFC2230] */
    UlibDnsResourceRecordType_CERT          = 37, /* CERT	[RFC4398] */
    UlibDnsResourceRecordType_A6            = 38, /* A6 (OBSOLETE - use AAAA)	[RFC3226][RFC2874][RFC6563] */
    UlibDnsResourceRecordType_DNAME         = 39, /* DNAME	[RFC6672] */
        UlibDnsResourceRecordType_SINK          = 40, /* SINK	[Donald_E_Eastlake][http://tools.ietf.org/html/draft-eastlake-kitchen-sink]	*/
        UlibDnsResourceRecordType_OPT           = 41, /* OPT	[RFC6891][RFC3225] */
    UlibDnsResourceRecordType_APL           = 42, /* APL	[RFC3123] */
    UlibDnsResourceRecordType_DS            = 43, /* Delegation Signer	[RFC4034][RFC3658] */
    UlibDnsResourceRecordType_SSHFP         = 44, /* SSH Key Fingerprint	[RFC4255] */
    UlibDnsResourceRecordType_IPSECKEY      = 45, /* IPSECKEY	[RFC4025]*/
    UlibDnsResourceRecordType_RRSIG         = 46, /* RRSIG	[RFC4034][RFC3755]*/
    UlibDnsResourceRecordType_NSEC          = 47, /* NSEC	[RFC4034][RFC3755]*/
    UlibDnsResourceRecordType_DNSKEY        = 48, /* DNSKEY	[RFC4034][RFC3755]*/
    UlibDnsResourceRecordType_DHCID         = 49, /* DHCID	[RFC4701]*/
    UlibDnsResourceRecordType_NSEC3         = 50, /* NSEC3	[RFC5155]*/
    UlibDnsResourceRecordType_NSEC3PARAM	= 51, /* NSEC3PARAM	[RFC5155]*/
        UlibDnsResourceRecordType_TLSA          = 52, /* TLSA	[RFC6698]*/
     //  UlibDnsResourceRecordType_Unassigned	53-54*/
        UlibDnsResourceRecordType_HIP           = 55, /* Host Identity Protocol	[RFC5205] */
        UlibDnsResourceRecordType_NINFO         = 56, /* NINFO	[Jim_Reid]	NINFO/ninfo-completed-template	2008-01-21*/
        UlibDnsResourceRecordType_RKEY          = 57, /* RKEY	[Jim_Reid]	RKEY/rkey-completed-template	2008-01-21*/
        UlibDnsResourceRecordType_TALINK        = 58, /* Trust Anchor LINK	[Wouter_Wijngaards]	TALINK/talink-completed-template	2010-02-17*/
        UlibDnsResourceRecordType_CDS           = 59, /* Child DS	[RFC7344]	CDS/cds-completed-template	2011-06-06*/
        UlibDnsResourceRecordType_CDNSKEY       = 60, /* DNSKEY(s) the Child wants reflected in DS	[RFC7344]		2014-06-16*/
        UlibDnsResourceRecordType_OPENPGPKEY	= 61, /* OpenPGP Key	[draft-ietf-dane-openpgpkey]	OPENPGPKEY/openpgpkey-completed-template	2014-08-12*/
        UlibDnsResourceRecordType_CSYNC         = 62, /* Child-To-Parent Synchronization	[RFC7477]		2015-01-27*/
     //   UlibDnsResourceRecordType_Unassigned	63-98*/
    UlibDnsResourceRecordType_SPF           = 99, /* [RFC7208]*/
        UlibDnsResourceRecordType_UINFO         = 100, /* [IANA-Reserved]*/
        UlibDnsResourceRecordType_UID           = 101, /* [IANA-Reserved]*/
        UlibDnsResourceRecordType_GID           = 102, /* [IANA-Reserved]*/
        UlibDnsResourceRecordType_UNSPEC        = 103, /* [IANA-Reserved]*/
        UlibDnsResourceRecordType_NID           = 104, /* [RFC6742]	ILNP/nid-completed-template*/
        UlibDnsResourceRecordType_L32           = 105, /* [RFC6742]	ILNP/l32-completed-template*/
        UlibDnsResourceRecordType_L64           = 106, /* [RFC6742]	ILNP/l64-completed-template*/
        UlibDnsResourceRecordType_LP            = 107, /* [RFC6742]	ILNP/lp-completed-template*/
        UlibDnsResourceRecordType_EUI48         = 108, /* an EUI-48 address	[RFC7043]	EUI48/eui48-completed-template	2013-03-27*/
        UlibDnsResourceRecordType_EUI64         = 109, /* an EUI-64 address	[RFC7043]	EUI64/eui64-completed-template	2013-03-27*/
                                /* Unassigned	110-248*/
        UlibDnsResourceRecordType_TKEY          = 249, /* Transaction Key	[RFC2930]*/
        UlibDnsResourceRecordType_TSIG          = 250, /* Transaction Signature	[RFC2845]*/
        UlibDnsResourceRecordType_IXFR          = 251, /* incremental transfer	[RFC1995]*/
        UlibDnsResourceRecordType_AXFR          = 252, /* transfer of an entire zone	[RFC1035][RFC5936]*/
        UlibDnsResourceRecordType_MAILB         = 253, /* mailbox-related RRs (MB, MG or MR)	[RFC1035]*/
        UlibDnsResourceRecordType_MAILA         = 254, /* mail agent RRs (OBSOLETE - see MX)	[RFC1035]*/
    //    UlibDnsResourceRecordType_*	255	A request for all records the server/cache has available	[RFC1035][RFC6895]*/
        UlibDnsResourceRecordType_URI           = 256, /* URI	[RFC7553]	URI/uri-completed-template	2011-02-22*/
        UlibDnsResourceRecordType_CAA           = 257, /* Certification Authority Restriction	[RFC6844]	CAA/caa-completed-template	2011-04-07*/
        /* Unassigned	258-32767*/
        UlibDnsResourceRecordType_TA            = 32768, /*	DNSSEC Trust Authorities	[Sam_Weiler][http://cameo.library.cmu.edu/][ Deploying DNSSEC Without a Signed Root. Technical Report 1999-19, Information Networking Institute, Carnegie Mellon University, April 2004.]		2005-12-13*/
        UlibDnsResourceRecordType_DLV           = 32769, /*	DNSSEC Lookaside Validation	[RFC4431]*/
                                /* Unassigned	32770-65279 */
                                /* Private use	65280-65534 */
                                /* Reserved     65535       */
} UlibDnsResourceRecordType;

typedef enum UlibDnsQueryType
{
    UlibDnsQueryType_AXFR   = 252,
    UlibDnsQueryType_MAILB  = 253,
    UlibDnsQueryType_MAILA  = 254,
    UlibDnsQueryType_ANY    = 255,
} UlibDnsQueryType;

/* see also http://www.iana.org/assignments/dns-parameters/dns-parameters.xhtml#dns-parameters-2 */
typedef enum UlibDnsClass
{
    UlibDnsClass_RESERVED     = 0,
    UlibDnsClass_IN     = 1,
    UlibDnsClass_CS     = 2, /* unassigned */
    UlibDnsClass_CH     = 3,
    UlibDnsClass_HS     = 4,
} UlibDnsClass;

typedef enum UlibDnsQueryClassType
{
    UlibDnsQueryClassType_NONE   = 254,
    UlibDnsQueryClassType_ANY    = 255,
} UlibDnsQueryClassType;

#define ULIBDNS_MAX_LABEL_LENGTH    63
#define ULIBDNS_MAX_NAMES_LENGTH    255
#define ULIBDBS_MAX_TTL             0x7FFFFFFF
#define ULIBDBS_MAX_UDP             512

#define ULIBDNS_VALID_LOWER_DNS_CHARS   "abcdefghijklmnopqrstuvwxyz0123456789-"

