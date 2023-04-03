//
//  SKSymbol.m
//  SKSymbolKit
//
//  Created by Magic-Unique on 2022/9/13.
//

#import "SKSymbol.h"
#import "SKXMLDocument.h"
#import "SKGraphicParser.h"
#import "SKTypeCategory.h"
#import "SKSymbolManager.h"

#define SK_GRAPHIC_KEY(W, S) [NSString stringWithFormat:@"%@-%@", W, S]

@interface SKSymbol ()

@property (nonatomic, strong, readonly) NSDictionary<NSString *, SKGraphic *> *graphicsMap;

@end

@implementation SKSymbol

+ (instancetype)symbolWithName:(NSString *)name {
    return [self symbolWithName:name inBundle:[NSBundle mainBundle]];
}

+ (instancetype)symbolWithName:(NSString *)name inBundle:(NSBundle *)bundle {
    NSString *path = [bundle pathForResource:name ofType:@"svg"];
    if (!path) {
        return nil;
    }
    NSError *error = nil;
    return [self symbolWithContentsOfFile:path error:&error];
}

+ (instancetype)symbolWithContentsOfFile:(NSString *)filePath error:(NSError *__autoreleasing *)error {
    return [self symbolWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:error];
}

+ (instancetype)symbolWithContentsOfURL:(NSURL *)URL error:(NSError **)error {
    return [[SKSymbolManager sharedManager] symbolWithURL:URL error:error];
}

+ (instancetype)symbolWithXMLDocument:(SKXMLDocument *)document error:(NSError *__autoreleasing *)error {
    SKXMLElement *SVG = document.rootElement;
    
    // Template Version: Template v.*.0
    NSString *templateVersion = [SVG subelementForIdentifier:@"Notes/template-version"].contents;
    
    // Name: Generated from ***.***
    NSString *generateName = [SVG subelementForIdentifier:@"Notes/descriptive-name"].contents;
    
    // Graphic Base
    CGFloat pointSize = [SVG.comments[@"point size"] doubleValue];
    
    // Graphic for Regular-S
    NSMutableArray *graphics = [NSMutableArray array];
    SKXMLElement *symbols = [SVG subelementForIdentifier:@"Symbols"];
    for (SKXMLElement *symbol in symbols.subelements) {
        SKGraphicParser *gParser = [[SKGraphicParser alloc] init];
        gParser.pointSize = pointSize;
        gParser.g = symbol;
        if (![gParser parse]) {
            if (error) {
                *error = gParser.error;
            }
            return nil;
        }
        SKGraphic *gRegularS = gParser.graphic;
        [graphics addObject:gRegularS];
    }
    
    // Style
    SKXMLElement *styleElement = [SVG subelementsForName:@"style"].firstObject;
    NSString *contents = styleElement.contents;
    NSMutableDictionary *styles = [NSMutableDictionary dictionary];
    [contents enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
        if (line.length == 0) {
            return;
        }
        SKClassStyle *style = [SKClassStyle styleWithText:line];
        if (style.className.fullName) {
            styles[style.className.fullName] = style;
        }
    }];
    
    SKSymbol *result = [[SKSymbol alloc] init];
    result.name = [generateName componentsSeparatedByString:@" "].lastObject;
    result.templateVersion = [[templateVersion componentsSeparatedByString:@"v."].lastObject floatValue];
    result.graphics = graphics;
    result.styles = styles;
    [result __makeGraphicsMap];
    [result sortSpecialSymbol];
    return result;
}

- (void)__makeGraphicsMap {
    NSMutableDictionary *map = [NSMutableDictionary dictionary];
    [self.graphics enumerateObjectsUsingBlock:^(SKGraphic * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [NSString stringWithFormat:@"%@-%@", obj.symbolWeight, obj.symbolScale];
        map[key] = obj;
    }];
    _graphicsMap = map;
}

- (void)sortSpecialSymbol {
    if ([self.name isEqualToString:@"pc"]) {
        [self.graphics enumerateObjectsUsingBlock:^(SKGraphic * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableArray<SKPath *> *paths = [obj.paths mutableCopy];
            SKPath *first = paths.firstObject;
            [paths removeObjectAtIndex:0];
            [paths addObject:first];
            obj.paths = paths;
        }];
    }
}

- (SKGraphic *)graphicForWeight:(SKSymbolWeight)weight scale:(SKSymbolScale)scale {
    NSParameterAssert(weight);
    NSParameterAssert(scale);
    NSString *key = SK_GRAPHIC_KEY(weight, scale);
    SKGraphic *graphic = self.graphicsMap[key];
    if (graphic) {
        return graphic;
    }
    graphic = self.graphicsMap[SK_GRAPHIC_KEY(SKSymbolWeightRegular, SKSymbolScaleSmall)];
    if (graphic) {
        return graphic;
    }
    return self.graphics.firstObject;
}

@end
