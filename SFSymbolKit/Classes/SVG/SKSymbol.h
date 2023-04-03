//
//  SKSymbol.h
//  SKSymbolKit
//
//  Created by Magic-Unique on 2022/9/13.
//

#import <Foundation/Foundation.h>
#import "SKStyle.h"
#import "SKGraphic.h"

@class UIImage;
@class SKXMLDocument;

@interface SKSymbol : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) float templateVersion;

@property (nonatomic, strong) NSDictionary<NSString *, SKClassStyle *> *styles;

@property (nonatomic, strong) NSArray<SKGraphic *> *graphics; // Only Regular-S

+ (instancetype)symbolWithName:(NSString *)name;
+ (instancetype)symbolWithName:(NSString *)name inBundle:(NSBundle *)bundle;
+ (instancetype)symbolWithContentsOfFile:(NSString *)filePath error:(NSError **)error;
+ (instancetype)symbolWithContentsOfURL:(NSURL *)URL error:(NSError **)error;


/// No cache. Do not use this method to create instance
/// - Parameters:
///   - document: SKXMLDocument
///   - error: NSError
+ (instancetype)symbolWithXMLDocument:(SKXMLDocument *)document error:(NSError **)error;

- (SKGraphic *)graphicForWeight:(SKSymbolWeight)weight scale:(SKSymbolScale)scale;

@end
