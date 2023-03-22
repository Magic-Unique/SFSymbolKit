//
//  SKStack.m
//  SKSymbolKit
//
//  Created by Magic-Unique on 2022/9/1.
//

#import "SKStack.h"

@implementation SKStack

- (instancetype)init {
    self = [super init];
    if (self) {
        _stack = [NSMutableArray array];
    }
    return self;
}

- (void)pushElement:(id)element {
    [self.stack addObject:element];
}

- (id)popElement {
    id element = self.topElement;
    [self.stack removeLastObject];
    return element;
}

- (id)topElement {
    return self.stack.lastObject;
}

@end
