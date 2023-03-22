//
//  SKSymbolColor.m
//  Pods
//
//  Created by Magic-Unique on 2023/3/9.
//

#import "SKSymbolColor.h"
#import "SKStyle.h"

//SKColorStyleSingle,             ///< Default tint mode with first color
//SKColorStyleHierarchical,       ///< Hierarchial mode with first color
//SKColorStylePalette,            ///< Palette mode with colors
//SKColorStyleMulticolor,         ///< Multicolor mode without any color
//SKColorStyleMonochrome,         ///< Monochrome mode without any color

@interface SKSymbolColor ()

@property (nonatomic, strong) NSArray<SKColor *> *colors;

@end

@implementation SKSymbolColor

- (BOOL)isPaletteColor { return NO; }
- (UIImageRenderingMode)renderingMode { return UIImageRenderingModeAutomatic; }

- (SKColor *)colorWithLevel:(SKColorLevel)level classStyle:(SKClassStyle *)classStyle {
    if (level >= self.colors.count) {
        return self.colors.lastObject ?: [UIColor blackColor];
    } else {
        return self.colors[level];
    }
}

- (CGBlendMode)blendModeForClearBehind:(BOOL)clearBehind {
    if (clearBehind) {
        return kCGBlendModeClear;//kCGBlendModeSourceOut;
    } else {
        return kCGBlendModeNormal;
    }
}

@end

#pragma mark - Monochrome Color

// 不支持自定义颜色，统一黑色

@interface _SKMonochromeColor : SKSymbolColor
@end

@implementation _SKMonochromeColor
- (SKColorStyle)style { return SKColorStyleMonochrome; }
- (UIImageRenderingMode)renderingMode { return UIImageRenderingModeAutomatic; }

- (SKColor *)colorWithLevel:(SKColorLevel)level classStyle:(SKClassStyle *)classStyle {
    return self.colors.firstObject;
}

@end

#pragma mark - Hierarchical Color

// 传入 1 个颜色，渲染主路径，其余设置透明度 0.25

@interface _SKHierarchicalColor : SKSymbolColor @end @implementation _SKHierarchicalColor

- (SKColorStyle)style { return SKColorStyleHierarchical; }
- (UIImageRenderingMode)renderingMode { return UIImageRenderingModeAutomatic; }

- (instancetype)initWithColor:(SKColor *)color {
    self = [super init];
    if (self) {
        self.colors = @[color, [color colorWithAlphaComponent:0.25]];
    }
    return self;
}

- (CGBlendMode)blendModeForClearBehind:(BOOL)clearBehind {
    if (clearBehind) {
        return kCGBlendModeClear;//kCGBlendModeSourceOut;
    } else {
        return kCGBlendModeNormal;
    }
}

@end


#pragma mark - Palette Color

// 传入 3 个颜色，只用到前两个，主路径用第一个，其他用第二个

@interface _SKPaletteColor : SKSymbolColor @end @implementation _SKPaletteColor

- (BOOL)isPaletteColor { return YES; }
- (SKColorStyle)style { return SKColorStylePalette; }
- (UIImageRenderingMode)renderingMode { return UIImageRenderingModeAlwaysOriginal; }

- (instancetype)initWithColors:(NSArray<SKColor *> *)colors {
    self = [super init];
    if (self) {
        self.colors = colors;
    }
    return self;
}

@end

#pragma mark - Multicolor

// 传入 0 或者 1 个颜色，只改主内容路径，剩下使用 style

@interface _SKMultiColor : SKSymbolColor @end @implementation _SKMultiColor

- (SKColorStyle)style { return SKColorStyleMulticolor; }
- (UIImageRenderingMode)renderingMode { return UIImageRenderingModeAlwaysOriginal; }

- (instancetype)initWithColor:(SKColor *)color {
    self = [super init];
    if (self) {
        self.colors = @[color];
    }
    return self;
}

- (SKColor *)colorWithLevel:(SKColorLevel)level classStyle:(SKClassStyle *)classStyle {
    return classStyle.fill;
}

@end


@implementation SKSymbolColor (Creation)

+ (instancetype)hierarchicalWithColor:(SKColor *)hierarchicalColor {
    NSParameterAssert(hierarchicalColor);
    return [[_SKHierarchicalColor alloc] initWithColor:hierarchicalColor];
}

+ (instancetype)paletteWithColors:(NSArray<SKColor *> *)paletteColors {
    NSParameterAssert(paletteColors);
    return [[_SKPaletteColor alloc] initWithColors:paletteColors];
}

+ (instancetype)multicolor {
    return [[_SKMultiColor alloc] init];
}

+ (instancetype)monochrome {
    return [[_SKMonochromeColor alloc] init];
}
@end


@implementation SKSymbolColor (Level)
- (SKColor *)primary { return [self colorWithLevel:SKColorLevelPrimary classStyle:nil]; }
- (SKColor *)secondary { return [self colorWithLevel:SKColorLevelSecondary classStyle:nil]; }
@end

NSString *const SKPaletteClassShortName = @".palette";

NSString *SKClassShortNameForStyle(SKColorStyle style) {
    switch (style) {
        case SKColorStyleHierarchical:  return @"hierarchical";
        case SKColorStylePalette:       return SKPaletteClassShortName;
        case SKColorStyleMulticolor:    return @"multicolor";
        case SKColorStyleMonochrome:    return @"monochrome";
        default:                        return nil;
    }
}

