//
//  SketchViewContainer.m
//  Sketch
//
//  Created by Keshav on 06/04/17.
//  Copyright © 2017 Particle41. All rights reserved.
//

#import "SketchViewContainer.h"

@implementation SketchViewContainer {
    CGFloat minZoom;
    CGFloat maxZoom;
    CGFloat lastScale;
    CGPoint lastPoint;
}

-(BOOL)openSketchFile:(NSString *)localFilePath
{
    UIImage *image = [UIImage imageWithContentsOfFile:localFilePath];
    if(image) {
        [self.sketchView setViewImage:image];
        return YES;
    }
    return NO;
}

-(void)resetScale
{
    self.sketchView.transform = CGAffineTransformIdentity;
}

-(void)addZoomGestureWithMin:(CGFloat)min andMax: (CGFloat)max
{
    minZoom = min;
    maxZoom = max;
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
    [self.sketchView addGestureRecognizer:pinch];
    pinch.delegate = self;
}

-(void)pinch:(UIPinchGestureRecognizer*)sender
{
    if ([sender numberOfTouches] < 2) {
        if (!CGRectContainsRect(self.sketchView.frame, self.frame)) {
            self.sketchView.transform = CGAffineTransformIdentity;
        }
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        lastScale = 1.0;
        lastPoint = [sender locationInView:self.sketchView];
    }
    
    // Scale
    CGFloat scale = 1.0 - (lastScale - sender.scale);
    CGAffineTransform t = CGAffineTransformScale(self.sketchView.transform, scale, scale);
    CGFloat finalScale = sqrt(t.a * t.a + t.c * t.c);
    if (finalScale >= minZoom && finalScale <= maxZoom) {
        self.sketchView.transform = t;
    }
    lastScale = sender.scale;
    
    // Translate
    CGPoint point = [sender locationInView:self.sketchView];
    t = CGAffineTransformTranslate(self.sketchView.transform, point.x - lastPoint.x, point.y - lastPoint.y);
    self.sketchView.transform = t;
    lastPoint = [sender locationInView:self.sketchView];
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (!CGRectContainsRect(self.sketchView.frame, self.frame)) {
            self.sketchView.transform = CGAffineTransformIdentity;
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(SketchFile *)saveToLocalCache
{
    UIImage *image = [SketchViewContainer imageWithView:self];
    
    NSURL *tempDir = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSString *fileName = [NSString stringWithFormat:@"sketch_%@.png", [[NSUUID UUID] UUIDString]];
    NSURL *fileURL = [tempDir URLByAppendingPathComponent:fileName];
    
    NSLog(@"fileURL: %@", [fileURL path]);
    
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToURL:fileURL atomically:YES];
    
    SketchFile *sketchFile = [[SketchFile alloc] init];
    sketchFile.localFilePath = [fileURL path];
    sketchFile.size = [image size];
    return sketchFile;
}

+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.frame.size);
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

@end
