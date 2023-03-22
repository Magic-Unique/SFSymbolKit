//
//  SKStack.h
//  SKSymbolKit
//
//  Created by Magic-Unique on 2022/9/1.
//

#import <Foundation/Foundation.h>

@interface SKStack<__covariant ObjectType> : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<ObjectType> *stack;

- (void)pushElement:(ObjectType)element;

- (ObjectType)popElement;

- (ObjectType)topElement;

@end
