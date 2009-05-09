//
//  FontManager.m
//  MafiaWars
//
//  Created by Kevin Ballard on 5/5/09.
//  Copyright 2009 Zynga Game Networks. All rights reserved.
//

#import "FontManager.h"

static FontManager *sharedFontManager = nil;

@implementation FontManager
+ (id)sharedManager {
	@synchronized(self) {
		if (sharedFontManager == nil) {
			sharedFontManager = [[self alloc] init];
		}
	}
	return sharedFontManager;
}

- (id)init {
	if (self = [super init]) {
		fonts = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
	}
	return self;
}

- (BOOL)loadFont:(NSString *)filename {
	NSString *fontPath = [[NSBundle mainBundle] pathForResource:filename ofType:@"ttf"];
	if (fontPath == nil) {
		fontPath = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
	}
	if (fontPath == nil) return NO;
	
	CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([fontPath fileSystemRepresentation]);
	if (fontDataProvider == NULL) return NO;
	CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider); 
	CGDataProviderRelease(fontDataProvider); 
	if (newFont == NULL) return NO;
	
	CFDictionarySetValue(fonts, filename, newFont);
	CGFontRelease(newFont);
	return YES;
}

- (CGFontRef)fontWithName:(NSString *)filename {
	return (CGFontRef)CFDictionaryGetValue(fonts, filename);
}

- (void)dealloc {
	CFRelease(fonts);
	[super dealloc];
}
@end
