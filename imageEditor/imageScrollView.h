#import <UIKit/UIKit.h>
#import "PaintView.h"

@interface ImageScrollView : UIScrollView <UIScrollViewDelegate> {
    UIView        *imageView;
    NSUInteger     index;
}
@property (nonatomic, strong) UIView *imageView;
@property (assign) NSUInteger index;
@property (nonatomic, strong) PaintView *paintView;
@property (assign) float maxScreenMultiplier;

- (void)displayImage:(UIImage *)image;
- (void)setMaxMinZoomScalesForCurrentBounds;

- (CGPoint)pointToCenterAfterRotation;
- (CGFloat)scaleToRestoreAfterRotation;
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale;

-(void)zoomToMinnimumZoom;

-(void)enableScrolling;
-(void)disableScrolling;
@end
