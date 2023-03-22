//
//  UIImage+SKSymbolKit.h
//  Pods
//
//  Created by Magic-Unique on 2022/9/22.
//

#import "SKType.h"

#if SK_TARGET_IOS
#import <UIKit/UIKit.h>
typedef UIImage SKImage;
#elif SK_TARGET_MAC
#import <AppKit/AppKit.h>
typedef NSImage SKImage;
#endif

#import "SKSymbolImage.h"

@interface SKSymbolImage (SKImage)

- (SKImage *)toImage;
- (SKImage *)toImageWithSize:(CGSize)size;

@end

#if SK_TARGET_IOS
@interface UIImage (SKSymbolKit)
#elif SK_TARGET_MAC
@interface NSImage (SKSymbolKit)
#endif

+ (instancetype)sk_imageNamed:(NSString *)name pointSize:(CGFloat)pointSize;

+ (instancetype)sk_imageNamed:(NSString *)name inBundle:(NSBundle *)bundle pointSize:(CGFloat)pointSize imageSize:(CGSize)imageSize;

+ (instancetype)sk_imageWithSymbolImage:(SKSymbolImage *)symbolImage imageSize:(CGSize)imageSize;

@end
