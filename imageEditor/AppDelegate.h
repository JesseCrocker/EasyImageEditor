//
//  AppDelegate.h
//  imageEditor
//
//  Created by Jesse Crocker on 7/24/12.
//  Copyright (c) 2012 Jesse Crocker. All rights reserved.
//  https://github.com/JesseCrocker
//

#import <UIKit/UIKit.h>

@class drawableImageViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) drawableImageViewController *viewController;

@end
