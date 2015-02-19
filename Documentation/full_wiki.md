% CS 766 - HDR Project Documentation
% Ke Ma; Christopher Bodden
% 2/19/2015

# Welcome to the cs766-hdr wiki!
Here we will describe our tool and results in detail.

## Links:
* Repository: <https://github.com/cbod/cs766-hdr>
* Wiki: <https://github.com/cbod/cs766-hdr/wiki>

## Assignment Description:
High dynamic range (HDR) images have much larger dynamic range than traditional images' 256 brightness levels. In addition, they correspond linearly to physical irradiance values of the scene. Hence, they have many applications in vision. In this project, we implement algorithms to assemble an HDR image from several low dynamic range images.

## Features:
This is a brief description of our implementation. More details can be found in the other pages of the wiki.

### Basic Features:
* Debevec's Method for HDR reconstruction
* Reinhard's tone mapping algorithm
* Simple Gamma Compression tone mapping

### "Bonus" Features:
* Ward's MTB image alignment algorithm
* Drago et al. tone mapping algorithm
* Durand et al. tone mapping algorithm
* GUI to pipeline the image recreation and expose all functions implemented

## Results

### _Friday Night_
Our final image we call _Friday Night_ mainly because we took it on Friday evening. The image features an interesting scene that is great for HDR. The capitol building and street lights are very bright against the dark sky. They also wash out the finer details in the buildings. HDR allows us to preserve these features and present a striking scene.

![Sample Output](images/FridayNight-Durand.jpg)

### Reproducing Our Results

1. Load the LDR images: _FridayNight-x.jpg_
2. Select _FridayNight-ExpTime.txt_
3. Recover the response curve and radiance map
4. Tone map with Durand at contrast set to 6

**Post Processing:**

The only post processing we used was resizing the final image because our original image was taken at 18 megapixels.

### Findings

We found that the best tone mapping algorithm that we implemented was Durand followed by Drago. Both of these produce dramatic, vivid colors. However, Durand tends to preserve more of the finer details. Reinhard, gamma compression, and the built-in MATLAB method all produce less interesting results. The built-in MATLAB method and gamma compression are washed out, while the Reinhard method produces less interesting colors.

## Using the GUI
To make working with our functions easier, we've implemented a simple GUI that streamlines the process and visually displays the results of image operations. Users can open a series of LDR images then align the images, recover the response functions, build the radiance map, and tone map to produce a final result. Or the users can directly open a .hdr file and tone map to produce a final result.

### Starting the GUI
Simple run the file _hdr_gui.m_

### Loading Images
We provide 2 methods to produce radiance map: 1) from a series of LDR images or 2) from a .hdr file

#### Using a series of LDR Images
1. Select Open Files -> Load LDR Images.
2. A dialog will open for you to select all of the LDR images.
3. A second dialog will open to select the .txt file with image exposure times. (The format is shown in the _example_exposure_time.txt_.)
4. Click any of the loaded images to display the enlarged image in a new window.

![Opened LDRs](images/open_LDRs.png)

#### Using a .hdr Image
1. Select Open Files -> Open HDR.

### Image Alignment
_This option is available after opening a series of LDR images successfully._

Simply click Image Tools -> Align Images (MTB). This is an implementation of:

Greg Ward, [Fast Robust Image Registration for Compositing High Dynamic Range Photographs from Hand-Held Exposures](http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.59.277), jgt, 2003.

### Recovering the Response Curves and Producing a Radiance Map
_This option is available after opening a series of LDR images successfully._

Recovering the response curves and producing the radiance map is combined into a single operation. To perform this operation:

1. Select Image Tools -> Recover Curves & Radiance Map.
2. Click on either the displayed radiance map or any of the curves to enlarge the object in a new window.

**Examples:**

GUI After Recovering Response Curves & Radiance Map:

![After Operation](images/GUI_recover_curves.png)

Enlarged Radiance Map:

![Enlarged Radiance Map](images/enlarged_rad_map.png)

Enlarged Response Curve:

![Enlarged Response Curve](images/enlarged_curve.png)

### Tone Mapping
_This option is available after recovering the radiance map from a series of LDR images successfully or opening a .hdr file._

We provide 5 tone mapping methods and parameter settings in the Image Tools -> Tone Map menu. The following explains each option:

### Pick Settings
This menu allows users to tune relevant tone mapping parameters for each specific algorithm. You must click 'Apply' to save the settings.

1. Select Image Tools -> Tone Map -> Settings.
2. Tune any parameter of interest.
3. Click 'Apply'.

![Tone Mapping Settings](images/tonemap_settings.png)

#### Durand Method
This is an implementation of the method describe in:

Fredo Durand, Julie Dorsey, [Fast Bilateral Filtering for the Display of High Dynamic Range Images](http://pages.cs.wisc.edu/~lizhang/courses/cs766-2012f/projects/hdr/DurandBilateral.pdf), SIGGRAPH 2002.

#### Drago Method
This is an implementation of the method describe in:

F. Drago, K. Myszkowski, T. Annen, N. Chiba, [Adaptive Logarithmic Mapping for Displaying High Contrast Scenes](http://pages.cs.wisc.edu/~lizhang/courses/cs766-2012f/projects/hdr/Drago2003ALM.pdf), Eurographics 2003.

#### Reinhard Method
This is an implementation of the global operator method describe in:

Erik Reinhard, Kate Devlin, [Dynamic Range Reduction Inspired by Photoreceptor Physiology](http://pages.cs.wisc.edu/~lizhang/courses/cs766-2012f/projects/hdr/Reinhard2005DRR.pdf), IEEE TVCG 2005.

#### Gamma Compression
This is an implementation of a simple gamma compression as described in class.

#### Built In MATLAB Method
This simply uses the built-in MATLAB tonemap() method. This is provided mainly for reference.

### Saving HDR/Final Images
Using the Save HDR/Final Image menu, we offer two option for saving working. The ability to save the radiance map as a .hdr file and to save the final tone mapped image.

#### Saving .hdr Files
_This option is available after recovering the radiance map from a series of LDR images successfully or opening a .hdr file._

1. Select Save HDR/Final Image -> Save HDR
2. Select the .hdr file destination and name.
3. Click Save

#### Saving Final Images
_This option is available after tone mapping a radiance map._

1. Select Save HDR/Final Image -> Save Final Image
2. Select the image destination and name.
3. Click Save

## Function Descriptions
Below provide basic descriptions of our functions.

#### alignMTB.m
`function alignedImgs = alignMTB(imgs, offsetRange)`

Inputs:

* imgs: a vector of the original RGB images (an image is 3D object, width x height x color channels)
* offsetRange: offset level setting parameter

Outputs:

* alignedImgs: a vector of the aligned images

#### gSolve.m
`function [g,lE] = gSolve(Z,B,l,w)`

Inputs:

* Z: the image (a single channel)
* B: the natural log exposure time values (delta t)
* l: smoothing parameter (lambda)
* w: the weighting matrix

Outputs:

* g: the inverse of f function (response curve)
* lE: the natural log exposure values

#### hdr_gui.m
`function varargout = hdr_gui(varargin)`

This function launches the main GUI window. It is not meant to be called programatically! Please run this as the main script in MATLAB.

#### loadImages.m
`function imgs = loadImages(imgFiles)`

Inputs:

* imgFiles: a vector of image filenames to load

Outputs:

* imgs: a vector of images

#### makeRadmap.m
`function [radmap, rG, gG, bG, rPxVals, gPxVals, bPxVals, rLgExps, gLgExps, bLgExps] = makeRadmap(imgs,expTimes,smoothness)`

Inputs:

* imgs: a vector of images
* expTimes: a vector of exposure time (not log exposure times!)
* smoothness: smoothing parameter for response curve (lambda)

Outputs:

* radmap: the radiance map for the HDR image
* rG: the inverse of f function (response curve) for the red channel
* gG: the inverse of f function (response curve) for the green channel
* bG: the inverse of f function (response curve) for the blue channel
* rPxVals: the sampled (unsmoothed) response pixel values for the red channel
* gPxVals: the sampled (unsmoothed) response pixel values for the green channel
* bPxVals: the sampled (unsmoothed) response pixel values for the blue channel
* rLgExps: the natural log exposure values for the red channel
* gLgExps: the natural log exposure values for the green channel
* bLgExps: the natural log exposure values for the blue channel

#### mergeExps.m
`function E = mergeExps(Z,B,g,w)`

Inputs:

* Z: the image (a single channel)
* B: the natural log exposure time values (delta t)
* g: the response curve function for this channel
* w: the weighting matrix

Outputs:

* E: the merged image for this color channel

#### samplePxs.m
`function Z = samplePxs(imgs)`

Inputs:

* imgs: a vector of images for a single color channel

Outputs:

* Z: a matrix of the pixel values in all of the images at randomly sampled pixel locations

#### toneMapBasic.m (Reinhard global tone mapping)
`function [image] = toneMapBasic(radMap, a)`

Inputs:

* radMap: the radiance map to tone map
* a: a tuning parameter for brightness (steps go: 0.09, 0.18, 0.36, 0.72)

Outputs:

* image: the LDR tone mapped image

#### toneMapDrago.m
`function [image] = toneMapDrago(radMap, b)`

Inputs:

* radMap: the radiance map to tone map
* b: a tuning parameter for bias (range: 0.7 - 1.0)

Outputs:

* image: the LDR tone mapped image

#### toneMapDurand.m
`function image = toneMapDurand(radmap, contrast)`

Inputs:

* radmap: the radiance map to tone map
* contrast: a tuning parameter for image contrast

Outputs:

* image: the LDR tone mapped image

#### toneMapGamma.m (simple gamma compression)
`function [image] = toneMapGamma(radMap, gamma)`

Inputs:

* radMap: the radiance map to tone map
* gamma: a tuning parameter for the gamma value

Outputs:

* image: the LDR tone mapped image 

## Other Files
Some other files that are not meant to be used functionally, but are either needed for the GUI or were used for testing.

#### _enlargeImage.m_
This function is simply a helper to allow enlarging an image when clicked.

#### _tone_map_settings.m_
Launches the tone map settings menu.

#### _hdr_gui.fig_
The MATLAB figure for the main program GUI.

#### _tone_map_settings.fig_
The MATLAB figure for the tone map settings menu.

#### _TestScripts\\alignMTB_test.m_
A script we used to test the MTB alignment method.

#### _TestScripts\\gSolve_test.m_
A script we used to test the solver method for recovering response curves.

#### _TestScripts\\makeRadmap_test.m_
A script we used to test the radiance map creation method.

#### _TestScripts\\mergeExps_test.m_
A script we used to test the exposure merging method.

#### _TestScripts\\toneMap_test.m_
A script we used to test the various tone mapping methods.

## Credits
Below is a break down of the work description. We worked together on taking the images and also helped fix some of each other's bugs!

#### Ke Ma
* Response Curve Solution
* Radiance Map Creation
* MTB Alignment
* Durand Tone Mapping

#### Christopher Bodden
* Drago Tone Mapping
* Reinhart Tone Mapping
* GUI
* Documentation Wiki

## References

1. Paul E. Debevec, Jitendra Malik, [Recovering High Dynamic Range Radiance Maps from Photographs](http://vsingh-www.cs.wisc.edu/cs766-12/lec/debevec-siggraph97.pdf), SIGGRAPH 1997.
2. Greg Ward, [Fast Robust Image Registration for Compositing High Dynamic Range Photographs from Hand-Held Exposures](http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.59.277), jgt, 2003.
3. Fredo Durand, Julie Dorsey, [Fast Bilateral Filtering for the Display of High Dynamic Range Images](http://pages.cs.wisc.edu/~lizhang/courses/cs766-2012f/projects/hdr/DurandBilateral.pdf), SIGGRAPH 2002.
4. F. Drago, K. Myszkowski, T. Annen, N. Chiba, [Adaptive Logarithmic Mapping for Displaying High Contrast Scenes](http://pages.cs.wisc.edu/~lizhang/courses/cs766-2012f/projects/hdr/Drago2003ALM.pdf), Eurographics 2003.
5. Erik Reinhard, Kate Devlin, [Dynamic Range Reduction Inspired by Photoreceptor Physiology](http://pages.cs.wisc.edu/~lizhang/courses/cs766-2012f/projects/hdr/Reinhard2005DRR.pdf), IEEE TVCG 2005.