//
//  GlissView.h
//  Gliss
//
//  Created by Can on 2/11/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GlissView : NSOpenGLView

@property (strong) IBOutlet NSMatrix *sliderMatrix;
@property (weak) IBOutlet NSSlider *slider1;

@property float lightX;
@property float theta;
@property float radius;
@property int displayList;

- (IBAction)changeParameter:(id)sender;

@end
