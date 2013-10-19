Libcluster
==========


Author: Daniel Steinberg,
        Australian Centre for Field Robotics,
        The University of Sydney

Date:   13/03/2013

License: GPL v3 (See LICENSE)


This library implements the following algorithms, classes and functions:
 
 * The Variational Dirichlet Process (VDP) [1]
 * The Bayesian Gaussian Mixture Model [2]
 * The Grouped Mixtures Clustering (GMC) model [3]
 * The Symmetric Grouped Mixtures Clustering (S-GMC) model [3]
 * Simultaneous Clustering Model for Multinomial Documents, and Gaussian 
   Observations [3].
 * Multiple-source Clustering Model (MCM) for clustering two observations,
   one of an image/document, and mulltiple of segments/words 
   simultaneously [3]. 
 * And more clustering algorithms based on diagonal Gaussian, and 
   Exponential distributions.
 * Various functions for evaluating means, standard deviations, covariance,
   primary eigenvalues etc of data.

REFERENCES:
----------

 [1] K. Kurihara, M. Welling, and N. Vlassis, Accelerated variational
     Dirichlet process mixtures, Advances in Neural Information Processing
     Systems, vol. 19, p. 761, 2007.

 [2] C. M. Bishop, Pattern Recognition and Machine Learning. Cambridge, UK:
     Springer Science+Business Media, 2006.
     
 [3] D. M. Steinberg, An Unsupervised Approach to Modelling Visual Data, PhD
     Thesis, 2013.
     
Please consider citing reference [3] or 

     D. M. Steinberg, A. Friedman, O. Pizarro, and S. B. Williams. A Bayesian 
     nonparametric approach to clustering data from underwater robotic surveys.
     In International Symposium on Robotics Research, Flagstaff, AZ, Aug. 2011.

if you use this code. Thanks!


DEPENDENCIES
------------

- Eigen version 3.0 or greater
- Boost version 1.4.x or greater
- OpenMP, comes default with most compilers (not LLVM).
- CMake


INSTALL INSTRUCTIONS (Linux/OS X) 
---------------------------------

To build libcluster:

1. Make sure you have CMake installed, and Eigen and Boost preferably in the 
   usual locations:

        /usr/local/include/eigen3/ or /usr/include/eigen3
        /usr/local/include/boost or /usr/include/boost

2. Make sure you have checked out CMakeUtils to the same location as libcluster

3. Make a build directory where you checked out the source if it does not
   already exist, then change into this directory,

        cd {where you checked out the source}
        mkdir build
        cd build

4. To build libcluster, run the following from the build directory:

        cmake ..
        make
        sudo make install

        (This installs:)
   
        libcluster.h    /usr/local/include
        distributions.h /usr/local/include
        probutils.h     /usr/local/include
        libcluster.*    /usr/local/lib     (* this is either .dylib or .so)

5. Use the doxyfile in {where you checked out the source}/doc to make the
   documentation with doxygen:

        doxygen Doxyfile

NOTE: There are few options you can change using ccmake (or the cmake gui), these include:
   
- BUILD_EXHAUST_SPLIT (toggle ON or OFF, default OFF)
      This uses the exhaustive cluster split heuristic instead of the greedy
      heuristic. The greedy heuristic is MUCH faster, but does give different
      results. I have yet to determine whether it is actually worse than the
      exhaustive method. The SCM and MCM use greedy split heuristics by
      default at this stage.

 - BUILD_PYTHON_INTERFACE (toggle ON or OFF, default OFF)
      Build the python interface. This requires boost python. Unfortunately, if
      this is enabled, then the matlab interface cannot be built. This is
      because python is row-major, and matlab is column major, so we need to
      build Eigen accordingly.
      
 - CMAKE_INSTALL_PREFIX (default /usr/local)
      The default prefix for installing the library and binaries.
      
 - EIGEN_INCLUDE_DIRS (default /usr/include/eigen3)
      Where to look for the Eigen matrix library.  
    
NOTE: On linux you may have to run "sudo ldconfig" before the system can find
   libcluster.so.


PYTHON INTERFACE (Linux)
------------------------

Easy, follow the normal build instructions up to step (4) (if you haven't
already), then from the build directory:

    cmake ..
    ccmake ..

Make sure BUILD_PYTHON_INTERFACE is ON

    make
    sudo make install

This installs all the same files as step (4), as well as libclusterpy.so to your
python staging directory, so it should be on your python path. I.e. just run

    import libclusterpy

Look at the "libclusterpy" docstrings for more help on usage. 


MATLAB INTERFACE (Linux/OS X)
-----------------------------

I have included a mex interface for using this library with Matlab. You just
need to make sure that:

  a) You have used a 32 bit compiler if you have 32 bit Matlab (or 64 bit 
     compiler for 64 bit Matlab).

  b) The compiler you have used is similar to Matlab's (I have found that if you
      are off by a minor version number it is ok still).

To build the Matlab interface:

  1) Make sure you have matlab installed and the mex binary is in the system 
     path.
     
  2) In the build directory from step 3 above, run 
   
      make matint
      
     This generates the Matlab binaries in the "matlab" directory where you 
     checked out the source. You can copy or link them to Matlab's path as you 
     wish. This will fail if you have enabled the python interface.

Notes:

 - Either the build will warn you, or running the .m files will fail if your
   compiler is not compatible with Matlab. If you get the warning, you may not
   need to do anything (see below if running the code after compilation fails).
   To fix this with Ubuntu 10.10 and 11.04 I did the following:

   1) run $ sudo apt-get install gcc-4.x-base g++-4.x-base libstdc++6-4.x-dev
      Where 'x' is the version number that Matlab uses (or close too 4.3 for
      10.10 or 4.4 for 11.04 seems to work).

   2) Built the library as in the install instructions, BUT replaced:

      cmake ..

      with

      CC=gcc-4.x CXX=g++-4.x cmake ..
      
   3) rebuild the mex interface.

 - If you are issued with a warning/error something along the lines of:

    ??? Invalid MEX-file '.../vdpcluster_mex.mexa64':
    /../sys/os/glnxa64/libstdc++.so.6: version `GLIBCXX_3.4.11' not found
    (required by /.../libcluster.so).

    try one of the following:

    a) Run matlab as follows (can use a script for this)
      
        $ export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.XX
        $ matlab -desktop

       Where XX is your libstdc++ library version (for ubuntu 12.04, XX=16).

    b) change the symbolic link ~/.maltab/bin/gcc to point to the version of gcc
       you are using in /usr/bin/gcc-4.x

    c) if no such directory exists you can remove the symlinks in Matlab's root 
       to its own copy's of the C and C++ libraries, so it will then use your 
       systems,

        $ cd <MATLABROOT>/sys/os/glnxa64
        $ mv libstdc++.so.6.0.10 libstdc++.so.6.0.10.bak  (or closest version)
        $ mv libstdc++.so.6 libstdc++.so.6.bak
        $ mv libgcc_s.so.1  libgcc_s.so.1.bak

       Matlab should now automatically look for the correct system libraries.

- If you are using OS X, and the version of matlab you are using cannot find the
  system heaters, have a look at ~/.matlab/R20xxx/mexopts.sh and change all 
  lines:

    SDKROOT='/Developer/SDKs/MacOSX10.X.sdk'
    MACOSX_DEPLOYMENT_TARGET='10.X'

  To your version of OS X, e.g. 10.7.


USABILITY TIPS
--------------

When verbose mode is activated you will get output that looks something like
this:

   Learning MODEL X...
   --------<=>
   ---<==>
   --------x<=>
   --------------<====>
   ----<*>
   ---<>
   Finished!
   Number of clusters = 4
   Free Energy = 41225

What this means:
   '-' iteration of Variational Bayes (VBE and VBM step)
   '<' cluster splitting has started (model selection)
   '=' found a valid candidate split
   '>' chosen candidate split and testing for inclusion into model
   'x' clusters have been deleted because they became devoid of observations
   '*' clusters (image/document clusters) that are empty have been removed. 

For best clustering results, I have found the following tips may help:

0)  If clustering runs REALLY slowly then it may be because of hyper-threading.
    OpenMP will by default use as many cores available to it as possible, this
    includes virtual hyper-threading cores. Unfortunately this may result in
    large slow-downs, so try only allowing these functions to use a number of
    threads less than or equal to the number of PHYSICAL cores on your machine.

1)  Garbage in = garbage out. Make sure your assumptions about the data are 
    reasonable for the type of cluster distribution you use. For instance, if  
    your observations do not resemble a mixture of Gaussians in feature space,
    then it may not be appropriate to use Gaussian clusters.

2)  For Gaussian clusters: standardising or whitening your data may help, i.e.

    if X is an NxD matrix of observations you wish to cluster, you may get
    better results if you use a standardised version of it, X*,

      X_s = C * ( X - mean(X) ) / std(X)

    where C is some constant (optional) and the mean and std are for each 
    column of X.
    
    You may obtain even better results by using PCA or ZCA whitening on X 
    (assuming ZERO MEAN data), using Matlab syntax:
    
      [U, S, V] = svd(cov(X));
    
      X_w = X * U * diag(1./sqrt(diag(S)));   % PCA Whitening
      
    Such that cov(X_w) = I_D.
    
    Also, to get some automatic scaling you can multiply the prior by the 
    PRINCIPAL eigenvector of cov(X) (or cov(X_s), cov(X_w)).
    
    NOTE: If you use diagonal covariance Gaussians I STRONGLY recommend PCA or 
          ZCA whitening your data first, otherwise you may end up with hundreds
          of clusters!
          
3)  For Exponential clusters: Your observations have to be in the range [0,inf).
    The clustering solution may also be sensitive to the prior. I find usually 
    using a prior value that has the approximate magnitude of your data or more
    leads to better convergence.
