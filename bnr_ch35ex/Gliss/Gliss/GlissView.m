//
//  GlissView.m
//  Gliss
//
//  Created by Can on 2/11/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "GlissView.h"
#import <GLUT/glut.h>

#define LIGHT_X_TAG 0
#define THETA_TAG 1
#define RADIUS_TAG 2

@implementation GlissView

- (void)prepare {
    NSLog(@"prepare");
    
    NSOpenGLContext *glcontext = self.openGLContext;
    [glcontext makeCurrentContext];
    
    glShadeModel(GL_SMOOTH);
    glEnable(GL_LIGHTING);
    glEnable(GL_DEPTH_TEST);
    
    GLfloat ambient[] = {0.2, 0.2, 0.2, 1.0};
    glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambient);
    
    GLfloat diffuse[] = {1.0, 1.0, 1.0, 1.0};
    glLightfv(GL_LIGHT0, GL_DIFFUSE, diffuse);
    glEnable(GL_LIGHT0);
    
    GLfloat mat[] = {0.1, 0.1, 0.7, 1.0};
    glMaterialfv(GL_FRONT, GL_AMBIENT, mat);
    glMaterialfv(GL_FRONT, GL_DIFFUSE, mat);
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self prepare];
    }
    return self;
}

- (void)reshape {
    NSLog(@"reshaping");

    // Convert up to window space, which is in pixel units
    NSRect baseRect = [self convertRectToBase:self.bounds];
    // the result is now glViewport-compatible
    glViewport(0, 0, baseRect.size.width, baseRect.size.height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(60.0, baseRect.size.width/baseRect.size.height, 0.2, 7);
}

- (void)awakeFromNib {
    [self changeParameter:self];
}

- (IBAction)changeParameter:(id)sender {
//    NSLog(@"%f", [[self.sliderMatrix cellWithTag:RADIUS_TAG] floatValue]);
    self.lightX = 1; //[[self.sliderMatrix cellWithTag:LIGHT_X_TAG] floatValue];
    self.theta = 0; //[[self.sliderMatrix cellWithTag:THETA_TAG] floatValue];
    self.radius = 4; //[[self.sliderMatrix cellWithTag:RADIUS_TAG] floatValue];
    NSLog(@"aa%f", self.radius);
    
    NSLog(@"sa%f, %f", self.radius, [self.slider1 floatValue]);
    self.radius = [self.slider1 floatValue];
//    self.radius = [[self.sliderMatrix cellWithTag:RADIUS_TAG] floatValue];
    NSLog(@"sb%f, %f", self.radius, [self.slider1 floatValue]);
    
    NSLog(@"bb%f", self.radius);
    NSLog(@"cc%f", [[self.sliderMatrix cellWithTag:RADIUS_TAG] floatValue]);
    [self setNeedsDisplay:YES];
    [self drawRect:self.bounds];
}



- (void)drawRect:(NSRect)dirtyRect {
//    [super drawRect:dirtyRect];
    
    // clear the background
    glClearColor(0.2, 0.4, 0.1, 0.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // set the view point
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    NSLog(@"dd%f", self.radius);

    gluLookAt(self.radius * sin(self.theta), 0, self.radius * cos(self.theta), 0, 0, 0, 0, 1, 0);
    
    // put the light in place
    GLfloat lightPosition[] = {self.lightX, 1, 3, 0.0};
    glLightfv(GL_LIGHT0, GL_POSITION, lightPosition);
    
    if (!self.displayList) {
        self.displayList = glGenLists(1);
        glNewList(self.displayList, GL_COMPILE_AND_EXECUTE);
        
        // draw
        glTranslatef(0, 0, 0);
        glutSolidTorus(0.3, 0.9, 35, 31);
        glTranslatef(0, 0, 0.6);
        glutSolidTorus(0.3, 1.8, 35, 31);
        
        glEndList();
    } else {
        glCallList(self.displayList);
    }
    
    // flush to screen
    glFinish();
}


@end
