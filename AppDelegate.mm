//
//  AppDelegate.m
//  Simulation Graphics
//
//  Created by Aaron Liberman on 12/07/2016.
//  Copyright © 2016 Aaron Liberman. All rights reserved.
//

#import "AppDelegate.h"
#import <OpenGL/OpenGL.h>
#import <OpenGL/gl.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/uio.h>
#include <unistd.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include "List.hpp"
#include "vec.hpp"
#include "PointMass.hpp"

NSOpenGLView* glView;
GLuint programID;
GLuint bufferID;
List<PointMass> masses;
void physics();
float radius = 0.01;
float verts[2160];
int Idx = 0;


@interface AppDelegate ()
@property (weak) IBOutlet NSWindow *window;
@end

void
ObserverCallback(
    CFRunLoopObserverRef observer,
    CFRunLoopActivity activity,
    void* info
)
{
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    glUseProgram(programID);
    glBindBuffer(GL_ARRAY_BUFFER, bufferID);
    glEnableVertexAttribArray(glGetAttribLocation(programID, "pos"));
    glVertexAttribPointer(glGetAttribLocation(programID, "pos"), 2, GL_FLOAT, GL_FALSE, 0, 0);
    
    physics();
    
    for(ListNode<PointMass>* i = masses.head(); i != NULL; i = i->next()) {
        glUniform2f(glGetUniformLocation(programID, "orig"), i->value()->position.x, i->value()->position.y);
        glDrawArrays(GL_TRIANGLES, 0, 1080);
    }
        
        
        
    [glView.openGLContext flushBuffer];
    CFRunLoopWakeUp([[NSRunLoop mainRunLoop] getCFRunLoop]);
}


void
setMasses(){
   
   /*
    for(int i= 0; i<6; i++) {
        double r1 = rand()/((double)RAND_MAX);
        double r2 = rand()/((double)RAND_MAX);
        
        double x = -1 +2*r1;
        double y = -1+2*r2;
        
        double vx = x/5;
        double vy = y/5;
        
        PointMass planet(vec(x,y,0), vec(vy,-vx,0), 1);
        
        masses.append(planet);
    }
    
    vec pCM(0,0,0);
    
    for(ListNode<PointMass>* i = masses.head(); i != NULL; i = i->next()) {
        pCM = pCM + i->value()->velocity*i->value()->Mass;
    }
    
    masses.append(PointMass(vec(0,0,0), pCM/5, 5));
   */
 

/*
    PointMass sun(vec(0,0,0), vec(0,0,0), 10);
    PointMass planet1(vec(0.3,0.4,0), vec(-0.2,0.05,0), 1);
    PointMass planet2(vec(-0.3,-0.4,0), vec(0.09,-0.04,0), 1);
    PointMass planet3(vec(0,0.7,0), vec(0.1, 0, 0), 1);
    PointMass planet4(vec(0.5,0.10,0), vec(0, 0.1, 0), 1);
    PointMass planet5(vec(-1,-1,0), vec(0.15, 0.08,0), 2);
    
    masses.append(sun);
    masses.append(planet1);
    masses.append(planet2);
    masses.append(planet3);
    masses.append(planet4);
    masses.append(planet5);
     */
     
    
    PointMass sun(vec(0,0,0), vec(0,0,0), 1);
    PointMass planet1(vec(0.3,0.4,0), vec(0,0,0), 1);
    PointMass planet2(vec(-0.3,-0.4,0), vec(0,0,0), 1);
    PointMass planet3(vec(0,0.7,0), vec(0, 0, 0), 1);
    PointMass planet4(vec(0.5,0.10,0), vec(0, 0, 0), 1);
    PointMass planet5(vec(-1,-1,0), vec(0, 0,0), 1);
    
    masses.append(sun);
    masses.append(planet1);
    masses.append(planet2);
    masses.append(planet3);
    masses.append(planet4);
    masses.append(planet5);
    
    
}


void
physics () {
    
    const double dt = 1/60.0;
    const double G = 0.001;
    const double R = 0.3; //Repulsive force constant

        
        for(int i = 0; i < 1000; i++) {
            double dtPhysics = dt/1000;
            for(ListNode<PointMass>* i = masses.head(); i != NULL; i = i->next()) {
                PointMass* p = i->value();
                p->acceleration = vec(0,0,0);;
            }
            
            for(ListNode<PointMass>* i = masses.head(); i != masses.tail(); i = i->next()) {
                for(ListNode<PointMass>* j = i->next(); j != NULL; j = j->next()) {
                    PointMass* p = i->value();
                    PointMass* q = j->value();
                    
                    vec r = p->position - q->position;
                    double dist = r.length();
                    
                    p->acceleration =  p->acceleration - r*((G*q->Mass)/(dist*dist*dist));
                    q->acceleration =  q->acceleration + r*((G*p->Mass)/(dist*dist*dist));
                    
                    //These are the repulsive forces
                    p->acceleration = p->acceleration + r*((R*q->Mass)/(pow(((dist-2*radius)/radius), 10)));
                    q->acceleration = q->acceleration - r*((R*p->Mass)/(pow(((dist-2*radius)/radius), 10)));

                }
            }
            
            for(ListNode<PointMass>* i = masses.head(); i != NULL; i = i->next()) {
                PointMass* p = i->value();
                p->velocity = p->velocity + p->acceleration*(dtPhysics);
                p->position = p->position + p->acceleration*0.5*(dtPhysics)*(dtPhysics) + p->velocity*(dtPhysics);
            }
        }
}

void
initCircle ()
{
    for(int theta = 0; theta <= 360; theta++) {
        float thetaRad = (theta*M_PI)/180;
        float thetaRadNext = ((theta+1)*M_PI)/180;
        verts[Idx++] = 0;
        verts[Idx++] = 0;
        verts[Idx++] = radius*cos(thetaRad);
        verts[Idx++] = radius*sin(thetaRad);
	verts[Idx++] = radius*cos(thetaRadNext);
	verts[Idx++] = radius*sin(thetaRadNext);
    }
}



@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSOpenGLPixelFormatAttribute attribs[] = {
        NSOpenGLPFADoubleBuffer, 0
    };

    NSOpenGLPixelFormat* pf = [ [NSOpenGLPixelFormat alloc] initWithAttributes: attribs];

    glView = [[NSOpenGLView alloc] initWithFrame:self.window.contentView.frame pixelFormat:pf];
    [self.window.contentView addSubview:glView];
    [glView.openGLContext makeCurrentContext];
    
    printf("%f\n", glView.frame.size.width);
    printf("%f\n", glView.frame.size.height);
    printf("%s\n", glGetString(GL_VENDOR));
    printf("%s\n", glGetString(GL_RENDERER));
    printf("%s\n", glGetString(GL_VERSION));
    printf("%s\n", glGetString(GL_SHADING_LANGUAGE_VERSION));

    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, true, 0, ObserverCallback, NULL);
    CFRunLoopRef runLoop = [[NSRunLoop mainRunLoop] getCFRunLoop];
    CFRunLoopAddObserver(runLoop, observer, kCFRunLoopCommonModes);
    
    int FragFile = open("/Users/aaronliberman/Desktop/Summer-Coding/Simulation1Graphics/Simulation Graphics/Simulation Graphics/ShaderFrag.fs", O_RDONLY);
    void* addr1 = malloc(1000);
    GLint bytesRead1 = (GLint) read(FragFile, addr1, 1000);
    
    int VertFile = open("/Users/aaronliberman/Desktop/Summer-Coding/Simulation1Graphics/Simulation Graphics/Simulation Graphics/ShaderVert.vs", O_RDONLY);
    void* addr2 = malloc(1000);
    GLint bytesRead2 = (GLint) read(VertFile, addr2, 1000);

    programID = glCreateProgram();
    GLuint shaderIDFrag = glCreateShader(GL_FRAGMENT_SHADER);
    GLuint shaderIDVert = glCreateShader(GL_VERTEX_SHADER);
    
    glShaderSource(shaderIDFrag, 1, (const GLchar*const *) &addr1, &bytesRead1);
    glShaderSource(shaderIDVert, 1, (const GLchar*const *) &addr2, &bytesRead2);
    
    glCompileShader(shaderIDFrag);
    
    GLint test;
    GLsizei test2;
    GLchar buff[1000];
    
    glGetShaderiv(shaderIDFrag, GL_COMPILE_STATUS, &test);
    glGetShaderInfoLog(shaderIDFrag, 1000, &test2, buff);
    printf("%d", test);
    printf("%.*s\n", test2, buff);
    
    glCompileShader(shaderIDVert);

    glGetShaderiv(shaderIDVert, GL_COMPILE_STATUS, &test);
    glGetShaderInfoLog(shaderIDVert, 1000, &test2, buff);
    printf("%d", test);
    printf("%.*s\n", test2, buff);
    
    glAttachShader(programID, shaderIDFrag);
    glAttachShader(programID, shaderIDVert);

    glLinkProgram(programID);
    
    GLint lstatus;
    glGetProgramiv(programID, GL_LINK_STATUS, &lstatus);
    printf("%d\n", lstatus);
    
    GLsizei lenout;
    glGetProgramInfoLog(programID, 1000, &lenout, buff);
    printf("%.*s\n", lenout, buff);

    
    glViewport(0,0, glView.frame.size.width, glView.frame.size.height);
    
    initCircle();
    
    setMasses();
    
    glGenBuffers(1, &bufferID);
    glBindBuffer(GL_ARRAY_BUFFER, bufferID);
    glBufferData(GL_ARRAY_BUFFER, 8640, verts, GL_STATIC_DRAW);
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end



