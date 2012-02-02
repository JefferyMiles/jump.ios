//
//  Created by lillialexis on 1/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "CaptureInterface.h"
#import "JSONKit.h"

@interface NSString (NSString_JSON_ESCAPE)
- (NSString*)URLEscaped;
@end

@implementation NSString (NSString_JSON_ESCAPE)
- (NSString*)URLEscaped
{

    NSString *encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                NULL,
                                (CFStringRef)self,
                                NULL,
                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                kCFStringEncodingUTF8);

    return encodedString;
}
@end

@interface CaptureInterface ()
@property (nonatomic, retain) id<CaptureInterfaceDelegate> captureInterfaceDelegate;
@property (nonatomic, retain) JRCaptureUser *captureUser;
@property (nonatomic, copy)   NSString      *captureCreationToken;
@end

@implementation CaptureInterface
@synthesize captureInterfaceDelegate;
@synthesize captureUser;
@synthesize captureCreationToken;

static CaptureInterface* singleton = nil;

static NSString *captureUrl = @"https://demo.staging.janraincapture.com/";
static NSString *clientId   = @"svaf3gxsmcvyfpx5vcrdwyv2axvy9zqg";
static NSString *typeName   = @"demo_user";


- (CaptureInterface*)init
{
    if ((self = [super init]))
    {
//        acceptableAttributes = [[NSArray arrayWithObjects:
//                                             @"displayName",
//                                             @"email",
//                                             @"emailVerified",
//                                             nil] retain];
    }

    return self;
}

+ (id)captureInterfaceInstance
{
    if (singleton == nil) {
        singleton = [((CaptureInterface*)[super allocWithZone:NULL]) init];
    }

    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self captureInterfaceInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release { }

- (id)autorelease
{
    return self;
}

- (void)finishCreateCaptureUser:(NSString*)message
{
    DLog(@"");
    // blah blah blah

    if ([message isEqualToString:@"ok"])
        if ([captureInterfaceDelegate respondsToSelector:@selector(createCaptureUserDidSucceed)])
            [captureInterfaceDelegate createCaptureUserDidSucceed];
    else
        if ([captureInterfaceDelegate respondsToSelector:@selector(createCaptureUserDidFail)])
            [captureInterfaceDelegate createCaptureUserDidFail];

    self.captureInterfaceDelegate = nil;
}

- (NSDictionary *)makeCaptureUserFromEngageUser:(NSDictionary *)engageUser
{
////    NSMutableDictionary *captureDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
//    NSDictionary *profile                 = [engageUser objectForKey:@"profile"];
//    NSDictionary *captureAdditions        = [engageUser objectForKey:@"captureAdditions"];
//
//
//    JRCaptureUser *captureUserObject = [JRCaptureUser captureUser];
//
//    captureUserObject.profiles = [NSArray arrayWithObject:[JRProfiles profilesObjectFromEngageProfileDictionary:engageUser]];
//
////    JRProfile *profileObject = [JRProfile profile];
////
////
////    captureUserObject.displayName = @"testing";
////    captureUserObject.primaryAddress = [JRPrimaryAddress primaryAddress];
////    captureUserObject.primaryAddress.address1 = @"blah blah blah";
//
//    return [captureUserObject dictionaryFromObject];
//
////    for (NSString *key in [profile allKeys])
////        if ([acceptableAttributes containsObject:key])
////            [captureDictionary setObject:[profile objectForKey:key] forKey:key];
////
////    return captureDictionary;

    return nil;
}

- (void)startCreateCaptureUser:(NSDictionary*)user
{
    DLog(@"");

//    NSDictionary *newCaptureUser = [self makeCaptureUserFromEngageUser:user];
    NSString     *attributes     = [[user JSONString] URLEscaped];
//    NSString     *creationToken  = [[user objectForKey:@"captureCredentials"] objectForKey:@"creation_token"];

//    DLog(@"%@", creationToken);

    NSMutableData* body = [NSMutableData data];

    [body appendData:[[NSString stringWithFormat:@"type_name=%@", typeName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&attributes=%@", attributes] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&creation_token=%@", captureCreationToken] dataUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity.create", captureUrl]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary* tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"createUser", @"action",
                                        user, @"user", nil];

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
        [self finishCreateCaptureUser:@"fail"];
}

+ (void)captureUserObjectFromDictionary:(NSDictionary *)dictionary
{
    CaptureInterface* captureInterface = [CaptureInterface captureInterfaceInstance];
    captureInterface.captureUser = [JRCaptureUser captureUserObjectFromDictionary:dictionary];
}

+ (void)createCaptureUser:(NSDictionary *)user withCreationToken:(NSString *)creationToken
              forDelegate:(id<CaptureInterfaceDelegate>)delegate
{
    DLog(@"");
    CaptureInterface* captureInterface = [CaptureInterface captureInterfaceInstance];

    captureInterface.captureInterfaceDelegate = delegate;
    captureInterface.captureCreationToken       = creationToken;

    [captureInterface startCreateCaptureUser:user];
}

- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(NSObject*)userdata
{
    DLog(@"%@", payload);

    NSDictionary *tag = (NSDictionary*)userdata;
    NSString *action  = [tag objectForKey:@"action"];

    if ([action isEqualToString:@"createUser"])
    {
        // ...
        [self finishCreateCaptureUser:@"ok"];
    }
}

- (void)connectionDidFinishLoadingWithFullResponse:(NSURLResponse*)fullResponse
                                  unencodedPayload:(NSData*)payload
                                           request:(NSURLRequest*)request
                                            andTag:(NSObject*)userdata
{

}

- (void)connectionDidFailWithError:(NSError*)error request:(NSURLRequest*)request andTag:(NSObject*)userdata
{
    DLog(@"");

    NSDictionary *tag = (NSDictionary*)userdata;
    NSString *action  = [tag objectForKey:@"action"];

    if ([action isEqualToString:@"createUser"])
    {
        // ...
        [self finishCreateCaptureUser:@"fail"];
    }
}

- (void)connectionWasStoppedWithTag:(NSObject*)userdata { }

- (void)dealloc
{
    [captureInterfaceDelegate release];
//    [acceptableAttributes release];
    [captureUser release];
    [captureCreationToken release];
    [super dealloc];
}

@end
