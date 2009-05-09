//
//  FontManager.h
//  MafiaWars
//
//  Created by Kevin Ballard on 5/5/09.
//  Copyright 2009 Zynga. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FontManager : NSObject {
	CFMutableDictionaryRef fonts;
}
+ (id)sharedManager;
/*!
    @method     
    @abstract   Loads a TTF font from the main bundle
	@param filename The name of the font file to load (with no extension)
	@return YES if the font was loaded, NO if an error occurred
    @discussion If the font has already been loaded, this method does nothing and returns YES
*/
- (BOOL)loadFont:(NSString *)filename;
/*!
    @method     
    @abstract   Returns the loaded font with the given filename
	@param filename The name of the font file that was given to -loadFont:
	@return A CGFontRef, or NULL if the specified font was never loaded
*/
- (CGFontRef)fontWithName:(NSString *)filename;
@end
