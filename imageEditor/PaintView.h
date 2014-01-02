//
//  PaintView.h
//  Created by Jesse Crocker on 7/24/12.
//  Copyright (c) 2012 Jesse Crocker. All rights reserved.
//  https://github.com/JesseCrocker
//

#import <UIKit/UIKit.h>


@interface PaintView : UIView

@property(nonatomic,assign) NSInteger undoSteps;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) int width;

-(void)undo;
-(void)redo;
@end
