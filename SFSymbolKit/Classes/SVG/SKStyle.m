//
//  SKStyle.m
//  SKSymbolKit
//
//  Created by Magic-Unique on 2022/9/13.
//

/*
 .monochrome-0 {fill:#000000}
 .monochrome-1 {fill:#000000;-sfsymbols-variable-threshold:0.0}
 .monochrome-2 {fill:#000000;-sfsymbols-variable-threshold:0.34}
 .monochrome-3 {fill:#000000;-sfsymbols-variable-threshold:0.68}

 .multicolor-0:tintColor {fill:#007AFF}
 .multicolor-1:tintColor {fill:#007AFF;-sfsymbols-variable-threshold:0.0}
 .multicolor-2:tintColor {fill:#007AFF;-sfsymbols-variable-threshold:0.34}
 .multicolor-3:tintColor {fill:#007AFF;-sfsymbols-variable-threshold:0.68}

 .hierarchical-0:secondary {fill:#4D4D4D}
 .hierarchical-1:primary {fill:#212121;-sfsymbols-variable-threshold:0.0}
 .hierarchical-2:primary {fill:#212121;-sfsymbols-variable-threshold:0.34}
 .hierarchical-3:primary {fill:#212121;-sfsymbols-variable-threshold:0.68}

 .SKSymbolsPreview007AFF {fill:#007AFF;opacity:1.0}
 */

#import "SKStyle.h"
#import "SKTypeCategory.h"

@implementation SKStyleClassName : NSObject

+ (instancetype)classNameWithText:(NSString *)text {
    NSString *fullName = nil;
    NSString *shortName = nil;
    NSUInteger index = 0;
    NSString *colorName = nil;
    
    fullName = [text stringByReplacingOccurrencesOfString:@"." withString:@""];
    if ([fullName hasPrefix:@"SKSymbolsPreview"]) {
        return nil;
    }
    NSArray<NSString *> *list = [fullName componentsSeparatedByString:@":"];
    NSString *prefix = list.firstObject;
    if (list.count == 2) {
        colorName = list.lastObject;
    }
    else if (list.count != 1) {
        return nil;
    }
    list = [prefix componentsSeparatedByString:@"-"];
    shortName = list.firstObject;
    if (list.count == 2) {
        index = list.lastObject.integerValue;
    }
    SKStyleClassName *className = [[SKStyleClassName alloc] init];
    className->_fullName = fullName;
    className->_shortName = shortName;
    className->_index = index;
    className->_colorName = colorName;
    return className;
}

- (NSString *)debugDescription {
    return self.fullName;
}

- (NSString *)description {
    return self.fullName;
}

@end

@interface SKClassStyle ()

@property (nonatomic, strong) NSString *source;

@end

@implementation SKClassStyle

+ (instancetype)styleWithText:(NSString *)text {
    NSArray *texts = [text componentsSeparatedByString:@" "];
    if (texts.count != 2) {
        return nil;
    }
    
    SKStyleClassName *className = [SKStyleClassName classNameWithText:texts.firstObject];
    if (!className) {
        return nil;
    }
    
    NSString *dictStr = [texts.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
    NSArray<NSString *> *list = [dictStr componentsSeparatedByString:@";"];
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    for (NSString *item in list) {
        NSArray<NSString *> *keyValue = [item componentsSeparatedByString:@":"];
        if (keyValue.count == 2) {
            content[keyValue.firstObject] = keyValue.lastObject;
        }
    }
    
    NSNumber *variableThreshold = content[@"-sfsymbols-variable-threshold"];
    
    SKClassStyle *classStyle = [[SKClassStyle alloc] init];
    classStyle->_className = className;
    classStyle->_content = content;
    classStyle->_fill = SKColorWithSyle(content[@"fill"]);
    classStyle->_variableThreshold = variableThreshold ? [variableThreshold doubleValue] : -1;
    classStyle.source = text;
    return classStyle;
}

- (BOOL)isEnableForVariable:(double)variable {
    NSString *threshold = self.content[@"-sfsymbols-variable-threshold"];
    if (!threshold) {
        return YES;
    }
    double _threshold = threshold.doubleValue;
    return variable > _threshold;
}

- (BOOL)clearBehind {
    NSNumber *clear_behind = self.content[@"-sfsymbols-clear-behind"];
    return clear_behind.boolValue;
}

- (NSString *)description {
    return self.source;
}

- (NSString *)debugDescription {
    return self.source;
}

@end
