//
//  ZAttributedStringTest.m
//  FontLabel
//
//  Created by Kevin Ballard on 9/26/09.
//  Copyright 2009 Zynga Game Networks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SenTestingKit/SenTestingKit.h>
#import "ZAttributedString.h"

@interface ZAttributedStringTest : SenTestCase
@end

@implementation ZAttributedStringTest
- (void)testInitWithString {
	ZAttributedString *str = [[[ZAttributedString alloc] initWithString:@"test"] autorelease];
	STAssertEqualObjects(str.string, @"test", @"-initWithString preserves the string");
	STAssertEquals(str.length, (NSUInteger)4, @"string length == 4");
	NSDictionary *attrs = [str attributesAtIndex:0 effectiveRange:NULL];
	STAssertEqualObjects(attrs, [NSDictionary dictionary], @"-initWithString sets an empty dictionary for attributes");
}

- (void)testInitWithAttributedString {
	ZAttributedString *str = [[[ZAttributedString alloc] initWithString:@"test"] autorelease];
	STAssertEqualObjects(str, [[[ZAttributedString alloc] initWithAttributedString:str] autorelease], @"- -initWithAttributedString should return an equal object");
}

- (void)testInitWithAttributedStringAttributes {
	NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
							  @"foo", @"mykey",
							  [UIColor redColor], ZForegroundColorAttributeName,
							  nil];
	ZAttributedString *str = [[[ZAttributedString alloc] initWithString:@"test" attributes:attrDict] autorelease];
	NSRange range;
	NSDictionary *attrs = [str attributesAtIndex:0 effectiveRange:&range];
	STAssertEqualObjects(attrs, attrDict, @"");
	STAssertEquals(range, NSMakeRange(0, 4), @"");
}

- (void)testDescription {
	ZAttributedString *str = [[[ZAttributedString alloc] initWithString:@"test"] autorelease];
	STAssertEqualObjects([str description], @"{} \"test\"", @"");
}

- (void)testAttributesAtIndex {
	ZAttributedString *str = [[[ZAttributedString alloc] initWithString:@"test"] autorelease];
	NSRange range;
	NSDictionary *attrs = [str attributesAtIndex:0 effectiveRange:&range];
	STAssertEqualObjects(attrs, [NSDictionary dictionary], @"attributes is an empty dictionary");
	STAssertEquals(range, NSMakeRange(0, 4), @"expected range is {0, 4}, was %@", NSStringFromRange(range));
}

- (void)testAttributesAtIndexLongestEffectiveRangeTruncation {
	ZAttributedString *str = [[[ZAttributedString alloc] initWithString:@"testing"] autorelease];
	NSRange range;
	[str attributesAtIndex:4 longestEffectiveRange:&range inRange:NSMakeRange(2,4)];
	STAssertEquals(range, NSMakeRange(2, 4), @"");
}

- (void)testAttributeAtIndex {
	ZAttributedString *str = [[[ZAttributedString alloc] initWithString:@"testing" attributes:[NSDictionary dictionaryWithObject:@"foo" forKey:@"bar"]] autorelease];
	NSRange range;
	id foo = [str attribute:@"bar" atIndex:4 longestEffectiveRange:&range inRange:NSMakeRange(2, 4)];
	STAssertEqualObjects(foo, @"foo", @"");
	STAssertEquals(range, NSMakeRange(2, 4), @"");
	foo = [str attribute:@"blah" atIndex:4 longestEffectiveRange:&range inRange:NSMakeRange(2, 4)];
	STAssertNil(foo, @"");
	STAssertEquals(range, NSMakeRange(2, 4), @"");
	foo = [str attribute:@"bar" atIndex:4 effectiveRange:&range];
	STAssertEqualObjects(foo, @"foo", @"");
	STAssertEquals(range, NSMakeRange(0, 7), @"");
	foo = [str attribute:@"blah" atIndex:4 effectiveRange:&range];
	STAssertNil(foo, @"");
	STAssertEquals(range, NSMakeRange(0, 7), @"");
}

//- (void)testAttributedSubstring {
//	ZAttributedString *str = [[[ZAttributedString alloc] initWithString:@"testing"] autorelease];
//	//ZAttributedString *substr = [str attributedSubstringFromRange:NSMakeRange(2, 4)];
//	//STAssertEqualObjects(substr.string, @"stin", @"");
//}

- (void)testMutableCopy {
	ZAttributedString *str = [[[ZAttributedString alloc] initWithString:@"test"] autorelease];
	STAssertTrue([[[str mutableCopy] autorelease] isKindOfClass:[ZMutableAttributedString class]],
				 @"expected ZMutableAttributedString, was %@", NSStringFromClass([str class]));
}
@end
