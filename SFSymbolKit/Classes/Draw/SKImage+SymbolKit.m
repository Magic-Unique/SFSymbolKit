//
//  UIImage+SKSymbolKit.m
//  Pods
//
//  Created by Magic-Unique on 2022/9/22.
//

#import "SKImage+SymbolKit.h"
#import "SKSymbol.h"
#import "SKPath.h"
#import "SKTypeCategory.h"
#import "SKSymbolColor.h"
#import "SKSymbol.h"
#import "SKType.h"

// 16 17 18 19 22 24
// 19 25

#define CGSizeIsZero(size) (size.width == 0 && size.height == 0)

static SKImage *SKImageFromSymbolImage(SKSymbolImage *symbolImage, CGSize size) {
    BOOL customSize = NO;
    CGSize symbolSize = symbolImage.bounds.size;
    CGSize contextSize = symbolSize;
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (!CGSizeIsZero(size)) {
        customSize = YES;
        contextSize = size;
        transform = CGAffineTransformMakeTranslation((contextSize.width - symbolSize.width) * 0.5, (contextSize.height - symbolSize.height) * 0.5);
    }
    UIGraphicsBeginImageContextWithOptions(contextSize, NO, UIScreen.mainScreen.scale);
    for (SKAttributedPath *path in symbolImage.attributedPaths) {
        [path.fillColor setFill];
        SKBezierPath *bezierPath = [path.bezierPath copy];
        [bezierPath applyTransform:transform];
        [bezierPath fillWithBlendMode:path.blendMode alpha:1];
    }
    SKImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image imageWithRenderingMode:symbolImage.color.renderingMode];
}


@implementation SKSymbolImage (SKImage)

- (SKImage *)toImage {
    return SKImageFromSymbolImage(self, CGSizeZero);
}

- (SKImage *)toImageWithSize:(CGSize)size {
    return SKImageFromSymbolImage(self, size);
}

@end

#if SK_TARGET_IOS
@implementation UIImage (SKSymbolKit)
#elif SK_TARGET_MAC
@implementation NSImage (SKSymbolKit)
#endif

+ (instancetype)sk_imageNamed:(NSString *)name pointSize:(CGFloat)pointSize {
    return [self sk_imageNamed:name inBundle:nil pointSize:pointSize imageSize:CGSizeZero];
}

+ (instancetype)sk_imageNamed:(NSString *)name
                     inBundle:(NSBundle *)bundle
                    pointSize:(CGFloat)pointSize
                    imageSize:(CGSize)imageSize {
    SKSymbol *symbol = [SKSymbol symbolWithName:name inBundle:bundle ?: [NSBundle mainBundle]];
    if (!symbol) {
        return nil;
    }
    SKSymbolImage *symbolImage = [SKSymbolImage symbolImageWithSymbol:symbol];
    symbolImage.pointSize = pointSize;
    return [self sk_imageWithSymbolImage:symbolImage imageSize:imageSize];
}

+ (instancetype)sk_imageWithSymbolImage:(SKSymbolImage *)symbolImage imageSize:(CGSize)imageSize {
    return [symbolImage toImageWithSize:imageSize];
}

@end
