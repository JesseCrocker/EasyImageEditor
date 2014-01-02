//
//  JCColorPickerViewController.m
//  imageEditor
//
//  Created by Jesse Crocker on 7/25/12.
//  Copyright (c) 2012 Jesse Crocker. All rights reserved.
//  https://github.com/JesseCrocker
//

#import "JCColorPickerViewController.h"

@interface JCColorPickerViewController ()

@end

@implementation JCColorPickerViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.delegate = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)colorButtonHit:(UIButton *)sender {
    if(delegate){
        [delegate setColor:sender.backgroundColor];
    }
}
@end
