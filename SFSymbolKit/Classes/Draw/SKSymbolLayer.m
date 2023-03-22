//
//  SKSymbolLayer.m
//  Pods
//
//  Created by Magic-Unique on 2022/9/21.
//

#import "SKSymbolLayer.h"
#import "SKSymbol.h"
#import "SKPath.h"
#import "SKSymbolImage.h"
#import "SKTypeCategory.h"

/*
 @property CGFloat lineWidth;
 @property NSLineCapStyle lineCapStyle;
 @property NSLineJoinStyle lineJoinStyle;
 @property NSWindingRule windingRule;
 @property CGFloat miterLimit;
 @property CGFloat flatness;
 */

static NSArray<CAShapeLayer *> *SKPathLayersFromSymbolImage(SKSymbolImage *symbolImage) {
    NSMutableArray *layers = [NSMutableArray array];
    for (NSUInteger i = 0; i < symbolImage.attributedPaths.count; i++) {
        SKAttributedPath *path = symbolImage.attributedPaths[i];
        SKAttributedPath *next = (i + 1 == symbolImage.attributedPaths.count) ? nil : symbolImage.attributedPaths[i+1];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = path.fillColor.CGColor;
        layer.path = [path.bezierPath CGPath];
        if (next.clearBehind) {
            SKBezierPath *_path = [path.bezierPath copy];
            [_path sf_addPath:next.bezierPath];
            layer.path = _path.CGPath;
            layer.fillRule = kCAFillRuleEvenOdd;
            i++;
        }
        [layers addObject:layer];
    }
    return layers;
}

@interface SKSymbolLayer () <SKSymbolRedrawObserver>

@end

@implementation SKSymbolLayer

@synthesize symbolImage = _symbolImage;
@synthesize observer = _observer;

- (void)setSymbolImage:(SKSymbolImage *)symbolImage {
    [_symbolImage removeRedrawObserver:self];
    _symbolImage = symbolImage;
    [_symbolImage addRedrawObserver:self];
    [self setNeedsDisplay];
}

- (void)symbolImageNeedsRedraw:(SKSymbolImage *)symbolImage {
    [self setNeedsDisplay];
}

- (void)display {
    [super display];
    [_pathLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    _pathLayers = SKPathLayersFromSymbolImage(self.symbolImage);
    [_pathLayers enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSublayer:obj];
    }];
}

@end
