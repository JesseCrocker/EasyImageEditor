//
//  ViewController.m
//  imageEditor
//
//  Created by Jesse Crocker on 7/24/12.
//  Copyright (c) 2012 Jesse Crocker. All rights reserved.
//  https://github.com/JesseCrocker
//

#import "drawableImageViewController.h"
#import "PaintView.h"
#import <QuartzCore/QuartzCore.h>
#import "FPPopoverController.h"
#import "JCTwoFingerRotationGestureRecognizer.h"

@interface drawableImageViewController (){
    bool drawing;
    CGFloat lineWidth;
    FPPopoverController *phonePopover;
    UIPopoverController *padPopover;
    CGFloat currentRotation;
    CGFloat radiansPerUndo;
    int undoCount;
}

@end

@implementation drawableImageViewController
@synthesize colorButton;
@synthesize scrollImage;
@synthesize paintView;
@synthesize toolbar;
@synthesize drawButton;
@synthesize color = _color;
@synthesize undoButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.scrollImage.maxScreenMultiplier = 3;
    }else{
        self.scrollImage.maxScreenMultiplier = 2;
    }
    
    [self loadImage];
	self.color = [UIColor redColor];
    lineWidth = 5;
    [self hideUndoButton];
    [self addRotationGesture];
}

- (void)viewDidUnload
{
    [self setDrawButton:nil];
    [self setColorButton:nil];
    [self setScrollImage:nil];
    [self setUndoButton:nil];
    [self setToolbar:nil];
    phonePopover = nil;
    padPopover = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}
/*
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.scrollImage zoomToMinnimumZoom];
}*/

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.scrollImage zoomToMinnimumZoom];

}
#pragma mark - 
-(void)addRotationGesture{
    JCTwoFingerRotationGestureRecognizer *rotation = [[JCTwoFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotating:)];
    rotation.delegate = self;
    [self.scrollImage addGestureRecognizer:rotation];
}

-(void)loadImage{
    UIImage *inputImage = [UIImage imageNamed:@"palisade slide.jpg"];
   // CGSize imageSize = inputImage.size;
    //NSLog(@"image size: %f x %f", imageSize.width, imageSize.height);

    [self.scrollImage displayImage:inputImage];
}

-(void)setupPaintView{
    lineWidth = 5 / self.scrollImage.zoomScale;
    self.paintView = [[PaintView alloc] initWithFrame:self.scrollImage.imageView.bounds];
    paintView.backgroundColor = [UIColor clearColor];
    [self.scrollImage.imageView addSubview:self.paintView];
    paintView.width = lineWidth;
    paintView.color = self.color;

    [self.scrollImage disableScrolling];
    self.scrollImage.paintView = paintView;
}

-(void)endPaintView{
    drawing = NO;
    CGSize size = self.scrollImage.imageView.bounds.size;
    UIGraphicsBeginImageContext(size);
    [self.scrollImage.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *compositedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.scrollImage displayImage:compositedImage];
    
    //NSLog(@"compositied image size: %f x %f", compositedImage.size.width, compositedImage.size.height);
    
    [self.paintView removeFromSuperview];
    self.scrollImage.paintView = nil;
    self.paintView = nil;
    
    [self.scrollImage enableScrolling];
}

-(void)showUndoButton{
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.toolbar.items];
    if(![items containsObject:self.undoButton]){
        [items addObject:self.undoButton];
        [self.toolbar setItems:items animated:YES];
    }
}

-(void)hideUndoButton{
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.toolbar.items];
    if([items containsObject:self.undoButton]){
        [items removeObject:self.undoButton];
        [self.toolbar setItems:items animated:YES];
    }
}

-(void)showColorPicker{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(!padPopover){
            JCColorPickerViewController *colorPicker = [[JCColorPickerViewController alloc] initWithNibName:@"JCColorPickerViewController~ipad"
                                                                                                     bundle:nil];
            colorPicker.delegate = self;
            padPopover = [[UIPopoverController alloc] initWithContentViewController:colorPicker];
            [padPopover setPopoverContentSize:CGSizeMake(713, 100)];
        }
        [padPopover presentPopoverFromBarButtonItem:self.colorButton 
                           permittedArrowDirections:UIPopoverArrowDirectionDown 
                                           animated:YES];
    }else {
        if(!phonePopover){
            JCColorPickerViewController *colorPicker = [[JCColorPickerViewController alloc] initWithNibName:@"JCColorPickerViewController"
                                                                                                     bundle:nil];
            colorPicker.delegate = self;
            phonePopover = [[FPPopoverController alloc] initWithViewController:colorPicker];
            phonePopover.tint = FPPopoverDefaultTint;
            phonePopover.contentSize = CGSizeMake(310, 100);
            phonePopover.arrowDirection = FPPopoverArrowDirectionAny;
        }
        [phonePopover presentPopoverFromView:(UIView *)self.toolbar];
    }
}

-(void)setColor:(UIColor *)color{
    _color = color;
    if(self.paintView)
        self.paintView.color = _color;
    if(phonePopover )
        [phonePopover dismissPopoverAnimated:YES];
    if(padPopover)
        [padPopover dismissPopoverAnimated:YES];
}

#pragma mark - responding to user input
- (void)rotating:(JCTwoFingerRotationGestureRecognizer *)recognizer{
    if(!drawing)
        return;
    
    if(recognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@"rotation started");
        currentRotation = 0;
        undoCount = 0;
        self.scrollImage.paintView = nil;
    }else if(recognizer.state == UIGestureRecognizerStateChanged){
        NSLog(@"got rotation gesture recognizer rotation:%1.2f", recognizer.rotation);
        if(drawing){
            if(recognizer.rotation < 0){
                [self.paintView undo];
                undoCount++;
            }else if(recognizer.rotation > 0){
                [self.paintView redo];
                undoCount--;
            }
        }
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        NSLog(@"rotation ended");
        self.scrollImage.paintView = self.paintView;
    }
}

- (IBAction)drawButtonHit:(id)sender {
    if(drawing){
        drawing = NO;
        drawButton.style = UIBarButtonItemStyleBordered;
        [self hideUndoButton];
        [self endPaintView];
    }else{
        drawing = YES;
        drawButton.style = UIBarButtonItemStyleDone;
        [self showUndoButton];
        [self setupPaintView];
    }
}

- (IBAction)colorButtonHit:(id)sender {
    if(padPopover && padPopover.popoverVisible)
        [padPopover dismissPopoverAnimated:YES];
    [self showColorPicker];
}

- (IBAction)undoButtonHit:(id)sender {
    if(drawing){
        [self.paintView undo];
    }
}

@end
