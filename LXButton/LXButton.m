//
//  MyButton.m
//  OnlineFinance
//
//  Created by FairyLand on 15/8/27.
//  Copyright (c) 2015年 jezz. All rights reserved.
//

#import "LXButton.h"

#import <objc/runtime.h>


//G－C－D
typedef void(^kLXGCDMyButtonBlock)(void);
#define kLXMyButtonGCD_main_async_safe(kLXGCDMyButtonBlock) \
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#define kLXMyButtonGCD_global_sync_safe(block)\
if (![NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_global_queue(0, 0), block);\
}


@interface LXButton()
{
    
}
@property (nonatomic,retain)NSMutableDictionary *colors;

@end

@implementation LXButton
- (instancetype)init
{
    if (self = [super init]) {
        //
        [self initialLXMyButton];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //
        [self initialLXMyButton];
    }
    return self;
}

- (void)initialLXMyButton
{
    /**
     *初始化相关配置
     *
     */
    //
    self.disabledColor = [UIColor lightGrayColor];
//    [self setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
}


#pragma mark -
#pragma mark - Handle Events
- (void)addEvent:(void(^)(id sender))handle forControlEvents:(UIControlEvents)event
{
    __weak LXButton *weakSelf = self;
    __weak UIColor *bgColor = self.backgroundColor;
    if (!handle) {
        return ;
    }
    [weakSelf LX_addEventHandler:^(id sender) {
        //
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t globalQueue = dispatch_queue_create("EventQueue", NULL);
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            //
            LXNSLog(@"1`Disabled");
            [weakSelf setUserInteractionEnabled:NO];
            [weakSelf setBackgroundColor:self.disabledColor ? self.disabledColor : [UIColor lightGrayColor]];
        });
        dispatch_async(globalQueue, ^{
            //
            LXNSLog(@"2.1`Start event...");
            handle(sender);
            LXNSLog(@"2.2`End event...");
        });
        dispatch_async(globalQueue, ^{
            //
            LXNSLog(@"3`");
        });
        dispatch_async(globalQueue, ^{
            //
            LXNSLog(@"4.1`Start Sleeping...");
            sleep(kDisabledAfterEvent);
            LXNSLog(@"4.2`End Sleeping...");
            dispatch_async(mainQueue, ^{
                //
                LXNSLog(@"4.3`Enabled");
                [weakSelf setUserInteractionEnabled:YES];
                [weakSelf setBackgroundColor:bgColor];
            });
        });
        dispatch_async(globalQueue, ^{
            //
            LXNSLog(@"5`Over");
        });
        dispatch_group_notify(group, globalQueue, ^{
            //
            LXNSLog(@"6`Over");
        });
    } forControlEvents:event];
}


#pragma mark -
#pragma mark - setBackgroundColor
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    // If it is normal then set the standard background here
    if(state == UIControlStateNormal)
    {
        [super setBackgroundColor:backgroundColor];
    }
    // Store the background colour for that state
    [self.colors setValue:backgroundColor forKey:[self keyForState:state]];
}
- (UIColor *)backgroundColorForState:(UIControlState)state
{
    return [self.colors valueForKey:[self keyForState:state]];
}

#pragma mark -
#pragma mark - private
- (void)setHighlighted:(BOOL)highlighted
{
    // Do original Highlight
    [super setHighlighted:highlighted];
    // Highlight with new colour OR replace with orignial
    NSString *highlightedKey = [self keyForState:UIControlStateHighlighted];
    UIColor *highlightedColor = self.colors[highlightedKey];
    if (highlighted && highlightedColor) {
        [super setBackgroundColor:highlightedColor];
    } else {
        // 由于系统在调用setSelected后，会再触发一次setHighlighted，故做如下处理，否则，背景色会被最后一次的覆盖掉。
        if ([self isSelected]) {
            NSString *selectedKey = [self keyForState:UIControlStateSelected];
            UIColor *selectedColor = self.colors[selectedKey];
            [super setBackgroundColor:selectedColor];
        } else {
            NSString *normalKey = [self keyForState:UIControlStateNormal];
            [super setBackgroundColor:self.colors[normalKey]];
        }
    }
}
- (void)setSelected:(BOOL)selected
{
    // Do original Selected
    [super setSelected:selected];
    // Select with new colour OR replace with orignial
    NSString *selectedKey = [self keyForState:UIControlStateSelected];
    UIColor *selectedColor = self.colors [selectedKey];
    if (selected && selectedColor) {
        [super setBackgroundColor:selectedColor];
    } else {
        NSString *normalKey = [self keyForState:UIControlStateNormal];
        [super setBackgroundColor:self.colors[normalKey]];
    }
}
- (NSString *)keyForState:(UIControlState)state
{
    return [NSString stringWithFormat:@"state_%d", state];
}
#pragma mark - colors
- (NSMutableDictionary *)colors
{
    if(!_colors){
        _colors = [NSMutableDictionary dictionary];
    }
    
    return _colors;
}

@end

@implementation UIButton (EventHandler)

#pragma mark -
#pragma mark - Handle Events
- (void)addEvent:(void(^)(id sender))handle forControlEvents:(UIControlEvents)event
{
    __weak UIButton *weakSelf = self;
    __weak UIColor *bgColor = self.backgroundColor;
    if (!handle) {
        return ;
    }
    [weakSelf LX_addEventHandler:^(id sender) {
        //
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t globalQueue = dispatch_queue_create("EventQueue", NULL);
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            //
            LXNSLog(@"1`Disabled");
            [weakSelf setUserInteractionEnabled:NO];
            [weakSelf setBackgroundColor:[UIColor lightGrayColor]];
        });
        dispatch_async(globalQueue, ^{
            //
            LXNSLog(@"2.1`Start event...");
            handle(sender);
            LXNSLog(@"2.2`End event...");
        });
        dispatch_async(globalQueue, ^{
            //
            LXNSLog(@"3`");
        });
        dispatch_async(globalQueue, ^{
            //
            LXNSLog(@"4.1`Start Sleeping...");
            sleep(kDisabledAfterEvent);
            LXNSLog(@"4.2`End Sleeping...");
            dispatch_async(mainQueue, ^{
                //
                LXNSLog(@"4.3`Enabled");
                [weakSelf setUserInteractionEnabled:YES];
                [weakSelf setBackgroundColor:bgColor];
            });
        });
        dispatch_async(globalQueue, ^{
            //
            LXNSLog(@"5`Over");
        });
        dispatch_group_notify(group, globalQueue, ^{
            //
            LXNSLog(@"6`Over");
        });
    } forControlEvents:event];
}
@end

@implementation UIImage (colorImage)
static CGFloat edgeSizeFromCornerRadius(CGFloat cornerRadius) {
    return cornerRadius * 2 + 1;
}
+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    CGFloat minEdgeSize = edgeSizeFromCornerRadius(cornerRadius);
    CGRect rect = CGRectMake(0, 0, minEdgeSize, minEdgeSize);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [color setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}
@end

@interface LXControlWrapper : NSObject <NSCopying>

- (id)initWithHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents;

@property (nonatomic) UIControlEvents controlEvents;
@property (nonatomic, copy) void (^handler)(id sender);

@end

@implementation LXControlWrapper

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
    return [[LXControlWrapper alloc] initWithHandler:self.handler forControlEvents:self.controlEvents];
}

- (void)invoke:(id)sender
{
    self.handler(sender);
}

@end

static const void *BKControlHandlersKey = &BKControlHandlersKey;
@implementation UIControl (eventHandler)
- (void)LX_addEventHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents
{
    NSParameterAssert(handler);
    
    NSMutableDictionary *events = objc_getAssociatedObject(self, BKControlHandlersKey);
    if (!events) {
        events = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, BKControlHandlersKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSNumber *key = @(controlEvents);
    NSMutableSet *handlers = events[key];
    if (!handlers) {
        handlers = [NSMutableSet set];
        events[key] = handlers;
    }
    
    LXControlWrapper *target = [[LXControlWrapper alloc] initWithHandler:handler forControlEvents:controlEvents];
    [handlers addObject:target];
    [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
}

- (void)LX_removeEventHandlersForControlEvents:(UIControlEvents)controlEvents
{
    NSMutableDictionary *events = objc_getAssociatedObject(self, BKControlHandlersKey);
    if (!events) {
        events = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, BKControlHandlersKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
- (BOOL)LX_hasEventHandlersForControlEvents:(UIControlEvents)controlEvents
{
    NSMutableDictionary *events = objc_getAssociatedObject(self, BKControlHandlersKey);
    if (!events) {
        events = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, BKControlHandlersKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSNumber *key = @(controlEvents);
    NSSet *handlers = events[key];
    
    if (!handlers)
        return NO;
    
    return !!handlers.count;
}
@end
