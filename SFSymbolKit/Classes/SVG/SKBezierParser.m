//
//  SKBezierParser.m
//  Pods
//
//  Created by Magic-Unique on 2022/9/16.
//

#import "SKBezierParser.h"
#import "SKTypeCategory.h"

typedef unichar SKOpr;

@interface SKBezierParser ()
{
    SKOpr lastOpr;
    SKPoint lastQPoint;
    SKPoint lastCPoint;
}


@end

@implementation SKBezierParser

- (BOOL)parse {
    SKBezierPath *bezierPath = [SKBezierPath bezierPath];
    [self __bezierPath:bezierPath appendPath:self.d];
    _path = bezierPath;
    return YES;
}

- (void)__bezierPath:(SKBezierPath *)bezierPath appendPath:(NSString *)path {
    NSMutableArray *oprs = SKSplitD(path);
    while (oprs.count) {
        NSString *item = SKMutableArrayDrop(oprs);
        SKOpr opr = item.UTF8String[0];
        switch (opr) {
            case 'M': [self __bezierPath:bezierPath M:oprs]; break;
            case 'L': [self __bezierPath:bezierPath L:oprs]; break;
            case 'H': [self __bezierPath:bezierPath H:oprs]; break;
            case 'V': [self __bezierPath:bezierPath V:oprs]; break;
            case 'C': [self __bezierPath:bezierPath C:oprs]; break;
            case 'S': [self __bezierPath:bezierPath S:oprs]; break;
//            case 'Q': [self __bezierPath:bezierPath Q:oprs]; break;
//            case 'T': [self __bezierPath:bezierPath T:oprs]; break;
//            case 'A': [self __bezierPath:bezierPath A:oprs]; break;
            case 'Z': [self __bezierPath:bezierPath Z:oprs]; break;
            default:
                NSAssert(NO, @"Unknow operation set");
                break;
        }
        lastOpr = opr;
    }
}

- (void)__bezierPath:(SKBezierPath *)bezierPath M:(NSMutableArray *)numbers {
    NSAssert(numbers.count >= 2, @"Can not move to point with %@", numbers);
    SKInt x = SKIntFromString(SKMutableArrayDrop(numbers));
    SKInt y = SKIntFromString(SKMutableArrayDrop(numbers));
    [bezierPath moveToPoint:CGPointFromSKPoint(SKPointMake(x, y))];
}

- (void)__bezierPath:(SKBezierPath *)bezierPath L:(NSMutableArray *)numbers {
    NSAssert(numbers.count >= 2, @"Can not line to point with %@", numbers);
    SKInt x = SKIntFromString(SKMutableArrayDrop(numbers));
    SKInt y = SKIntFromString(SKMutableArrayDrop(numbers));
    [bezierPath sf_addLineToPoint:CGPointFromSKPoint(SKPointMake(x, y))];
}

- (void)__bezierPath:(SKBezierPath *)bezierPath H:(NSMutableArray *)numbers {
    NSAssert(numbers.count >= 1, @"Can not lineH to point with %@", numbers);
    CGPoint crt = bezierPath.currentPoint;
    SKInt y = SKIntFromString(SKMutableArrayDrop(numbers));
    crt.y = CGFloatFromSKInt(y);
    [bezierPath sf_addLineToPoint:crt];
}

- (void)__bezierPath:(SKBezierPath *)bezierPath V:(NSMutableArray *)numbers {
    NSAssert(numbers.count >= 1, @"Can not lineV to point with %@", numbers);
    CGPoint crt = bezierPath.currentPoint;
    SKInt x = SKIntFromString(SKMutableArrayDrop(numbers));
    crt.x = CGFloatFromSKInt(x);
    [bezierPath sf_addLineToPoint:crt];
}

- (void)__bezierPath:(SKBezierPath *)bezierPath C:(NSMutableArray *)numbers {
    NSAssert(numbers.count >= 6, @"Can not line to point with %@", numbers);
    SKInt x1 = SKIntFromString(SKMutableArrayDrop(numbers));
    SKInt y1 = SKIntFromString(SKMutableArrayDrop(numbers));
    SKInt x2 = SKIntFromString(SKMutableArrayDrop(numbers));
    SKInt y2 = SKIntFromString(SKMutableArrayDrop(numbers));
    SKInt x  = SKIntFromString(SKMutableArrayDrop(numbers));
    SKInt y  = SKIntFromString(SKMutableArrayDrop(numbers));
    [bezierPath sf_addCurveToPoint:CGPointFromSKPoint(SKPointMake(x, y))
                     controlPoint1:CGPointFromSKPoint(SKPointMake(x1, y1))
                     controlPoint2:CGPointFromSKPoint(SKPointMake(x2, y2))];
    lastCPoint.x = x2;
    lastCPoint.y = y2;
}

- (void)__bezierPath:(SKBezierPath *)bezierPath S:(NSMutableArray *)numbers {
    NSAssert(numbers.count >= 4, @"Can not line to point with %@", numbers);
    SKInt x2 = SKIntFromString(SKMutableArrayDrop(numbers));
    SKInt y2 = SKIntFromString(SKMutableArrayDrop(numbers));
    SKInt x  = SKIntFromString(SKMutableArrayDrop(numbers));
    SKInt y  = SKIntFromString(SKMutableArrayDrop(numbers));
    CGPoint current = bezierPath.currentPoint;
//    if (lastOpr == 'C' || lastOpr == 'S') {
//        current.x = lastCPoint.x - current.x;
//        current.y = lastCPoint.y - current.y;
//    }
    [bezierPath sf_addCurveToPoint:CGPointFromSKPoint(SKPointMake(x, y))
                     controlPoint1:current
                     controlPoint2:CGPointFromSKPoint(SKPointMake(x2, y2))];
    lastCPoint.x = x2;
    lastCPoint.y = y2;
}

- (void)__bezierPath:(SKBezierPath *)bezierPath Q:(NSMutableArray *)numbers {
    NSAssert(numbers.count >= 4, @"Can not line to point with %@", numbers);
//    SKInt x1 = SKIntFromString(SKMutableArrayDrop(numbers));
//    SKInt y1 = SKIntFromString(SKMutableArrayDrop(numbers));
//    SKInt x  = SKIntFromString(SKMutableArrayDrop(numbers));
//    SKInt y  = SKIntFromString(SKMutableArrayDrop(numbers));
//    CGPathAddQuadCurveToPoint(mutableResult,NULL, xControl1, yControl1, xCoord, yCoord);
}

- (void)__bezierPath:(SKBezierPath *)bezierPath T:(NSMutableArray *)numbers {
}

- (void)__bezierPath:(SKBezierPath *)bezierPath A:(NSMutableArray *)numbers {
}

- (void)__bezierPath:(SKBezierPath *)bezierPath Z:(NSMutableArray *)numbers {
    [bezierPath closePath];
}

@end
