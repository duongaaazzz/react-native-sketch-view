//
//  SketchView.h
//  Sketch
//
//  Created by Keshav on 06/04/17.
//  Copyright © 2017 Particle41. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Paint.h"
#import "SketchTool.h"

@interface SketchView : UIView

-(void) clear;
-(void)setToolType:(SketchToolType) toolType;
-(void)setViewImage:(UIImage *)image;
-(void)setColor:(float)red green:(float)green blue:(float)blue  alpha:(float) alpha;
-(void)setThickness:(float)thickness;

@end
