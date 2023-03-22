//
//  SKSymbolView.m
//  Pods
//
//  Created by Magic-Unique on 2022/9/21.
//

#import "SKSymbolView.h"
#import "SKSymbolLayer.h"
#import "SKSymbolImage.h"

@interface SKSymbolView ()
{
    CGSize _intrinsicPathSize;
}

@end

@implementation SKSymbolView

- (instancetype)initWithSymbolImage:(SKSymbolImage *)symbolImage {
    self = [super init];
    if (self) {
        self.symbolImage = symbolImage;
    }
    return self;
}

+ (Class)layerClass { return [SKSymbolLayer class]; }
- (SKSymbolLayer *)symbolLayer { return (SKSymbolLayer *)self.layer; }

- (void)setSymbolImage:(SKSymbolImage *)symbolImage {
    self.symbolLayer.symbolImage = symbolImage;
    [self __checkInvalidateIntrinsicContentSize];
}
- (SKSymbolImage *)symbolImage { return self.symbolLayer.symbolImage; }

- (CGSize)intrinsicContentSize {
    return self.symbolImage.bounds.size;
//    return CGSizeMake(self.symbolImage.pointSize, self.symbolImage.pointSize);
}

- (void)__checkInvalidateIntrinsicContentSize {
    BOOL equals = CGSizeEqualToSize(_intrinsicPathSize, self.symbolImage.bounds.size);
    if (!equals) {
        _intrinsicPathSize = self.symbolImage.bounds.size;
        [self invalidateIntrinsicContentSize];
    }
}

- (void)displayLayer:(CALayer *)layer {
    [self __checkInvalidateIntrinsicContentSize];
}

@end
