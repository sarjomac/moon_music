/**
  *Johanna McAllister
  *Carnegie Mellon 
  *
  *
  *Ideas to fix space-issue: 
  *    >Fourier Transform
  *        - I need to find documentation of this transformation for Processing
  *    >research audio file compression
  */

import ddf.minim.*;

Minim minim;
AudioPlayer groove;
int mm = 25; // adjust mm to adjust scale on screen;
float laser_res = 0.035*mm;
float rad_out, rad_in;
float row_spacing, val_spacing;
float margin;
float begin, end;
int center_x;
int center_y;

//Draw metal ring for reference. 
//where we can draw is a gray area
void draw_ring()
{
  ellipseMode(RADIUS);
  fill(255);
  ellipse(0, 0, rad_out, rad_out);
  fill(200);
  ellipse(0, 0, begin, begin);
  fill(255);
  ellipse(0, 0, end, end);
  fill(0);
  ellipse(0, 0, rad_in, rad_in);
}

//red reference lines along which waveforms will be drawn
void draw_spiral()
{
  smooth();
  noFill();
  float theta = 0;
  float b = row_spacing/(TWO_PI);
  float a = begin;
  float r = begin;
  
  beginShape();
  //keep spiraling towards center until reach the inner margin
  while(r>end)
  {
    theta += PI*val_spacing;
    r = a-(b*theta);
    //^from http://www.intmath.com/blog/mathematics/length-of-an-archimedean-spiral-6595
    stroke(255, 50, 50);
    vertex((r)*sin(theta),(r)*cos(theta));
  }  
  endShape();
}

//reference points on (or in between) which samples of audio waves will be drawn
void draw_spiral_points()
{
  strokeWeight(3);
  float theta = 0;
  float b = row_spacing/(TWO_PI);
  float a = begin;
  float r = begin;
  
  //keep spiraling towards center until reach the inner margin
  while(r>end)
  {
    theta += PI*val_spacing;
    r = a-(b*theta);
    //^from http://www.intmath.com/blog/mathematics/length-of-an-archimedean-spiral-6595
    stroke(50, 50, 255);
    point((r)*sin(theta),(r)*cos(theta));
  }  
  
}

void draw_reference()
{
  background(0);
  strokeWeight(laser_res);
  stroke(255);
  translate(center_x, center_y);
  draw_ring();
  draw_spiral();
  draw_spiral_points();
}

void draw_waveform()
{
  // draw samples of the total waveforms over time
  //I need to find out how to do the following all within setup
  //I need to attach these portions to the spiral
  //I need to compress these values to fit into the space, I will take the average values
  strokeWeight(laser_res);
  translate(-center_x,0);
  for(int i = 0; i < groove.bufferSize() - 1; i++)
  {
    float x1 = map( i, 0, groove.bufferSize(), 0, width );
    float x2 = map( i+1, 0, groove.bufferSize(), 0, width );
    line( x1, 50 + groove.left.get(i)*50, x2, 50 + groove.left.get(i+1)*50 );
  }
}


void setup()
{
  size(1024, 750);
  center_x = width/2;//change center values to change position of everything
  center_y = height/2;
  
  //tools to create ring;
  rad_out = (39.0/2.0)*mm;
  rad_in = (33.0/2.0)*mm;
  
  //tools to create spiral;
  margin = 0.5*mm;
  row_spacing = 0.2*mm; //I don't know what exact values this is, I'm only hoping it produces 0.2 mm spacing
  val_spacing = 0.005;
  //val_spacing controls spacing between adjacent points, but I don't
  //know how or what # is optimal to create 1 laser_res distance between points
  //I need to figure out a formula that determine exact values val_spacing produces 
  //for the distance between adjacent points
  begin = rad_out-margin;
  end = rad_in+margin;

  //get audio file;
  String filename = "moon_music/earth_1.mp3";
  minim = new Minim(this);
  groove = minim.loadFile(filename, 1024);
  groove.loop(); 
  //groove.loop() plays audio AND draws audio, but how to do separately? 
  //Do I need loop() to draw all of the file?
  
  
  //draw_reference(); //uncomment when you figure out how to draw_waveform in setup;
  //draw_waveform();
}

void draw()
{
  draw_reference();
  draw_waveform();
}
