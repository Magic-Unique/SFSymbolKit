//
//  SKSymbolImage.m
//  Pods
//
//  Created by Magic-Unique on 2022/11/23.
//

#import "SKSymbolImage.h"
#import "SKType.h"
#import "SKTypeCategory.h"
#import "SKStyle.h"
#import "SKSymbolColor.h"
#import "SKGraphic.h"
#import "SKSymbol.h"
#import "SKPath.h"
#import "SKSymbolTheme.h"
#import "SKExtensions.h"

static SKStyleClassName *SKFindHierarchicalClass(NSArray<SKStyleClassName *> *classes) {
    return SKFirstObjectInArray(classes, ^BOOL(SKStyleClassName *item) {
        return [item.shortName isEqualToString:@"hierarchical"];
    });
}

static SKColorLevel SKColorLevelForClasses(NSArray<SKStyleClassName *> *classes) {
    SKStyleClassName *hierarchical = SKFindHierarchicalClass(classes);
    if (!hierarchical) {
        return SKColorLevelPrimary;
    }
    else if ([hierarchical.colorName isEqualToString:@"primary"]) {
        return SKColorLevelPrimary;
    }
    else if ([hierarchical.colorName isEqualToString:@"secondary"] || [hierarchical.colorName isEqualToString:@"tertiary"]) {
        return SKColorLevelSecondary;
    }
    return SKColorLevelPrimary;
}

static double SKVariableThresholdIn(NSDictionary<NSString *, SKClassStyle *> *styles, SKStyleClassName *standardClassName) {
    SKClassStyle *style = styles[standardClassName.fullName];
    if (!style) {
        return -1;
    } else {
        return style.variableThreshold;
    }
}

#ifdef DEBUG
static NSUInteger _display_index_options_ = 0;
#endif

/// 模板 3.0，支持 hierarchical, multicolor, palette, monochrome
/// - Parameters:
///   - styles: file.svg.styles
///   - classNames: file.svg.graphic.path.class
///   - symbolColor: app.color
///   - variable: variable [0.0, 1.0]
///   - clearBehind: marked clear-behind
static SKColor *SKColorForDraw_4_0(NSDictionary<NSString *, SKClassStyle *> *styles,
                                   NSArray<SKStyleClassName *> *classNames,
                                   SKSymbolColor *symbolColor,
                                   double variable,
                                   BOOL *clearBehind) {
    // 要渲染的颜色类型: hierarchical, SKPaletteClassShortName, multicolor, monochrome
    NSString *specialShortName = SKClassShortNameForStyle(symbolColor.style);
    
    // 标准层级
    SKStyleClassName *standardClassName = SKFindHierarchicalClass(classNames);
    SKClassStyle *standardStyle = styles[standardClassName.fullName];
    double variableThreshold = SKVariableThresholdIn(styles, standardClassName);
//    *clearBehind = standardStyle.clearBehind;
    
    // 取颜色等级
    SKColorLevel level = SKColorLevelForClasses(classNames);
    
    // 根据传入的颜色类型，找到对应的 css
    SKStyleClassName *className = SKFirstObjectInArray(classNames, ^BOOL(SKStyleClassName *item) {
        return [item.shortName isEqualToString:specialShortName];
    });
    
    SKClassStyle *classStyle = className ? styles[className.fullName] : nil;
    SKColor *color = [symbolColor colorWithLevel:level classStyle:classStyle] ?: [SKColor blackColor];
    *clearBehind = (classStyle ?: standardStyle).clearBehind;
    if (variable <= variableThreshold) {
        color = [color colorWithAlphaComponent:0.25];
    }
    return color;
}

/// 模板 3.0，支持 hierarchical, multicolor, palette
/// - Parameters:
///   - styles: file.svg.styles
///   - classNames: file.svg.graphic.path.class
///   - symbolColor: app.color
///   - clearBehind: marked clear-behind
static SKColor *SKColorForDraw_3_0(NSDictionary<NSString *, SKClassStyle *> *styles,
                                   NSArray<SKStyleClassName *> *classNames,
                                   SKSymbolColor *symbolColor,
                                   BOOL *clearBehind) {
    return SKColorForDraw_4_0(styles, classNames, symbolColor, 1, clearBehind);
}

/// 模板 2.0，纯黑色
static SKColor *SKColorForDraw_2_0() {
    return [SKColor blackColor];
}

static NSArray<SKAttributedPath *> *SKAttributedPathsFromSymbol(SKSymbol *svg, double variable, SKSymbolColor *color, CGFloat pointSize, SKBezierPath *fullPath) {
    const CGFloat POINT_SIZE = pointSize;
    const CGAffineTransform TRANSKORM = CGAffineTransformMakeScale(POINT_SIZE / 100, POINT_SIZE / 100);
    
    SKSymbolWeight weight = [SKSymbolTheme currentSymbolWeight];
    SKSymbolScale scale = SKSymbolScaleSmall;
    SKGraphic *graphic = [svg graphicForWeight:weight scale:scale];
    CGAffineTransform transform = graphic.transform;
    transform = CGAffineTransformConcat(transform, TRANSKORM);
    
    NSMutableArray *paths = [NSMutableArray array];
    for (NSUInteger i = 0; i < graphic.paths.count; i++) {
//        SKPath *path = graphic.paths[graphic.paths.count - i - 1];
        SKPath *path = graphic.paths[i];
#ifdef DEBUG
        if (((1<<i) & _display_index_options_) == 0) {
            continue;
        }
#endif
        SKAttributedPath *attrbutedPath = [[SKAttributedPath alloc] init];
        if (svg.templateVersion == 2.0) {
            attrbutedPath.fillColor = SKColorForDraw_2_0();
        }
        else if (svg.templateVersion == 3.0) {
            BOOL clearBehind = NO;
            attrbutedPath.fillColor = SKColorForDraw_3_0(svg.styles, path.classList, color, &clearBehind);
            attrbutedPath.clearBehind = clearBehind;
        }
        else if (svg.templateVersion == 4.0) {
            BOOL clearBehind = NO;
            attrbutedPath.fillColor = SKColorForDraw_4_0(svg.styles, path.classList, color, variable, &clearBehind);
            attrbutedPath.clearBehind = clearBehind;
        }
        attrbutedPath.bezierPath = ({
            SKBezierPath *bezierPath = [path.bezierPath copy];
            [bezierPath sf_applyTransform:transform];
            bezierPath;
        });
        attrbutedPath.blendMode = [color blendModeForClearBehind:attrbutedPath.clearBehind];
        [paths addObject:attrbutedPath];
        [fullPath sf_addPath:attrbutedPath.bezierPath];
    }
    
    return paths;
}

@interface _SKSymbolImageRedrawObserver : NSObject
@property (nonatomic, weak) id<SKSymbolRedrawObserver> observer;
@property (nonatomic, weak) SKSymbolImage *observingSymbolImage;
@end
@implementation _SKSymbolImageRedrawObserver

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.observingSymbolImage) {
        [self.observer symbolImageNeedsRedraw:object];
    }
}

@end

@implementation SKSymbolImage

+ (instancetype)symbolImageNamed:(NSString *)name pointSize:(CGFloat)pointSize {
    return [self symbolImageNamed:name pointSize:pointSize variable:1];
}

+ (instancetype)symbolImageNamed:(NSString *)name pointSize:(CGFloat)pointSize variable:(double)variable {
    return [self symbolImageNamed:name pointSize:pointSize variable:variable inBundle:[NSBundle mainBundle]];
}

+ (instancetype)symbolImageNamed:(NSString *)name pointSize:(CGFloat)pointSize variable:(double)variable inBundle:(NSBundle *)bundle {
    SKSymbol *symbol = [SKSymbol symbolWithName:name inBundle:bundle];
    SKSymbolImage *symbolImage = [SKSymbolImage symbolImageWithSymbol:symbol];
    symbolImage.pointSize = pointSize;
    symbolImage.variable = variable;
    return symbolImage;
}

+ (instancetype)symbolImageWithSymbol:(SKSymbol *)symbol {
    return [[self alloc] initWithSymbol:symbol];
}

- (instancetype)initWithSymbol:(SKSymbol *)symbol {
    self = [super init];
    if (self) {
        _symbol = symbol;
        _pointSize = 100;
        _color = [SKSymbolColor monochrome];
        _redraw = YES;
#ifdef DEBUG
        _indexOptions = NSUIntegerMax;
#endif
    }
    return self;
}

- (void)setColor:(SKSymbolColor *)color {
    _color = color;
    [self setNeedsRedraw];
}

- (void)setPointSize:(CGFloat)pointSize {
    if (_pointSize == pointSize) {
        return;
    }
    _pointSize = pointSize;
    [self setNeedsRedraw];
}

- (void)setVariable:(double)variable {
    if (_variable == variable) {
        return;
    }
    _variable = variable;
    [self setNeedsRedraw];
}

#ifdef DEBUG
- (void)setIndexOptions:(NSUInteger)indexOptions {
    if (_indexOptions == indexOptions) {
        return;
    }
    _indexOptions = indexOptions;
    [self setNeedsRedraw];
}
#endif

- (void)setNeedsRedraw {
    _attributedPaths = nil;
    _fullPath = nil;
    _bounds = CGRectNull;
    self.redraw = YES;
}

- (void)__redraw {
#ifdef DEBUG
    _display_index_options_ = _indexOptions;
#endif
    SKBezierPath *fullPath = [SKBezierPath bezierPath];
    _attributedPaths = SKAttributedPathsFromSymbol(self.symbol, self.variable, self.color, self.pointSize, fullPath);
    CGRect bounds = fullPath.bounds;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-bounds.origin.x + 1, -bounds.origin.y + 1);
    [_attributedPaths enumerateObjectsUsingBlock:^(SKAttributedPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.bezierPath sf_applyTransform:transform];
    }];
    [fullPath sf_applyTransform:transform];
    _bounds = CGRectMake(0, 0, fullPath.bounds.size.width + 2, fullPath.bounds.size.height + 2);
    _fullPath = fullPath;
    _redraw = NO;
}

- (id<NSObject>)addRedrawObserver:(id<SKSymbolRedrawObserver>)observer {
    _SKSymbolImageRedrawObserver *_observer = [[_SKSymbolImageRedrawObserver alloc] init];
    _observer.observer = observer;
    _observer.observingSymbolImage = self;
    [self addObserver:_observer forKeyPath:SKSymbolImageRedrawObserveKey options:NSKeyValueObservingOptionNew context:NULL];
    observer.observer = _observer;
    return observer;
}

- (void)removeRedrawObserver:(id<SKSymbolRedrawObserver>)observer {
    _SKSymbolImageRedrawObserver *_observer = observer.observer;
    if (_observer.observingSymbolImage == self) {
        [self removeObserver:observer.observer forKeyPath:SKSymbolImageRedrawObserveKey];
        observer.observer = nil;
    }
}

@synthesize bounds = _bounds;
- (CGRect)bounds {
    if (_redraw) {
        [self __redraw];
    }
    return _bounds;
}

@synthesize fullPath = _fullPath;
- (SKBezierPath *)fullPath {
    if (!_fullPath) {
        [self __redraw];
    }
    return _fullPath;
}

@synthesize attributedPaths = _attributedPaths;
- (NSArray<SKAttributedPath *> *)attributedPaths {
    if (!_attributedPaths) {
        [self __redraw];
    }
    return _attributedPaths;
}

@end

@implementation SKAttributedPath
@end

NSString *const SKSymbolImageRedrawObserveKey = @"redraw";
