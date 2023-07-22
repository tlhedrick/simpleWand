# simpleWand
MATLAB-based graphical interface for multi-camera calibration using paired points, unpaired points, various sources of scale information, and many 
other options. simpleWand uses the MATLAB Computer Vision toolbox for better compatibility with Mathworks tools and a less fragile set of calibration operations. However, the Mathworks bundle adjustment routines operate on the camera extrinsics only, so intrinsics must already be known from another source, e.g. a
checkerboard calibration.
