//
//  FontLabelStringDrawing.m
//  FontLabel
//
//  Created by Kevin Ballard on 5/5/09.
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

#import "FontLabelStringDrawing.h"

// read the cmap table from the font
// we only know how to understand some of the table formats at the moment
// if we don't know how to understand it, we use the magic number hack
static void mapCharactersToGlyphsInFont(CGFontRef font, size_t n, unichar characters[], CGGlyph outGlyphs[]) {
	CFDataRef cmapTable = CGFontCopyTableForTag(font, 'cmap');
	NSCAssert1(cmapTable != NULL, @"CGFontCopyTableForTag returned NULL for 'cmap' tag in font %@",
			   (font ? [(id)CFCopyDescription(font) autorelease] : @"(null)"));
	const UInt8 * const bytes = CFDataGetBytePtr(cmapTable);
	NSCAssert1(OSReadBigInt16(bytes, 0) == 0, @"cmap table for font %@ has bad version number",
			   (font ? [(id)CFCopyDescription(font) autorelease] : @"(null)"));
	UInt16 numberOfSubtables = OSReadBigInt16(bytes, 2);
	const UInt8 *unicodeSubtable = NULL;
	const UInt8 * const encodingSubtables = &bytes[4];
	for (UInt16 i = 0; i < numberOfSubtables; i++) {
		const UInt8 * const encodingSubtable = &encodingSubtables[8 * i];
		UInt16 platformID = OSReadBigInt16(encodingSubtable, 0);
		UInt16 platformSpecificID = OSReadBigInt16(encodingSubtable, 2);
		if (platformID == 0) {
			if (platformSpecificID == 3 || unicodeSubtable == NULL) {
				UInt32 offset = OSReadBigInt32(encodingSubtable, 4);
				unicodeSubtable = &bytes[offset];
			}
		}
	}
	BOOL decoded = NO;
	if (unicodeSubtable != NULL) {
		UInt16 format = OSReadBigInt16(unicodeSubtable, 0);
		if (format == 4) {
			// subtable format 4
			decoded = YES;
			//UInt16 length = OSReadBigInt16(unicodeSubtable, 2);
			//UInt16 language = OSReadBigInt16(unicodeSubtable, 4);
			UInt16 segCountX2 = OSReadBigInt16(unicodeSubtable, 6);
			//UInt16 searchRange = OSReadBigInt16(unicodeSubtable, 8);
			//UInt16 entrySelector = OSReadBigInt16(unicodeSubtable, 10);
			//UInt16 rangeShift = OSReadBigInt16(unicodeSubtable, 12);
			UInt16 *endCodes = (UInt16*)&unicodeSubtable[14];
			UInt16 *startCodes = (UInt16*)&((UInt8*)endCodes)[segCountX2+2];
			UInt16 *idDeltas = (UInt16*)&((UInt8*)startCodes)[segCountX2];
			UInt16 *idRangeOffsets = (UInt16*)&((UInt8*)idDeltas)[segCountX2];
			//UInt16 *glyphIndexArray = &idRangeOffsets[segCountX2];
			
			for (int i = 0; i < n; i++) {
				unichar c = characters[i];
				UInt16 segOffset;
				BOOL foundSegment = NO;
				for (segOffset = 0; segOffset < segCountX2; segOffset += 2) {
					UInt16 endCode = OSReadBigInt16(endCodes, segOffset);
					if (endCode >= c) {
						foundSegment = YES;
						break;
					}
				}
				if (!foundSegment) {
					// no segment
					// this is an invalid font
					outGlyphs[i] = 0;
				} else {
					UInt16 startCode = OSReadBigInt16(startCodes, segOffset);
					if (!(startCode <= c)) {
						// the code falls in a hole between segments
						outGlyphs[i] = 0;
					} else {
						UInt16 idRangeOffset = OSReadBigInt16(idRangeOffsets, segOffset);
						if (idRangeOffset == 0) {
							UInt16 idDelta = OSReadBigInt16(idDeltas, segOffset);
							outGlyphs[i] = (c + idDelta) % 65536;
						} else {
							// use the glyphIndexArray
							UInt16 glyphOffset = idRangeOffset + 2 * (c - startCode);
							outGlyphs[i] = OSReadBigInt16(&((UInt8*)idRangeOffsets)[segOffset], glyphOffset);
						}
					}
				}
			}
		}
	}
	if (!decoded) {
		for (int i = 0; i < n; i++) { 
			// 29 is some weird magic number that works for lots of fonts
			outGlyphs[i] = characters[i] - 29;
		}
	}
	CFRelease(cmapTable);
}

static CGSize mapGlyphsToAdvancesInFont(CGFontRef font, CGFloat pointSize, size_t n,
										CGGlyph glyphs[], int outAdvances[], CGFloat *outAscender) {
	CGSize retVal = CGSizeZero;
	if (CGFontGetGlyphAdvances(font, glyphs, n, outAdvances)) {
		int width = 0;
		for (int i = 0; i < n; i++) {
			width += outAdvances[i];
		}
		
		CGFloat ratio = (pointSize/CGFontGetUnitsPerEm(font));
		CGFloat ascender = ceilf(CGFontGetAscent(font) * ratio);
		
		retVal.width = width*ratio;
		retVal.height = ceilf(CGFontGetAscent(font) * ratio) - floorf(CGFontGetDescent(font) * ratio);
		if (outAscender != NULL) *outAscender = ascender;
	} else if (outAscender != NULL) {
		*outAscender = 0.0f;
	}
	return retVal;
}

@implementation NSString (FontLabelStringDrawing)
- (CGSize)sizeWithCGFont:(CGFontRef)font pointSize:(CGFloat)pointSize {
	// Create an array of Glyph's the size of text that will be drawn. 
	CGGlyph glyphs[[self length]];
	
	// Map the characters to glyphs
	unichar characters[[self length]];
	[self getCharacters:characters];
	mapCharactersToGlyphsInFont(font, [self length], characters, glyphs);
	
	// Get the advances for the glyphs
	int advances[[self length]];
	CGSize retVal = mapGlyphsToAdvancesInFont(font, pointSize, [self length], glyphs, advances, NULL);
	
	return CGSizeMake(ceilf(retVal.width), ceilf(retVal.height));
}

- (CGSize)drawAtPoint:(CGPoint)point withCGFont:(CGFontRef)font pointSize:(CGFloat)pointSize {
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextSetFont(ctx, font);
	CGContextSetFontSize(ctx, pointSize);
	
	CGGlyph glyphs[[self length]];
	
	// Map the characters to glyphs
	unichar characters[[self length]];
	[self getCharacters:characters];
	mapCharactersToGlyphsInFont(font, [self length], characters, glyphs);
	
	// Get the advances for the glyphs
	int advances[[self length]];
	CGFloat ascender;
	CGSize retVal = mapGlyphsToAdvancesInFont(font, pointSize, [self length], glyphs, advances, &ascender);
	
	// flip it upside-down because our 0,0 is upper-left, whereas ttfs are for screens where 0,0 is lower-left
	CGAffineTransform textTransform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
	CGContextSetTextMatrix(ctx, textTransform);
	
	CGContextSetTextDrawingMode(ctx, kCGTextFill);
	CGContextShowGlyphsAtPoint(ctx, point.x, point.y + ascender, glyphs, [self length]);
	return retVal;
}
@end
