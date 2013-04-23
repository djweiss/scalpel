#include "mex.h"
#include "mex_utils.h"
#include <stdio.h>
#include <vector>
#include <algorithm>
#include <cmath>


/***********************************************************************/
/***********************************************************************/

void print_usage() {
    mexPrintf("usage: [int area] = mex_seg_intarea(seg, mask, k)\n");
    mexPrintf("   - seg = double(n x m), mask = double(n x m)\n");
    mexPrintf("   - k = scalar double\n");
    mexPrintf("   - int = k x 1 array of sum(seg.*mask) values\n");
    mexPrintf("   - area = k x 1 array of sum(seg) values\n");
    mexErrMsgTxt("**** improper usage detected.\n");
}

void mexFunction(int nlhs, mxArray *out[], int nrhs, const mxArray *in[]){

    if (nrhs != 3 || nlhs != 2){
        print_usage();
        return;
    }
    
    // check seg
    if (!checkInput("seg", in[0], mxDOUBLE_CLASS)) {
        print_usage(); return;
    }
    
    // check mask
    if (!checkInput("mask", in[1], mxDOUBLE_CLASS, mxGetM(in[0]), mxGetN(in[0]))) {
        print_usage(); return;
    }
    
    // check k
    if (!checkInput("k", in[2], mxDOUBLE_CLASS, 1)) {
        print_usage(); return;
    }
   
    vector<int> seg = mxarrayToVector1D<int>(in[0]);
    vector<float> mask = mxarrayToVector1D<float>(in[1]);
    int k = mxGetScalar(in[2]);
    
    vector<float> intersection = vector<float>(k, 0.0);
    vector<float> area = vector<float>(k, 0.0);
    
    for (int i = 0; i < seg.size(); i++) {

        int idx = seg[i]-1;
        if (idx < 0 || idx >= k) {
            char buf[1000];
            sprintf(buf, "seg[%d] = %d is out of bounds!\n", i, idx);
            mexErrMsgTxt(buf);
            return;
        }
        
        intersection[idx] += mask[i];
        area[idx]++;
    }

    out[0] = vectorToMxArray1D<float>(intersection);
    out[1] = vectorToMxArray1D<float>(area);
}