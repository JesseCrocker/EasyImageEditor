#import <UIKit/UIKit.h>


@interface JCTwoFingerRotationGestureRecognizer : UIGestureRecognizer 
{
    
}

/**
 The rotation of the gesture in radians since its last change.
 */
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) CGPoint lastPoint;

@end
