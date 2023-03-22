//
//  SKGraphicParser.m
//  SKSymbolKit
//
//  Created by Magic-Unique on 2022/9/13.
//

#import "SKGraphicParser.h"
#import <CoreGraphics/CoreGraphics.h>
#import "SKTypeCategory.h"
#import "SKPath.h"
#import "SKGraphic.h"

@implementation SKGraphicParser

- (BOOL)parse {
    SKBezierPath *bezierPath = [SKBezierPath bezierPath];
    NSMutableArray *paths = [NSMutableArray array];
    for (SKXMLElement *element in self.g.subelements.copy) {
        SKPath *path = [[SKPath alloc] initWithElement:element];
        [paths addObject:path];
        [bezierPath sf_addPath:path.bezierPath];
    }
    
    CGRect bounds = bezierPath.bounds;
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform.tx = (self.pointSize - bounds.size.width) * 0.5 - bounds.origin.x;
    transform.ty = (self.pointSize - bounds.size.height) * 0.5 - bounds.origin.y;
    
    NSArray *weightAndScale = [self.g.attributes[@"id"] componentsSeparatedByString:@"-"];
    
    SKGraphic *graphic = [[SKGraphic alloc] init];
    graphic.symbolWeight = weightAndScale.firstObject;
    graphic.symbolScale = weightAndScale.lastObject;
    graphic.contentSize = SKSizeFromCGSize(bounds.size);
    graphic.paths = paths;
    graphic.transform = transform;
    graphic.fullBezierPath = bezierPath;
    _graphic = graphic;
    return YES;
}

@end
