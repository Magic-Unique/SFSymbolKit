//
//  SKSymbolColor.h
//  Pods
//
//  Created by Magic-Unique on 2023/3/9.
//

#import <Foundation/Foundation.h>
#import "SKType.h"

@class SKClassStyle;

typedef NS_ENUM(NSUInteger, SKColorStyle) {
    /// Draw with black color for all path
    SKColorStyleMonochrome,
    /// Draw with single color, and light for secondery path
    SKColorStyleHierarchical,
    /// Draw with less than four colors for different level path
    SKColorStylePalette,
    /// Draw with default colors or a color for major path
    SKColorStyleMulticolor,
};

typedef NS_ENUM(NSUInteger, SKColorLevel) {
    SKColorLevelPrimary,
    SKColorLevelSecondary,
};

@interface SKSymbolColor : NSObject

@property (nonatomic, assign, readonly) SKColorStyle style;

@property (nonatomic, assign, readonly) BOOL isPaletteColor;

@property (nonatomic, assign, readonly) UIImageRenderingMode renderingMode;

- (SKColor *)colorWithLevel:(SKColorLevel)level classStyle:(SKClassStyle *)classStyle;

- (CGBlendMode)blendModeForClearBehind:(BOOL)clearBehind;

@end


@interface SKSymbolColor (Creation)
+ (instancetype)hierarchicalWithColor:(SKColor *)hierarchicalColor;
+ (instancetype)paletteWithColors:(NSArray<SKColor *> *)paletteColors;
+ (instancetype)multicolor;
+ (instancetype)monochrome;
@end


@interface SKSymbolColor (Level)
//@property (readonly) SKColor *primary;
//@property (readonly) SKColor *secondary;
@end


FOUNDATION_EXTERN NSString *const SKPaletteClassShortName;

FOUNDATION_EXTERN NSString *SKClassShortNameForStyle(SKColorStyle style);
