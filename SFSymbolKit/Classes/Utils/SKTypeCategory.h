//
//  SKTypeCategory.h
//  SKSymbolKit
//
//  Created by Magic-Unique on 2022/9/14.
//

#import <Foundation/Foundation.h>
#import "SKType.h"

@interface SKBezierPath (SKSymbolKit)

- (void)sf_addPath:(SKBezierPath *)path;
- (void)sf_addLineToPoint:(CGPoint)point;
- (void)sf_addCurveToPoint:(CGPoint)point controlPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2;
- (void)sf_addRect:(CGRect)rect;
- (void)sf_addOvalInRect:(CGRect)rect;
- (void)sf_applyTransform:(CGAffineTransform)transform;

@end

FOUNDATION_EXTERN SKColor *SKColorWithSyle(NSString *style);

FOUNDATION_EXTERN SKColor *SKColorApplyAlpha(SKColor *color, CGFloat alpha, SKColor *bgColor);

FOUNDATION_EXTERN SKInt SKIntFromString(NSString *string);

FOUNDATION_EXTERN NSMutableArray<NSString *> *SKSplitD(NSString *d);

FOUNDATION_EXTERN NSCharacterSet *SKNumberCharacterSet(void);
FOUNDATION_EXTERN NSCharacterSet *SKSeparatorCharacterSet(void);

FOUNDATION_EXTERN id SKMutableArrayDrop(NSMutableArray *array);


FOUNDATION_EXTERN SKSymbolWeight const SKSymbolWeightBlack;
FOUNDATION_EXTERN SKSymbolWeight const SKSymbolWeightHeavy;
FOUNDATION_EXTERN SKSymbolWeight const SKSymbolWeightBold;
FOUNDATION_EXTERN SKSymbolWeight const SKSymbolWeightSemibold;
FOUNDATION_EXTERN SKSymbolWeight const SKSymbolWeightMedium;
FOUNDATION_EXTERN SKSymbolWeight const SKSymbolWeightRegular;
FOUNDATION_EXTERN SKSymbolWeight const SKSymbolWeightLight;
FOUNDATION_EXTERN SKSymbolWeight const SKSymbolWeightThin;
FOUNDATION_EXTERN SKSymbolWeight const SKSymbolWeightUltralight;

FOUNDATION_EXTERN SKSymbolScale const SKSymbolScaleSmall;
FOUNDATION_EXTERN SKSymbolScale const SKSymbolScaleMedium;
FOUNDATION_EXTERN SKSymbolScale const SKSymbolScaleLarge;

CG_EXTERN CGFloat const SKTabBarSymbolPointSize;
CG_EXTERN CGFloat const SKNavigationBarSymbolPointSize;
CG_EXTERN CGFloat const SKToolBarSymbolPointSize;
