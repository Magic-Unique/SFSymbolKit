//
//  SKDocument.m
//  SKSymbolKit
//
//  Created by Magic-Unique on 2022/9/1.
//

#import "SKXMLDocument.h"
#import "SKXMLParser.h"
#import "SKTypeCategory.h"

@implementation SKXMLElement

- (instancetype)init {
    self = [super init];
    if (self) {
        _subelements = [NSMutableArray array];
    }
    return self;
}

@end


@implementation SKXMLElement (Name)

- (BOOL)isSVG { return [self.name isEqualToString:@"svg"]; }
- (BOOL)isStyle { return [self.name isEqualToString:@"style"]; }
- (BOOL)isG { return [self.name isEqualToString:@"g"]; }
- (BOOL)isPath { return [@[@"line", @"path"] containsObject:self.name]; }

@end



@implementation SKXMLElement (Attributes)

- (NSArray<NSString *> *)classes { return [self.attributes[@"class"] componentsSeparatedByString:@" "]; }

- (SKInt)__integerFor:(SEL)sel {
    NSString *key = NSStringFromSelector(sel);
    return SKIntFromString(self.attributes[key]);
}

#define SK_INTEGER_GETTER(k) - (SKInt)k { return (SKIntFromString(self.attributes[@#k])); }

- (NSString *)identifier { return self.attributes[@"id"]; }
SK_INTEGER_GETTER(x1)
SK_INTEGER_GETTER(y1)
SK_INTEGER_GETTER(x2)
SK_INTEGER_GETTER(y2)
- (SKPoint)p1 { return SKPointMake(self.x1, self.y1); }
- (SKPoint)p2 { return SKPointMake(self.x2, self.y2); }

SK_INTEGER_GETTER(x)
SK_INTEGER_GETTER(y)
SK_INTEGER_GETTER(width)
SK_INTEGER_GETTER(height)
- (SKRect)rect {
    SKRect rect;
    rect.origin.x = self.x;
    rect.origin.y = self.y;
    rect.size.width = self.width;
    rect.size.height = self.height;
    return rect;
}

@end



@implementation SKXMLElement (Search)

- (SKXMLElement *)subelementForIdentifier:(NSString *)identifier {
    NSMutableArray *list = [[identifier componentsSeparatedByString:@"/"] mutableCopy];
    return [self __subelementForIdentifiers:list];
}

- (NSArray<SKXMLElement *> *)subelementsForName:(NSString *)name {
    return [self.subelements filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SKXMLElement *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject.name isEqualToString:name];
    }]];
}

- (SKXMLElement *)__subelementForIdentifier:(NSString *)identifier {
    for (SKXMLElement *item in self.subelements) {
        if ([item.identifier isEqualToString:identifier]) {
            return item;
        }
    }
    return nil;
}

- (SKXMLElement *)__subelementForIdentifiers:(NSMutableArray *)identifiers {
    if (identifiers.count == 0) {
        return self;
    }
    
    NSString *identifier = identifiers.firstObject;
    SKXMLElement *sub = [self __subelementForIdentifier:identifier];
    [identifiers removeObjectAtIndex:0];
    return [sub __subelementForIdentifiers:identifiers];
}

@end



@implementation SKXMLDocument

+ (instancetype)documentWithContentsOfFile:(NSString *)filePath error:(NSError *__autoreleasing *)error {
    SKXMLElement *rootElement = [SKXMLParser parseFile:filePath error:error];
    if (rootElement) {
        return [[self alloc] initWithRootElement:rootElement];
    } else {
        return nil;
    }
}

- (instancetype)initWithRootElement:(SKXMLElement *)rootElement {
    self = [super init];
    if (self) {
        _rootElement = rootElement;
    }
    return self;
}

@end
