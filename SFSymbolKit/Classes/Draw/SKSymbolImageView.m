//
//  SKSymbolImageView.m
//  Pods
//
//  Created by Magic-Unique on 2023/3/3.
//

#import "SKSymbolImageView.h"
#import "SKSymbolImage.h"
#import "SKImage+SymbolKit.h"

@interface SKSymbolImageView () <SKSymbolRedrawObserver>

@end

@implementation SKSymbolImageView

@synthesize symbolImage = _symbolImage;
@synthesize observer;

- (instancetype)initWithSymbolImage:(SKSymbolImage *)symbolImage {
    self = [super initWithImage:[symbolImage toImage]];
    if (self) {
        _symbolImage = symbolImage;
        [_symbolImage addRedrawObserver:self];
    }
    return self;
}

- (void)setSymbolImage:(SKSymbolImage *)symbolImage {
    [_symbolImage removeRedrawObserver:self];
    _symbolImage = symbolImage;
    [_symbolImage addRedrawObserver:self];
    self.image = [self.symbolImage toImageWithSize:self.frame.size];
}

- (void)symbolImageNeedsRedraw:(SKSymbolImage *)symbolImage {
    self.image = [self.symbolImage toImageWithSize:self.frame.size];
}


@end
