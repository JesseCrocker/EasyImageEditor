//
//  JCColorPickerViewController.h
//  imageEditor
//
//  Created by Jesse Crocker on 7/25/12.
//  Copyright (c) 2012 Jesse Crocker. All rights reserved.
//  https://github.com/JesseCrocker
//

#import <UIKit/UIKit.h>

@protocol JCColorPickerDelegate <NSObject>
-(void)setColor:(UIColor *)color;
@end

@interface JCColorPickerViewController : UIViewController
@property (nonatomic, strong) NSObject<JCColorPickerDelegate> *delegate;

- (IBAction)colorButtonHit:(UIButton *)sender;

@end
