# Welcome to our cs766 hdr project!

## Links
* Repository: <https://github.com/cbod/cs766-hdr>
* Wiki: <https://github.com/cbod/cs766-hdr/wiki>
* Credits and usage info can be found in the offline html wiki or in our Github wiki.

## Group Members:
Ke Ma, Christopher Bodden

## Assignment Description:
High dynamic range (HDR) images have much larger dynamic range than traditional images' 256 brightness levels. In addition, they correspond linearly to physical irradiance values of the scene. Hence, they have many applications in vision. In this project, we implement algorithms to assemble an HDR image from several low dynamic range images.

## Features:
This is a brief description of our implementation. More details can be found in the wiki.

### Basic Features:
* Debevec's Method for HDR reconstruction
* Gamma Compression Tone Mapping Algorithm
* Reinhard's Tone Mapping Algorithm

### "Bonus" Features:
* Ward's MTB Image Alignment Algorithm
* Drago's Tone Mapping Algorithm
* Durand's Tone Mapping Algorithm
* GUI to Pipeline the Image Recreation and Expose All Functions Implemented

## Program Screenshot:
[[Documentation/images/GUI_Snapshot.jpg|alt=Program Screenshot]]

## Image to be Vote:
[[Documentation/images/FridayNight-Durand.jpg|alt=Sample Output]]

## TODO:
* [X] Identify & photograph our scene
* [X] Finalize HDR assembly code
* [X] Finalize radiance map code
* [X] Implement 1 or more of: 
  - [X] Image alignment method
  - [ ] HDR creation methods such as Mitsunaga and Nayar's algorithm
  - [X] Any tone mapping algorithms other than Reinhard's --> Drago et al. & Durand et al.
  - [ ] Implement one or more extensions listed in the HDR section of Chapter 10
  - [ ] Run a small experiment with HDR video
* [X] Finish GUI 
* [X] Documentation
* [X] Clean up/Comment code
