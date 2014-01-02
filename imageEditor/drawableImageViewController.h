//
//  ViewController.h
//  imageEditor
//
//  Created by Jesse Crocker on 7/24/12.
//  Copyright (c) 2012 Jesse Crocker. All rights reserved.
//  https://github.com/JesseCrocker
//

#import <UIKit/UIKit.h>
#import "PaintView.h"
#import "imageScrollView.h"
#import "JCColorPickerViewController.h"

@interface drawableImageViewController : UIViewController <JCColorPickerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) PaintView *paintView;
@property (strong, nonatomic) IBOutlet ImageScrollView *scrollImage;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *drawButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *colorButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *undoButton;

@property (nonatomic, strong) UIColor *color;

- (IBAction)drawButtonHit:(id)sender;
- (IBAction)colorButtonHit:(id)sender;
- (IBAction)undoButtonHit:(id)sender;

@end
