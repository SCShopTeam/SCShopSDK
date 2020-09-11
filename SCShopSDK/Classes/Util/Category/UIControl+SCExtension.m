//
//  UIControl+SCExtension.m
//  shopping
//
//  Created by gejunyu on 2020/9/10.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "UIControl+SCExtension.h"
#import <objc/runtime.h>

static const void *SCControlHandlersKey = &SCControlHandlersKey;

#pragma mark Private

@interface SCControlWrapper : NSObject <NSCopying>

- (id)initWithHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents;

@property (nonatomic) UIControlEvents controlEvents;
@property (nonatomic, copy) void (^handler)(id sender);

@end

@implementation SCControlWrapper

- (id)initWithHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents
{
    self = [super init];
    if (!self) return nil;

    self.handler = handler;
    self.controlEvents = controlEvents;

    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[SCControlWrapper alloc] initWithHandler:self.handler forControlEvents:self.controlEvents];
}

- (void)invoke:(id)sender
{
    self.handler(sender);
}

@end


@implementation UIControl (SCExtension)

- (void)sc_addEventTouchUpInsideHandle:(void (^)(id sender))handler
{
    [self sc_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
}

- (void)sc_addEventHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents
{
    NSParameterAssert(handler);
    
    NSMutableDictionary *events = objc_getAssociatedObject(self, SCControlHandlersKey);
    if (!events) {
        events = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, SCControlHandlersKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    NSNumber *key = @(controlEvents);
    NSMutableSet *handlers = events[key];
    if (!handlers) {
        handlers = [NSMutableSet set];
        events[key] = handlers;
    }
    
    SCControlWrapper *target = [[SCControlWrapper alloc] initWithHandler:handler forControlEvents:controlEvents];
    [handlers addObject:target];
    [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
}

- (void)sc_removeEventHandlersForControlEvents:(UIControlEvents)controlEvents
{
    NSMutableDictionary *events = objc_getAssociatedObject(self, SCControlHandlersKey);
    if (!events) {
        events = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, SCControlHandlersKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    NSNumber *key = @(controlEvents);
    NSSet *handlers = events[key];

    if (!handlers)
        return;

    [handlers enumerateObjectsUsingBlock:^(id sender, BOOL *stop) {
        [self removeTarget:sender action:NULL forControlEvents:controlEvents];
    }];

    [events removeObjectForKey:key];
}

- (BOOL)sc_hasEventHandlersForControlEvents:(UIControlEvents)controlEvents
{
    NSMutableDictionary *events = objc_getAssociatedObject(self, SCControlHandlersKey);
    if (!events) {
        events = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, SCControlHandlersKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    NSNumber *key = @(controlEvents);
    NSSet *handlers = events[key];
    
    if (!handlers)
        return NO;
    
    return !!handlers.count;
}


@end
