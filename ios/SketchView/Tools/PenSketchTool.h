//
//  PenSketchTool.h
//  Sketch
//
//  Created by Keshav on 08/04/17.
//  Copyright © 2017 Particle41. All rights reserved.
//

#import "PathTrackingSketchTool.h"
#import "ToolThickness.h"
#import "ToolColor.h"
#import "ToolOpacity.h"

@interface PenSketchTool : PathTrackingSketchTool<ToolThickness, ToolColor, ToolOpacity>

@end
