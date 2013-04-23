SCALPEL: Segmentation Cascades with Localized Priors and Efficient Learning
=======

This is the source code and data files needed to reproduce the experiments from the paper,

  * SCALPEL: Segmentation Cascades with Localized Priors and Efficient Learning. David Weiss and Ben Taskar. CVPR2013.

It includes all third-party tools and dependencies. It has only been tested on 64-bit Unix MATLAB R2012a systems.

Rather than include even more third-party tools (DPM, Objectness, etc.) to generate the bounding boxes used in the experiments of the paper, we include bounding boxes used as input to SCALPEL for every image in the PASCAL VOC2010 validation set. By running the included code with these boxes, you should reproduce the results of the experiments in the paper.

Instructions (important)
========

  * Download the code and extract to a directory. 
  * **If cloning from git**, make sure to run "git submodule init" and "git submodule update" to get the latest dependencies. 
  * **If downloading the zip archive**, make sure to also download and manually extract the _matlab-utils_ submodule from <https://github.com/djweiss/matlab-utils/archive/master.zip>. 
  * Go to that directory and start MATLAB. You need to rname the extracted contest to _matlab-utils_ for this to work.
  * Open scalpel_demo.m and follow the instructions there.


