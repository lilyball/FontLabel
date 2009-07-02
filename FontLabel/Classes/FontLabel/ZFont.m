//
//  ZFont.m
//  FontLabel
//
//  Created by Kevin Ballard on 7/2/09.
//  Copyright © 2009 Zynga Game Networks
//
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "ZFont.h"

@interface ZFont ()
@property (nonatomic, readonly) CGFloat ratio;
@end

@implementation ZFont
@synthesize cgFont=_cgFont, pointSize=_pointSize, ratio=_ratio;

+ (ZFont *)fontWithCGFont:(CGFontRef)cgFont size:(CGFloat)fontSize {
	return [[[self alloc] initWithCGFont:cgFont size:fontSize] autorelease];
}

- (id)initWithCGFont:(CGFontRef)cgFont size:(CGFloat)fontSize {
	if (self = [super init]) {
		_cgFont = CGFontRetain(cgFont);
		_pointSize = fontSize;
		_ratio = fontSize/CGFontGetUnitsPerEm(cgFont);
	}
	return self;
}

- (id)init {
	NSAssert(NO, @"-init is not valid for ZFont");
	return nil;
}

- (CGFloat)ascender {
	return ceilf(self.ratio * CGFontGetAscent(self.cgFont));
}

- (CGFloat)descender {
	return floorf(self.ratio * CGFontGetDescent(self.cgFont));
}

- (CGFloat)leading {
	return (self.ascender - self.descender);
}

- (CGFloat)capHeight {
	return ceilf(self.ratio * CGFontGetCapHeight(self.cgFont));
}

- (CGFloat)xHeight {
	return ceilf(self.ratio * CGFontGetXHeight(self.cgFont));
}

- (ZFont *)fontWithSize:(CGFloat)fontSize {
	if (fontSize == self.pointSize) return self;
	NSParameterAssert(fontSize > 0.0);
	return [[[ZFont alloc] initWithCGFont:self.cgFont size:fontSize] autorelease];
}

- (void)dealloc {
	CGFontRelease(_cgFont);
	[super dealloc];
}
@end
