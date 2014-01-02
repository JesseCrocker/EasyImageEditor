//
//  PaintView.m
//  Created by Jesse Crocker on 7/24/12.
//  Copyright (c) 2012 Jesse Crocker. All rights reserved.
//  https://github.com/JesseCrocker
//
//

#import "PaintView.h"
#import "JCBezierPath.h"

@interface NSMutableArray (ShiftExtension)
-(id)shift;
-(id)pop;
@end

@implementation NSMutableArray (ShiftExtension)
-(id)shift {
    if([self count] < 1) return nil;
    id obj = [self objectAtIndex:0];
    [self removeObjectAtIndex:0];
    return obj;
}
-(id)pop {
    if([self count] < 1) return nil;
    id obj = [self lastObject];
    [self removeLastObject];
    return obj;
}
@end

@interface PaintView () {    
    NSMutableArray *pathArray;
    NSMutableArray *undoBufferArray;
    
    JCBezierPath *myPath;
}
@end

@implementation PaintView
@synthesize undoSteps;
@synthesize width;
@synthesize color;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        pathArray = [NSMutableArray array];
        undoBufferArray = [NSMutableArray array];
        
        self.width = 5;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    for (JCBezierPath *_path in pathArray){
        UIColor *thisColor = _path.color;
        if(!thisColor){
            thisColor = self.color;
        }        
        [thisColor setStroke];
        [_path stroke];
    }
}

#pragma mark - Touch Methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(touches.count > 1)
        return;
    
    if(!self.color)
        self.color = [UIColor blackColor];
    
    myPath = [[JCBezierPath alloc] init];
    myPath.lineWidth = self.width;
    myPath.color = self.color;
    
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    [myPath moveToPoint:[mytouch locationInView:self]];
    [pathArray addObject:myPath];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(touches.count > 1 ||myPath == nil)
        return;
    
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    [myPath addLineToPoint:[mytouch locationInView:self]];
    [self setNeedsDisplay];
}
/*
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

}*/

-(void)undo{
    JCBezierPath *lastPath = [pathArray pop];
    if(lastPath){
        [undoBufferArray addObject:lastPath];
        [self setNeedsDisplay];
    }
}

-(void)redo {
    JCBezierPath *restorePath = [undoBufferArray pop];
    if(restorePath){
        [pathArray addObject:restorePath];
        [self setNeedsDisplay];
    }
}

@end
