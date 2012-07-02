/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


#import "JRCaptureObject+Internal.h"
#import "JRPinoLevelTwo.h"

@interface JRPinoLevelThreeElement (PinoLevelThreeElementInternalMethods)
+ (id)pinoLevelThreeElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToPinoLevelThreeElement:(JRPinoLevelThreeElement *)otherPinoLevelThreeElement;
@end

@interface NSArray (PinoLevelThreeToFromDictionary)
- (NSArray*)arrayOfPinoLevelThreeElementsFromPinoLevelThreeDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder;
- (NSArray*)arrayOfPinoLevelThreeDictionariesFromPinoLevelThreeElementsForEncoder:(BOOL)forEncoder;
- (NSArray*)arrayOfPinoLevelThreeReplaceDictionariesFromPinoLevelThreeElements;
@end

@implementation NSArray (PinoLevelThreeToFromDictionary)
- (NSArray*)arrayOfPinoLevelThreeElementsFromPinoLevelThreeDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredPinoLevelThreeArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPinoLevelThreeArray addObject:[JRPinoLevelThreeElement pinoLevelThreeElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredPinoLevelThreeArray;
}

- (NSArray*)arrayOfPinoLevelThreeDictionariesFromPinoLevelThreeElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinoLevelThreeElement class]])
            [filteredDictionaryArray addObject:[(JRPinoLevelThreeElement*)object toDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPinoLevelThreeReplaceDictionariesFromPinoLevelThreeElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinoLevelThreeElement class]])
            [filteredDictionaryArray addObject:[(JRPinoLevelThreeElement*)object toReplaceDictionaryIncludingArrays:YES]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (PinoLevelTwo_ArrayComparison)
- (BOOL)isEqualToPinoLevelThreeArray:(NSArray *)otherArray;
@end

@implementation NSArray (PinoLevelTwo_ArrayComparison)

- (BOOL)isEqualToPinoLevelThreeArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRPinoLevelThreeElement *)[self objectAtIndex:i]) isEqualToPinoLevelThreeElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}
@end

@interface JRPinoLevelTwo ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRPinoLevelTwo
{
    NSString *_level;
    NSString *_name;
    NSArray *_pinoLevelThree;
}
@synthesize canBeUpdatedOrReplaced;

- (NSString *)level
{
    return _level;
}

- (void)setLevel:(NSString *)newLevel
{
    [self.dirtyPropertySet addObject:@"level"];

    [_level autorelease];
    _level = [newLevel copy];
}

- (NSString *)name
{
    return _name;
}

- (void)setName:(NSString *)newName
{
    [self.dirtyPropertySet addObject:@"name"];

    [_name autorelease];
    _name = [newName copy];
}

- (NSArray *)pinoLevelThree
{
    return _pinoLevelThree;
}

- (void)setPinoLevelThree:(NSArray *)newPinoLevelThree
{
    [_pinoLevelThree autorelease];
    _pinoLevelThree = [newPinoLevelThree copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/pinoLevelOne/pinoLevelTwo";
        self.canBeUpdatedOrReplaced = YES;


        [self.dirtyPropertySet setSet:[NSMutableSet setWithObjects:@"level", @"name", nil]];
    }
    return self;
}

+ (id)pinoLevelTwo
{
    return [[[JRPinoLevelTwo alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPinoLevelTwo *pinoLevelTwoCopy = (JRPinoLevelTwo *)[super copyWithZone:zone];

    pinoLevelTwoCopy.level = self.level;
    pinoLevelTwoCopy.name = self.name;
    pinoLevelTwoCopy.pinoLevelThree = self.pinoLevelThree;

    return pinoLevelTwoCopy;
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.level ? self.level : [NSNull null])
                   forKey:@"level"];
    [dictionary setObject:(self.name ? self.name : [NSNull null])
                   forKey:@"name"];
    [dictionary setObject:(self.pinoLevelThree ? [self.pinoLevelThree arrayOfPinoLevelThreeDictionariesFromPinoLevelThreeElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"pinoLevelThree"];

    if (forEncoder)
    {
        [dictionary setObject:[self.dirtyPropertySet allObjects] forKey:@"dirtyPropertySet"];
        [dictionary setObject:self.captureObjectPath forKey:@"captureObjectPath"];
        [dictionary setObject:[NSNumber numberWithBool:self.canBeUpdatedOrReplaced] forKey:@"canBeUpdatedOrReplaced"];
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

+ (id)pinoLevelTwoObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRPinoLevelTwo *pinoLevelTwo = [JRPinoLevelTwo pinoLevelTwo];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        pinoLevelTwo.captureObjectPath      = [dictionary objectForKey:@"captureObjectPath"];
    }

    pinoLevelTwo.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    pinoLevelTwo.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    pinoLevelTwo.pinoLevelThree =
        [dictionary objectForKey:@"pinoLevelThree"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinoLevelThree"] arrayOfPinoLevelThreeElementsFromPinoLevelThreeDictionariesWithPath:pinoLevelTwo.captureObjectPath fromDecoder:fromDecoder] : nil;

    if (fromDecoder)
        [pinoLevelTwo.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [pinoLevelTwo.dirtyPropertySet removeAllObjects];
    
    return pinoLevelTwo;
}

+ (id)pinoLevelTwoObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRPinoLevelTwo pinoLevelTwoObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;

    if ([dictionary objectForKey:@"level"])
        self.level = [dictionary objectForKey:@"level"] != [NSNull null] ? 
            [dictionary objectForKey:@"level"] : nil;

    if ([dictionary objectForKey:@"name"])
        self.name = [dictionary objectForKey:@"name"] != [NSNull null] ? 
            [dictionary objectForKey:@"name"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;

    self.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    self.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    self.pinoLevelThree =
        [dictionary objectForKey:@"pinoLevelThree"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinoLevelThree"] arrayOfPinoLevelThreeElementsFromPinoLevelThreeDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"level"])
        [dictionary setObject:(self.level ? self.level : [NSNull null]) forKey:@"level"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dictionary setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)toReplaceDictionaryIncludingArrays:(BOOL)includingArrays
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.level ? self.level : [NSNull null]) forKey:@"level"];
    [dictionary setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    if (includingArrays)
        [dictionary setObject:(self.pinoLevelThree ?
                          [self.pinoLevelThree arrayOfPinoLevelThreeReplaceDictionariesFromPinoLevelThreeElements] :
                          [NSArray array])
                       forKey:@"pinoLevelThree"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)replacePinoLevelThreeArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pinoLevelThree named:@"pinoLevelThree" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToPinoLevelTwo:(JRPinoLevelTwo *)otherPinoLevelTwo
{
    if (!self.level && !otherPinoLevelTwo.level) /* Keep going... */;
    else if ((self.level == nil) ^ (otherPinoLevelTwo.level == nil)) return NO; // xor
    else if (![self.level isEqualToString:otherPinoLevelTwo.level]) return NO;

    if (!self.name && !otherPinoLevelTwo.name) /* Keep going... */;
    else if ((self.name == nil) ^ (otherPinoLevelTwo.name == nil)) return NO; // xor
    else if (![self.name isEqualToString:otherPinoLevelTwo.name]) return NO;

    if (!self.pinoLevelThree && !otherPinoLevelTwo.pinoLevelThree) /* Keep going... */;
    else if (!self.pinoLevelThree && ![otherPinoLevelTwo.pinoLevelThree count]) /* Keep going... */;
    else if (!otherPinoLevelTwo.pinoLevelThree && ![self.pinoLevelThree count]) /* Keep going... */;
    else if (![self.pinoLevelThree isEqualToPinoLevelThreeArray:otherPinoLevelTwo.pinoLevelThree]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"level"];
    [dictionary setObject:@"NSString" forKey:@"name"];
    [dictionary setObject:@"NSArray" forKey:@"pinoLevelThree"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_level release];
    [_name release];
    [_pinoLevelThree release];

    [super dealloc];
}
@end
