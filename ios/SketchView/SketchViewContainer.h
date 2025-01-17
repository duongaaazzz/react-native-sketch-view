//
//  SketchViewContainer.h
//  Sketch
//
//  Created by Keshav on 06/04/17.
//  Copyright © 2017 Particle41. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SketchView.h"
#import "SketchFile.h"

@interface SketchViewContainer : UIView <UIGestureRecognizerDelegate>

@property(unsafe_unretained, nonatomic) IBOutlet SketchView *sketchView;

- (SketchFile *)saveToLocalCache;
- (BOOL)openSketchFile:(NSString *)localFilePath;
- (void)addZoomGestureWithMin:(CGFloat)min andMax:(CGFloat)max;
- (void)resetScale;

@end
