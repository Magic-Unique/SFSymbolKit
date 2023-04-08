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

@property (nonatomic, strong, nonnull) SKColor *fillColor;

@property (nonatomic, strong, nonnull) SKBezierPath *bezierPath;

@property (nonatomic, assign) BOOL clearBehind;

@property (nonatomic, assign) CGBlendMode blendMode;

@end


@interface SKSymbolImage : NSObject

/// The symbol
@property (nonatomic, strong, readonly, nonnull) SKSymbol *symbol;

/// Default is nil (Render with SKSymbolTheme.weight)
@property (nonatomic, strong, nullable) SKSymbolWeight weight;

/// Default is nil (Render with SKSymbolTheme.scale)
@property (nonatomic, strong, nullable) SKSymbolScale scale;

/// Default is nil (binding to SKSymbolTheme.color).
@property (nonatomic, strong, nullable) SKSymbolColor *color;

/// The symbol point size
@property (nonatomic, assign) CGFloat pointSize;

/// The symbol variable
@property (nonatomic, assign) double variable;

#ifdef DEBUG
@property (nonatomic, assign) NSUInteger indexOptions;
#endif

@property (nonatomic, assign, readonly) CGRect bounds;
@property (nonatomic, strong, readonly, nonnull) SKBezierPath *fullPath;
@property (nonatomic, strong, readonly, nonnull) NSArray<SKAttributedPath *> *attributedPaths;

+ (instancetype _Nonnull)symbolImageWithSymbol:(SKSymbol * _Nonnull)symbol;
- (instancetype _Nonnull)initWithSymbol:(SKSymbol * _Nonnull)symbol;

+ (instancetype _Nullable)symbolImageNamed:(NSString * _Nonnull)name pointSize:(CGFloat)pointSize;
+ (instancetype _Nullable)symbolImageNamed:(NSString * _Nonnull)name pointSize:(CGFloat)pointSize variable:(double)variable;
+ (instancetype _Nullable)symbolImageNamed:(NSString * _Nonnull)name pointSize:(CGFloat)pointSize variable:(double)variable inBundle:(NSBundle * _Nullable)bundle;

@end



#pragma mark - Private

FOUNDATION_EXTERN NSString * _Nonnull const SKSymbolImageRedrawObserveKey;

@protocol SKSymbolRedrawObserver <NSObject>

@property (nonatomic, strong, nullable) id<NSObject> observer;

- (void)symbolImageNeedsRedraw:(SKSymbolImage * _Nonnull)symbolImage;

@end

@interface SKSymbolImage ()

@property (nonatomic, assign) BOOL redraw;

- (id<NSObject> _Nonnull)addRedrawObserver:(id<SKSymbolRedrawObserver> _Nonnull)observer;
- (void)removeRedrawObserver:(id<SKSymbolRedrawObserver> _Nonnull)observer;

- (void)setNeedsRedraw;

@end

