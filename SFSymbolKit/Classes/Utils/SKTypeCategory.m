//
//  SKTypeCategory.m
//  SKSymbolKit
//
//  Created by Magic-Unique on 2022/9/14.
//

#import "SKTypeCategory.h"

@implementation SKBezierPath (SKSymbolKit)

- (void)sf_addPath:(SKBezierPath *)path {
#if SK_TARGET_IOS
    [self appendPath:path];
#elif SK_TARGET_MAC
    [self appendBezierPath:path];
#endif
}

- (void)sf_addLineToPoint:(CGPoint)point {
#if SK_TARGET_IOS
    [self addLineToPoint:point];
#elif SK_TARGET_MAC
    [self lineToPoint:point];
#endif
}

- (void)sf_addCurveToPoint:(CGPoint)point controlPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2 {
#if SK_TARGET_IOS
    [self addCurveToPoint:point controlPoint1:controlPoint1 controlPoint2:controlPoint2];
#elif SK_TARGET_MAC
    [self curveToPoint:point controlPoint1:controlPoint1 controlPoint2:controlPoint2];
#endif
}

- (void)sf_addRect:(CGRect)rect { //C 83.252 3.4668 84.7168 2.00195 84.7168 0.146484
#if SK_TARGET_IOS
    [self appendPath:[SKBezierPath bezierPathWithRect:rect]];
#elif SK_TARGET_MAC
    [self appendBezierPathWithRect:rect];
#endif
}

- (void)sf_addOvalInRect:(CGRect)rect {
#if SK_TARGET_IOS
    [self appendPath:[SKBezierPath bezierPathWithOvalInRect:rect]];
#elif SK_TARGET_MAC
    [self appendBezierPathWithOvalInRect:rect];
#endif
}

- (void)sf_applyTransform:(CGAffineTransform)transform {
#if SK_TARGET_IOS
    [self applyTransform:transform];
#elif SK_TARGET_MAC
    NSAffineTransformStruct _struct;
    _struct.m11 = transform.a;
    _struct.m12 = transform.b;
    _struct.m21 = transform.c;
    _struct.m22 = transform.d;
    _struct.tX = transform.tx;
    _struct.tY = transform.ty;
    NSAffineTransform *nsTransform = [NSAffineTransform transform];
    nsTransform.transformStruct = _struct;
    [self transformUsingAffineTransform:nsTransform];
#endif
}

@end

SKColor *SKColorWithSyle(NSString *style) {
    if (!style) {
        return nil;
    }
    style = style.lowercaseString;
    style = [style stringByReplacingOccurrencesOfString:@"#" withString:@""];
    style = [style stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    const char *cstr = style.UTF8String;
#define SK_VALUE_IN(index) ({ \
    char c = cstr[index]; \
    int t = 0; \
    if (c >= 'a' && c <= 'f') t = c - 'a' + 10; \
    else if (c >= '0' && c <= '9') t = c - '0'; \
    else t = 0; \
    t; \
})
#define SK_COLOR_RGBA(r, g, b, a) [SKColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0]
    if (style.length == 3) {
        // RGB
        int r = SK_VALUE_IN(0); r = (r << 4) + r;
        int g = SK_VALUE_IN(1); g = (g << 4) + g;
        int b = SK_VALUE_IN(2); b = (b << 4) + b;
        return SK_COLOR_RGBA(r, g, b, 0xFF);
    }
    else if (style.length == 4) {
        // ARGB
        int a = SK_VALUE_IN(0); a = (a << 4) + a;
        int r = SK_VALUE_IN(1); r = (r << 4) + r;
        int g = SK_VALUE_IN(2); g = (g << 4) + g;
        int b = SK_VALUE_IN(3); b = (b << 4) + b;
        return SK_COLOR_RGBA(r, g, b, a);
    }
    else if (style.length == 6) {
        // RRGGBB
        int r = (SK_VALUE_IN(0) << 4) + SK_VALUE_IN(1);
        int g = (SK_VALUE_IN(2) << 4) + SK_VALUE_IN(3);
        int b = (SK_VALUE_IN(4) << 4) + SK_VALUE_IN(5);
        return SK_COLOR_RGBA(r, g, b, 0xFF);
    }
    else if (style.length == 8) {
        // AARRGGBB
        int a = (SK_VALUE_IN(0) << 4) + SK_VALUE_IN(1);
        int r = (SK_VALUE_IN(2) << 4) + SK_VALUE_IN(3);
        int g = (SK_VALUE_IN(4) << 4) + SK_VALUE_IN(5);
        int b = (SK_VALUE_IN(6) << 4) + SK_VALUE_IN(7);
        return SK_COLOR_RGBA(r, g, b, a);
    }
#undef SK_VALUE_IN
#undef SK_COLOR_RGBA
    return nil;
}

SKInt SKIntFromString(NSString *string) {
    NSString *intStr = string;
    NSArray *list = [intStr componentsSeparatedByString:@"."];
    if (list.count == 1) {
        for (NSUInteger i = 0; i < SK_DOT_COUNT; i++) {
            intStr = [intStr stringByAppendingString:@"0"];
        }
    }
    else if (list.count == 2) {
        NSString *before = list.firstObject;
        NSString *after = list.lastObject;
        while (after.length < SK_DOT_COUNT) {
            after = [after stringByAppendingString:@"0"];
        }
        intStr = [before stringByAppendingString:after];
    }
    else {
        // Error
    }
    return (SKInt)intStr.integerValue;
}

NSCharacterSet *SKNumberCharacterSet() { return [NSCharacterSet characterSetWithCharactersInString:@"0123456789.-"]; }
NSCharacterSet *SKSeparatorCharacterSet() { return [NSCharacterSet characterSetWithCharactersInString:@"MLHVCSQTAZ "]; }

NSMutableArray<NSString *> *SKSplitD(NSString *d) {
    d = [d stringByReplacingOccurrencesOfString:@"-" withString:@" -"];
    NSMutableArray *list = [NSMutableArray array];
    NSCharacterSet *separatorSet = SKSeparatorCharacterSet();
    NSCharacterSet *numberSet = SKNumberCharacterSet();
    const char *D = d.UTF8String;
    NSUInteger index = 0;
    NSRange lastRange = NSMakeRange(0, 0);
    while (index < strlen(D)) {
        unichar c = D[index];
        if ([separatorSet characterIsMember:c]) {
            [list addObject:[d substringWithRange:lastRange]];
            [list addObject:[d substringWithRange:NSMakeRange(index, 1)]];
            index++;
            lastRange.location = index;
            lastRange.length = 0;
        }
        else if ([numberSet characterIsMember:c]) {
            index++;
            lastRange.length++;
        }
        else {
            assert(0);
        }
    }
    if (lastRange.length) {
        [list addObject:[d substringWithRange:lastRange]];
    }
    [list removeObject:@""];
    [list removeObject:@" "];
    [list removeObject:@"-"];
    return list;
}

id SKMutableArrayDrop(NSMutableArray *array) {
    if (array.count > 0) {
        id obj = array.firstObject;
        [array removeObjectAtIndex:0];
        return obj;
    }
    return nil;
}


SKSymbolWeight const SKSymbolWeightBlack = @"Black";
SKSymbolWeight const SKSymbolWeightHeavy = @"Heavy";
SKSymbolWeight const SKSymbolWeightBold = @"Bold";
SKSymbolWeight const SKSymbolWeightSemibold = @"Semibold";
SKSymbolWeight const SKSymbolWeightMedium = @"Medium";
SKSymbolWeight const SKSymbolWeightRegular = @"Regular";
SKSymbolWeight const SKSymbolWeightLight = @"Light";
SKSymbolWeight const SKSymbolWeightThin = @"Thin";
SKSymbolWeight const SKSymbolWeightUltralight = @"Ultralight";

SKSymbolScale const SKSymbolScaleSmall = @"S";
SKSymbolScale const SKSymbolScaleMedium = @"M";
SKSymbolScale const SKSymbolScaleLarge = @"L";


CGFloat const SKTabBarSymbolPointSize = 25;
CGFloat const SKNavigationBarSymbolPointSize = 25;
CGFloat const SKToolBarSymbolPointSize = 25;
