#include "linalg.h"
#include "mexutils.h"

/*  
Copyright 2018-2020 Quoc-Tin Phan
Write to quoctin.phan@unitn.it
*/

template <typename T> 
    inline void callFunction (mxArray* plhs[], const mxArray* prhs[]) {
        // A, lambda, rho, alpha, max_iters
        if(!mexCheckType<T>(prhs[0])) 
            mexErrMsgTxt("type of argument 1 is not consistent");
        if(!mxIsDouble(prhs[1]))
            mexErrMsgTxt("argument 2 must be a double scalar");
        if(!mxIsDouble(prhs[2]))
            mexErrMsgTxt("argument 3 must be a double scalar");
        if(!mxIsDouble(prhs[3]))
            mexErrMsgTxt("argument 4 must be a double scalar");
        if(!mxIsDouble(prhs[4]))
            mexErrMsgTxt("argument 5 must be a double scalar");
        if(!mxIsDouble(prhs[5]))
            mexErrMsgTxt("argument 6 must be a double scalar");

        T lambda, rho, alpha, max_iters, stopping_thr;

        const mwSize* dimsA=mxGetDimensions(prhs[0]);
        int m = static_cast<int>(dimsA[0]);
        int n = static_cast<int>(dimsA[1]);
        if(m < n)
            mexErrMsgTxt("this solver only supports thin matrix");
        
        /* extract input arguments */
        T* Apr = reinterpret_cast<T*>(mxGetPr(prhs[0]));
        lambda = mxGetScalar(prhs[1]);
        rho = mxGetScalar(prhs[2]);
        alpha = mxGetScalar(prhs[3]);
        max_iters = mxGetScalar(prhs[4]);
        stopping_thr = mxGetScalar(prhs[5]);
        
        /* create output argument*/
        plhs[0] = createMatrix<T>(n,n);
        T* Zpr = reinterpret_cast<T*>(mxGetPr(plhs[0]));
        
        /* algorithm starts here*/
        Matrix<T> Z(Zpr, n, n);
        Z.setZeros();
        Matrix<T> Y(n, n);
        Y.setZeros();
        
        Matrix<T> A(Apr, m, n);
        Matrix<T> AtA(n, n);
        A.XtX(AtA);
        A.clear();
        
        mwSize i;
        Matrix<T> Ztmp(n, n);
        Matrix<T> X(n, n);
        Matrix<T> Xhat(n, n);
        Matrix<T> E(n, n);
        Vector<T> vec;
        // cholesky decomp
        /* copy A because it works in-place */
        Matrix<T> Alow(n, n);
        Alow.copy(AtA);
        T *Bwork = new T[n*n];
        T *Awork = new T[n*n];
        cholesky_decomp(Alow, rho, Awork);
        
        for(i = 0; i < max_iters; i++) {
            Ztmp.copy(Z);
            Ztmp.sub(Y);
            Ztmp.scal(rho);
            X.copy(AtA);
            X.add(Ztmp);
            /*solve_linear by giving L,U*/
            
            solve_linear(Alow, X, Bwork);
            X.setDiag(0.0); /* remove diagonal of X */
            
            /* update Z with relaxation */
            Xhat.copy(X);
            Xhat.scal(alpha);
            Ztmp.copy(Z);
            Ztmp.scal(1-alpha);
            Xhat.add(Ztmp); // Xhat <-- alpha*X + (1-alpha)*Z
            Ztmp.copy(Xhat);
            Ztmp.add(Y);
            Ztmp.softThrshold(lambda/rho);
            Ztmp.setDiag(0.0); /* remove diagonal of Z */
            Z.update_pos(Ztmp);
            
            /* check stopping condition */
            E.copy(X);
            E.sub(Z); /* E <- X - Z*/
            E.toVect(vec);
            vec.abs_vec();
            if(vec.maxval() < stopping_thr){
               break;
            }
            
            /* update Y */
            Xhat.sub(Z); /* Xhat <- Xhat - Z*/
            Y.add(Xhat); /* Y <- Y + Xhat */
        }
        //mexPrintf("number of iterations: %d\n",i-1);
        /* clearing */
        AtA.clear();
        Y.clear();
        Ztmp.clear();
        Xhat.clear();
        X.clear();
        E.clear();
        vec.clear();
        Alow.clear();
        delete[](Bwork);
        delete[](Awork);
}

template <typename T> 
    inline void cholesky_decomp(Matrix<T>& A, T rho, T* Awork) {
        static char lower = 'L';
        INTT info = 0;
        INTT m = A.m();
        INTT n = A.n();
        A.addDiag(rho); // A <- A + rho*I
        memcpy(Awork, A.X(), m*n*sizeof(T));
        /* Cholesky decomposition */
        int result = potrf(lower, n, Awork, m, info);
        if(result != 0) {
            mexErrMsgTxt("Cholesky decomposition fails.");
        }
        /* solution is updated to A */
        A.setData(Awork, m, n);
}


template <typename T> 
    inline void solve_linear(Matrix<T>& A, Matrix<T>& B, T* Bwork) {
        /* Solve AX = B with A = L*U', L: lower triangle, U: upper triangle */
        static char lower = 'L';
        INTT info = 0;
        INTT m = A.m();
        INTT n = A.n();
        T *Awork = new T[m*n];
        memcpy(Awork, A.X(), m*n*sizeof(T));
        /* copy B because it works in-place */
        INTM k = B.m();
        memcpy(Bwork, B.X(), n*k*sizeof(T));
        int result = potrs(lower, n, k, Awork, n, Bwork, n, info);
        
        if(result != 0) {
            mexErrMsgTxt("Linear system solving fails.");
        }
        /* solution is updated to B*/
        B.setData(Bwork, k, n);
        /* clearing*/
        delete[](Awork);
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    if(nrhs != 6) {
        mexErrMsgTxt("Bad number of input argument(s).");
    }
    if (nlhs != 1) {
        mexErrMsgTxt("Bad number of output argument(s).");
    }
    if (mxGetClassID(prhs[0]) == mxDOUBLE_CLASS)
        callFunction<double>(plhs, prhs);
    else
        callFunction<float>(plhs, prhs);
}
