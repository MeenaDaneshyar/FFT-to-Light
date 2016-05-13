//This Processing sketch uses FFT to determin the the frequency of audio detected and maps this data to a light spectrum. As it has proven very difficult to create the 
//visible light spectrum using computer colours I have instead used a image of the visual light spectrum and acording to the frequency take the pixel data from a point 
//along the image and display this across the full screen.

//uses example "FFTSpectrum" from sound library
// Source for where I found the image(saved as a PImage called lightspectrum): https://commons.wikimedia.org/wiki/File:Inverse_visible_spectrum.svg


import processing.sound.*; //import the sound library

//Declare the processing sound variables
FFT fft; //create a new FFT object called fft
AudioIn input; //create a new audio input called input
AudioDevice device; //create a new audio device called device

float maxAmp = 0; //Create a new float to store the value of the largest FFT peak
int maxBand =0; //create a new int to store which band the highest peak relates to
float x;
int bands = 1024;
PImage lightspectrum;
float lastx = 0;
//create an array of floats to store the fft data
float[] spectrum = new float[bands];


void setup(){
 fullScreen();
 colorMode(HSB,100); //instead of using rgb use (hue,saturation and brightness //from colormode reference on Processing website
 lightspectrum = loadImage("spectrum.png");
 
 //If the Buffersize is larger than the FFT size, the FFT will fail
 //so we set Buffersize equal to bands
 device = new AudioDevice(this,44000, bands); //set up the audio device
 
 //Set up and start the audio input
 input = new AudioIn(this,0);
 input.start();
 
 //Set up and patch the FFT analyser
 fft = new FFT(this, bands);
 fft.input(input);
  
  
  
}
void draw(){
  fft.analyze(spectrum); //Tell FFT to run and store the data in "spectrum"
  
   //Reset the variables to find where the maximum fft peak is
  maxAmp =0;
  maxBand =0;
   for(int i=0;i<spectrum.length;i++){
    if(spectrum[i]>maxAmp){
      maxAmp =spectrum[i]; //If the current peak is bigger than the last peak which was stored, overwrite it
      maxBand =i; //Store the band which the peak belongs to
    }
  }
 if(maxBand<=200){ //check if max band is less than 200
   x=map(maxBand, 0, 200, 0,lightspectrum.width); //map the peak band number to a position along the width of the image
   lastx +=(x-lastx)*0.1; //smoothes the data out from the example "FFTSpectrum"
 }
  
 color currentcolour= lightspectrum.get(int(lastx),130); //goes to the positon on the x axis of the image and grabs the colour
 background(currentcolour); 
}