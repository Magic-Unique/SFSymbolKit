//
//  SKSymbolImage.h
//  Pods
//
//  Created by Magic-Unique on 2022/11/23.
//

#import <Foundation/Foundation.h>
#import "SKType.h"

@class SKSymbol;
@class SKSymbolColor;

@interface SKAttributedPath : NSObject

@property (nonatomic, strong) SKColor *fillColor;

@property (nonatomic, strong) SKBezierPath *bezierPath;

@property (nonatomic, assign) BOOL clearBehind;

@property (nonatomic, assign) CGBlendMode blendMode;

@end


@interface SKSymbolImage : NSObject

@property (nonatomic, strong, readonly) SKSymbol *symbol;

@property (nonatomic, strong) SKSymbolColor *color;

@property (nonatomic, assign) CGFloat pointSize;

@property (nonatomic, assign) double variable;

#ifdef DEBUG
@property (nonatomic, assign) NSUInteger indexOptions;
#endif

@property (nonatomic, assign, readonly) CGRect bounds;
@property (nonatomic, strong, readonly) SKBezierPath *fullPath;
@property (nonatomic, strong, readonly) NSArray<SKAttributedPath *> *attributedPaths;

+ (instancetype)symbolImageWithSymbol:(SKSymbol *)symbol;
- (instancetype)initWithSymbol:(SKSymbol *)symbol;

+ (instancetype)symbolImageNamed:(NSString *)name pointSize:(CGFloat)pointSize;
+ (instancetype)symbolImageNamed:(NSString *)name pointSize:(CGFloat)pointSize variable:(double)variable;
+ (instancetype)symbolImageNamed:(NSString *)name pointSize:(CGFloat)pointSize variable:(double)variable inBundle:(NSBundle *)bundle;

@end



#pragma mark - Private

FOUNDATION_EXTERN NSString *const SKSymbolImageRedrawObserveKey;

@protocol SKSymbolRedrawObserver <NSObject>

@property (nonatomic, strong) id<NSObject> observer;

- (void)symbolImageNeedsRedraw:(SKSymbolImage *)symbolImage;

@end

@interface SKSymbolImage ()

@property (nonatomic, assign) BOOL redraw;

- (id<NSObject>)addRedrawObserver:(id<SKSymbolRedrawObserver>)observer;
- (void)removeRedrawObserver:(id<SKSymbolRedrawObserver>)observer;

- (void)setNeedsRedraw;

@end

