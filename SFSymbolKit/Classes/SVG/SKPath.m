//
//  SKPath.m
//  SKSymbolKit
//
//  Created by Magic-Unique on 2022/9/6.
//

#import "SKPath.h"
#import "SKXMLDocument.h"
#import "SKTypeCategory.h"
#import "SKBezierParser.h"
#import "SKStyle.h"

@implementation SKPath

- (instancetype)initWithElement:(SKXMLElement *)element {
    self = [super init];
    if (self) {
        self.bezierPath = [self __generatePath:element];
        self.fillColor = SKColorWithSyle(element.attributes[@"fill"]);
        self.strockColor = SKColorWithSyle(element.attributes[@"strock"]);
        NSString *style = element.attributes[@"class"];
        NSMutableArray *list = [[style componentsSeparatedByString:@" "] mutableCopy];
        for (NSUInteger i = 0; i < list.count; i++) {
            NSString *item = list[i];
            SKStyleClassName *className = [SKStyleClassName classNameWithText:item];
            if (className) {
                list[i] = className;
            } else {
                [list removeObjectAtIndex:i--];
            }
        }
        self.classList = list;
    }
    return self;
}

- (SKBezierPath *)__generatePath:(SKXMLElement *)element {
    SKBezierPath *path = [SKBezierPath bezierPath];
    if ([element.name isEqualToString:@"line"]) {
        [path moveToPoint:CGPointFromSKPoint(element.p1)];
        [path sf_addLineToPoint:CGPointFromSKPoint(element.p2)];
    }
    else if ([element.name isEqualToString:@"rect"]) {
        [path sf_addRect:CGRectFromSKRect(element.rect)];
    }
    else if ([element.name isEqualToString:@"circle"]) {
        SKInt cx = SKIntFromString(element.attributes[@"cx"]);
        SKInt cy = SKIntFromString(element.attributes[@"cy"]);
        SKInt  r = SKIntFromString(element.attributes[@"r"]);
        SKRect rect;
        rect.origin.x = cx - r;
        rect.origin.y = cy - r;
        rect.size.width = 2 * r;
        rect.size.height = 2 * r;
        [path sf_addOvalInRect:CGRectFromSKRect(rect)];
    }
    else if ([element.name isEqualToString:@"ellipse"]) {
        SKInt cx = SKIntFromString(element.attributes[@"cx"]);
        SKInt cy = SKIntFromString(element.attributes[@"cy"]);
        SKInt rx = SKIntFromString(element.attributes[@"rx"]);
        SKInt ry = SKIntFromString(element.attributes[@"ry"]);
        SKRect rect;
        rect.origin.x = cx - rx;
        rect.origin.y = cy - ry;
        rect.size.width = 2 * rx;
        rect.size.height = 2 * ry;
        [path sf_addOvalInRect:CGRectFromSKRect(rect)];
    }
    else if ([element.name isEqualToString:@"path"]) {
        SKBezierParser *parser = [[SKBezierParser alloc] init];
        parser.d = element.attributes[@"d"];
        if ([parser parse]) {
            [path sf_addPath:parser.path];
        }
    }
    else {
        
    }
    return path;
}

@end
