//
//  SKType.h
//  SKSymbolKit
//
//  Created by Magic-Unique on 2022/9/14.
//

#ifndef SKType_h
#define SKType_h

#if TARGET_OS_OSX // MacOS

#define SK_TARGET_MAC   1
#import <AppKit/AppKit.h>
#define SKBezierPath    NSBezierPath
typedef NSColor SKColor;
typedef NSImageView SKImageView;

#elif (TARGET_OS_IPHONE || TARGET_OS_IPHONE) // iOS

#define SK_TARGET_IOS   1
#import <UIKit/UIKit.h>
#define SKBezierPath    UIBezierPath
typedef UIColor SKColor;
typedef UIImageView SKImageView;

#endif // System

#import <CoreGraphics/CoreGraphics.h>

#define SK_DOT_COUNT 6

typedef NSInteger SKInt;

NS_INLINE CGFloat   CGFloatFromSKInt(SKInt integer)         { return integer * 0.000001; }
NS_INLINE SKInt     SKIntFromCGFloat(CGFloat floatValue)    { return (SKInt)(floatValue * 1000000); }

typedef struct {
    SKInt x, y;
} SKPoint;

NS_INLINE SKPoint SKPointMake(SKInt x, SKInt y) {
    SKPoint point;
    point.x = x;
    point.y = y;
    return point;
}

NS_INLINE CGPoint CGPointFromSKPoint(SKPoint point) { return CGPointMake(CGFloatFromSKInt(point.x), CGFloatFromSKInt(point.y)); }
NS_INLINE SKPoint SKPointFromCGPoint(CGPoint point) { return SKPointMake(SKIntFromCGFloat(point.x), SKIntFromCGFloat(point.y)); }

typedef struct {
    SKInt width, height;
} SKSize;

NS_INLINE SKSize SKSizeMake(SKInt width, SKInt height) {
    SKSize size;
    size.width = width;
    size.height = height;
    return size;
}

NS_INLINE CGSize CGSizeFromSKSize(SKSize size) { return CGSizeMake(CGFloatFromSKInt(size.width), CGFloatFromSKInt(size.height)); }
NS_INLINE SKSize SKSizeFromCGSize(CGSize size) { return SKSizeMake(SKIntFromCGFloat(size.width), SKIntFromCGFloat(size.height)); }


typedef struct {
    SKPoint origin;
    SKSize size;
} SKRect;

NS_INLINE SKRect SKRectMake(SKInt x, SKInt y, SKInt width, SKInt height) {
    SKRect rect;
    rect.origin.x = x;
    rect.origin.y = y;
    rect.size.width = width;
    rect.size.height = height;
    return rect;
}

NS_INLINE CGRect CGRectFromSKRect(SKRect rect) {
    return CGRectMake(CGFloatFromSKInt(rect.origin.x),
                      CGFloatFromSKInt(rect.origin.y),
                      CGFloatFromSKInt(rect.size.width),
                      CGFloatFromSKInt(rect.size.height));
}

NS_INLINE CGAffineTransform CGAffineTransformFromStyle(NSString *style) {
    NSString *text = [style stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"matrix()"]];
    NSArray *list = [text componentsSeparatedByString:@" "];
    if (list.count != 6) {
        return CGAffineTransformIdentity;
    } else {
        CGFloat a = [list[0] doubleValue];
        CGFloat b = [list[1] doubleValue];
        CGFloat c = [list[2] doubleValue];
        CGFloat d = [list[3] doubleValue];
        CGFloat x = [list[4] doubleValue];
        CGFloat y = [list[5] doubleValue];
        return CGAffineTransformMake(a, b, c, d, x, y);
    }
}

typedef NSString *SKSymbolWeight;
typedef NSString *SKSymbolScale;

#endif /* SKType_h */
