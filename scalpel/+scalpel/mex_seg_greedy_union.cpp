#include "mex.h"
#include "mex_utils.h"
#include <stdio.h>
#include <vector>
#include <algorithm>
#include <cmath>


/***********************************************************************/
/***********************************************************************/

void print_usage() {
    mexPrintf("usage: [mask] = mex_seg_greedy_union(seg, mask, idx)\n");
    mexPrintf("   - seg = double(n x m), mask = double(n x m), idx = double(k x 1)\n");
    mexPrintf("   - mask = n x m union of segments\n");
    mexErrMsgTxt("**** improper usage detected.\n");
}

void mexFunction(int nlhs, mxArray *out[], int nrhs, const mxArray *in[]){

    if (nrhs != 2 || nlhs != 1){
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
    
    // check idx
    if (!checkInput("idx", in[2], mxDOUBLE_CLASS, mxGetM(in[0}), 1)) {
        print_usage(); return;
    }
    
    vector<int> seg = mxarrayToVector1D<int>(in[0]);
    vector<float> mask = mxarrayToVector1D<float>(in[1]);

    
    vector<float> keep = mxarrayToVector1D<float>(in[1]);
    int k = keep.size();
    
    vector<float> mask = vector<float>(seg.size(), 0);

    for (int i = 0; i < seg.size(); i++) {

        int idx = seg[i]-1;
        if (idx < 0 || idx >= k) {
            char buf[1000];
            sprintf(buf, "seg[%d] = %d is out of bounds!\n", i, idx);
            mexErrMsgTxt(buf);
            return;
        }
        
        mask[i] = keep[idx];
    }

    out[0] = vectorToMxArray2D<float>(mask, mxGetM(in[0]), mxGetN(in[0]));
}