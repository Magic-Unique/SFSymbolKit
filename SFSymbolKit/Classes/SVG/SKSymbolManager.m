//
//  SKSymbolManager.m
//  SFSymbolKit
//
//  Created by Magic-Unique on 2023/4/1.
//

#import "SKSymbolManager.h"
#import "SKSymbol.h"
#import "SKXMLDocument.h"

@interface SKSymbolManager ()

@property (nonatomic, strong, readonly) NSCache<NSURL *, SKSymbol *> *cache;

@end

@implementation SKSymbolManager

+ (instancetype)sharedManager {
    static SKSymbolManager *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = 10;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (SKSymbol *)symbolWithURL:(NSURL *)URL error:(NSError *__autoreleasing *)error {
    if (!URL) {
        return nil;
    }
    SKSymbol *symbol = [self.cache objectForKey:URL];
    if (!symbol) {
        SKXMLDocument *document = [SKXMLDocument documentWithContentsOfURL:URL error:error];
        if (document) {
            symbol = [SKSymbol symbolWithXMLDocument:document error:error];
            if (symbol) {
                [self.cache setObject:symbol forKey:URL cost:0];
            }
        }
    }
    return symbol;
}

@end
