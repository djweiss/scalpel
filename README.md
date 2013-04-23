SCALPEL: Segmentation Cascades with Localized Priors and Efficient Learning
=======

This is the source code and data files needed to reproduce the experiments from the paper,

  * SCALPEL: Segmentation Cascades with Localized Priors and Efficient Learning. David Weiss and Ben Taskar. CVPR2013.

It includes all third-party tools and dependencies. It has only been tested on 64-bit Unix MATLAB R2012a systems.

Rather than include even more third-party tools (DPM, Objectness, etc.) to generate the bounding boxes used in the experiments of the paper, we include bounding boxes used as input to SCALPEL for every image in the PASCAL VOC2010 validation set. By running the included code with these boxes, you should reproduce the results of the experiments in the paper.

Instructions 
========

  * Download the code and extract to a directory. Go to that directory and start MATLAB.
  * Open scalpel_demo.m and follow the instructions there.


