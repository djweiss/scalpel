#include "mex.h"
#include "mex_utils.h"
#include <stdio.h>
#include <vector>
#include <algorithm>
#include <cmath>

int maxDepth;

bool followPath(const mxArray *tree, const mwIndex treeIdx, vector<int> &path, vector<float> &ids, int depth) {

    if (treeIdx >= mxGetNumberOfElements(tree)) {
        mexPrintf("Trying to access tree_idx = %d, but only %d elements\n", 
                treeIdx, mxGetNumberOfElements(tree));
        return false;
    }
    
    if (depth < 0 || depth >= path.size()) {
        mexPrintf("Invalid depth %d\n", depth);
        return false;
    }
    
    const mxArray *local_ids = mxGetField(tree, treeIdx, "id");
    if (!local_ids) {mexPrintf("depth %d: tree has no field 'id'\n", depth); return false;}

    int branch = path[depth]-1;
    if (branch < 0 || branch > mxGetNumberOfElements(local_ids)) {
        mexPrintf("Invalid branch %d\n", branch); return false;
    }
    
    ids[depth] = mxGetPr(local_ids)[branch];

    if (depth == (path.size()-1)) {
        return true;
    } else {
        const mxArray *children  = mxGetField(tree, treeIdx, "sub");
        if (!children) {mexPrintf("depth %d: tree has no valid field 'sub'\n", depth); return false;}
        int nchildren = mxGetNumberOfElements(children);

        if (nchildren == 0) {
            mexPrintf("No children left at depth %d\n", depth);
            return false;
        }
        return followPath(children, branch, path, ids, depth+1);
    }
}

bool followPath(const mxArray *tree, vector<int> &path, vector<float> &ids) {
    return followPath(tree, 0, path, ids, 0);
}

/***********************************************************************/
/***********************************************************************/

void print_usage() {
    mexPrintf("usage: [id] = mex_get_hikid(tree, paths)\n");
    mexPrintf("   - tree  = labeled tree from label_hiktree\n");
    mexPrintf("   - paths = output of vl_hikmeanspush\n");
    mexPrintf("   - id    = ids of each level of path\n");
    mexErrMsgTxt("**** improper usage detected.\n");
}

void mexFunction(int nlhs, mxArray *out[], int nrhs, const mxArray *in[]) {
    
    if (nrhs != 2 || nlhs != 1){
        print_usage();
        return;
    }
    
    if (!checkInput("tree", in[0], mxSTRUCT_CLASS)) {
        print_usage(); return;
    }
    
    const char* names[4] = {"depth","id","maxid","sub"};
    for (int i = 0; i < 4; i++) {
        mxArray *m = mxGetField(in[0], 0, names[i]);
        if (!m) {
            char buf[1000];
            sprintf(buf,"tree has no field '%s'\n", names[i]);
            mexPrintf(buf);
            print_usage(); return;
        }
    }

    maxDepth = (int)mxGetScalar(mxGetField(in[0], 0, "depth"));
            
    if (!checkInput("path", in[1], mxDOUBLE_CLASS, mxGetM(in[1]), maxDepth)) {
        print_usage(); return;
    }

    vector<vector<int> > paths = mxarrayToVector2D<int>(in[1]);
    vector<vector<float> > ids = mxarrayToVector2D<float>(in[1]);
    
    for (int i = 0; i < paths.size(); i++) {
        if (!followPath(in[0], paths[i], ids[i])) {
            char buf[1000];
            sprintf(buf, "Failed to parse paths[%d]\n", i);
            mexErrMsgTxt(buf); return;
        }
    }
    
    out[0] = vectorToMxArray(ids);
}

