//
//  SKDocument.h
//  SKSymbolKit
//
//  Created by Magic-Unique on 2022/9/1.
//

#import <Foundation/Foundation.h>
#import "SKType.h"

@interface SKXMLElement : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSDictionary *attributes;

@property (nonatomic, strong) NSString *contents;

@property (nonatomic, strong) NSMutableArray<SKXMLElement *> *subelements;

@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *comments;

@end



@interface SKXMLElement (Name)

@property (nonatomic, assign, readonly) BOOL isSVG;
@property (nonatomic, assign, readonly) BOOL isStyle;
@property (nonatomic, assign, readonly) BOOL isG;
@property (nonatomic, assign, readonly) BOOL isPath;

@end

@interface SKXMLElement (Attributes)

@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) NSArray<NSString *> *classes;

@property (nonatomic, assign, readonly) SKInt x1;
@property (nonatomic, assign, readonly) SKInt y1;
@property (nonatomic, assign, readonly) SKInt x2;
@property (nonatomic, assign, readonly) SKInt y2;

@property (nonatomic, assign, readonly) SKPoint p1;
@property (nonatomic, assign, readonly) SKPoint p2;

@property (nonatomic, assign, readonly) SKInt x;
@property (nonatomic, assign, readonly) SKInt y;
@property (nonatomic, assign, readonly) SKInt width;
@property (nonatomic, assign, readonly) SKInt height;
@property (nonatomic, assign, readonly) SKRect rect;

@end






@interface SKXMLElement (Search)

- (SKXMLElement *)subelementForIdentifier:(NSString *)identifier;

- (NSArray<SKXMLElement *> *)subelementsForName:(NSString *)name;

@end



@interface SKXMLDocument : NSObject

@property (nonatomic, strong, readonly) SKXMLElement *rootElement;

+ (instancetype)documentWithContentsOfFile:(NSString *)filePath error:(NSError **)error;

@end

