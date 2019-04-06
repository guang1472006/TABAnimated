//
//  TABLayer.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/3/24.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "TABLayer.h"
#import "TABViewAnimated.h"

static CGFloat defaultHeight = 16.f;
static CGFloat defaultSpaceWithLines = 8.f;

@implementation TABLayer

- (instancetype)init {
    if (self = [super init]) {
        
        self.name = @"TABLayer";
        self.anchorPoint = CGPointMake(0, 0);
        self.position = CGPointMake(0, 0);;
        self.opaque = YES;
        self.contentsScale = ([[UIScreen mainScreen] scale] > 3.0) ? [[UIScreen mainScreen] scale] : 3.0;
        
        _valueArray = @[].mutableCopy;
        _labelLinesArray = @[].mutableCopy;
        _cornerRadiusArray = @[].mutableCopy;
        _judgeImageViewArray = @[].mutableCopy;
        _tabWidthArray = @[].mutableCopy;
        _tabHeightArray = @[].mutableCopy;
        _judgeCenterLabelArray = @[].mutableCopy;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx {
    
    CGContextAddRect(ctx,self.bounds);
    CGContextSetFillColorWithColor(ctx,[UIColor.whiteColor CGColor]);
    CGContextFillPath(ctx);
    
    for (int i = 0; i < self.valueArray.count; i++) {
        
        CGRect rect = [self.valueArray[i] CGRectValue];
        rect = [self resetFrame:i rect:rect];
        
        CGFloat cornerRadius = [(NSNumber *)self.cornerRadiusArray[i] floatValue];
        NSInteger labelLines = [self.labelLinesArray[i] integerValue];
        
        if (labelLines != 1) {
            [self addLabelsPath:rect ctx:ctx cornerRadius:cornerRadius lines:labelLines];
        }else {

            if (cornerRadius == 0.) {
                if ([TABViewAnimated sharedAnimated].animatedCornerRadius != 0.) {
                    CGContextAddRoundRect(ctx,rect,[TABViewAnimated sharedAnimated].animatedCornerRadius);
                }else {
                    CGContextAddRect(ctx, rect);
                }
            }else {
                CGContextAddRoundRect(ctx,rect,cornerRadius);
            }
            
            CGContextSetFillColorWithColor(ctx,[[TABViewAnimated sharedAnimated].animatedColor CGColor]);
            CGContextFillPath(ctx);
        }
    }
}

- (void)addLabelsPath:(CGRect)frame
                  ctx:(CGContextRef)ctx
         cornerRadius:(CGFloat)cornerRadius
                lines:(NSInteger)lines {
    
    CGFloat textHeight = defaultHeight*[TABViewAnimated sharedAnimated].animatedHeightCoefficient;
    
    if (lines == 0) {
        lines = (frame.size.height*1.0)/(textHeight+defaultSpaceWithLines);
        if (lines >= 0 && lines <= 1) {
            NSLog(@"TABAnimated提醒 - 监测到多行文本高度为0，动画时将使用默认行数3");
            lines = 3;
        }
    }
    
    for (NSInteger i = 0; i < lines; i++) {
        
        CGRect rect;
        if (i != lines - 1) {
            rect = CGRectMake(frame.origin.x, frame.origin.y+i*(textHeight+defaultSpaceWithLines), frame.size.width, textHeight);
        }else {
            rect = CGRectMake(frame.origin.x, frame.origin.y+i*(textHeight+defaultSpaceWithLines), frame.size.width*0.5, textHeight);
        }
        
        if (cornerRadius == 0.) {
            if ([TABViewAnimated sharedAnimated].animatedCornerRadius != 0.) {
                CGContextAddRoundRect(ctx,rect,[TABViewAnimated sharedAnimated].animatedCornerRadius);
            }else {
                CGContextAddRect(ctx, rect);
            }
        }else {
            CGContextAddRoundRect(ctx,rect,cornerRadius);
        }
        
        CGContextSetFillColorWithColor(ctx,[[TABViewAnimated sharedAnimated].animatedColor CGColor]);
        CGContextFillPath(ctx);
    }
}

- (CGRect)resetFrame:(NSInteger)index
                rect:(CGRect)rect {
    
    CGFloat tabWidth = [(NSNumber *)self.tabWidthArray[index] floatValue];
    if (tabWidth > 0.) {
        rect = CGRectMake(rect.origin.x, rect.origin.y, tabWidth, rect.size.height);
    }
    
    CGFloat tabHeight = [(NSNumber *)self.tabHeightArray[index] floatValue];
    if (tabHeight > 0.) {
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, tabHeight);
    }
    
    BOOL isImageView = [self.judgeImageViewArray[index] boolValue];
    if (!isImageView) {
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height*[TABViewAnimated sharedAnimated].animatedHeightCoefficient);
    }
    
    BOOL isCenterLab = [self.judgeCenterLabelArray[index] boolValue];
    if (isCenterLab) {
        rect = CGRectMake((self.frame.size.width - rect.size.width)/2.0, rect.origin.y, rect.size.width, rect.size.height);
    }
    
    return rect;
}

void CGContextAddRoundRect(CGContextRef context,CGRect rect,CGFloat radius) {
    
    float x1 = rect.origin.x;
    float y1 = rect.origin.y;
    float x2 = x1 + rect.size.width;
    float y2 = y1;
    float x3 = x2;
    float y3 = y1 + rect.size.height;
    float x4 = x1;
    float y4 = y3;
    
    CGContextMoveToPoint(context, x1, y1 + radius);
    CGContextAddArcToPoint(context, x1, y1, x1 + radius, y1, radius);
    CGContextAddArcToPoint(context, x2, y2, x2, y2 + radius, radius);
    CGContextAddArcToPoint(context, x3, y3, x3 - radius, y3, radius);
    CGContextAddArcToPoint(context, x4, y4, x4, y4 - radius, radius);
    CGContextClosePath(context);
}

@end