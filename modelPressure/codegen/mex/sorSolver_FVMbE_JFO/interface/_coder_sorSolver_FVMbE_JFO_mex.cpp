//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// _coder_sorSolver_FVMbE_JFO_mex.cpp
//
// Code generation for function '_coder_sorSolver_FVMbE_JFO_mex'
//

// Include files
#include "_coder_sorSolver_FVMbE_JFO_mex.h"
#include "_coder_sorSolver_FVMbE_JFO_api.h"
#include "rt_nonfinite.h"
#include "sorSolver_FVMbE_JFO_data.h"
#include "sorSolver_FVMbE_JFO_initialize.h"
#include "sorSolver_FVMbE_JFO_terminate.h"
#include <stdexcept>

void emlrtExceptionBridge();
void emlrtExceptionBridge()
{
  throw std::runtime_error("");
}
// Function Definitions
void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs,
                 const mxArray *prhs[])
{
  mexAtExit(&sorSolver_FVMbE_JFO_atexit);
  sorSolver_FVMbE_JFO_initialize();
  try {
    sorSolver_FVMbE_JFO_mexFunction(nlhs, plhs, nrhs, prhs);
    sorSolver_FVMbE_JFO_terminate();
  } catch (...) {
    emlrtCleanupOnException((emlrtCTX *)emlrtRootTLSGlobal);
    throw;
  }
}

emlrtCTX mexFunctionCreateRootTLS()
{
  emlrtCreateRootTLSR2022a(&emlrtRootTLSGlobal, &emlrtContextGlobal, nullptr, 1,
                           (void *)&emlrtExceptionBridge, "UTF-8", true);
  return emlrtRootTLSGlobal;
}

void sorSolver_FVMbE_JFO_mexFunction(int32_T nlhs, mxArray *plhs[2],
                                     int32_T nrhs, const mxArray *prhs[11])
{
  emlrtStack st{
      nullptr, // site
      nullptr, // tls
      nullptr  // prev
  };
  const mxArray *b_prhs[11];
  const mxArray *outputs[2];
  int32_T i1;
  st.tls = emlrtRootTLSGlobal;
  // Check for proper number of arguments.
  if (nrhs != 11) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 11, 4,
                        19, "sorSolver_FVMbE_JFO");
  }
  if (nlhs > 2) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 19,
                        "sorSolver_FVMbE_JFO");
  }
  // Call the function.
  for (int32_T i{0}; i < 11; i++) {
    b_prhs[i] = prhs[i];
  }
  sorSolver_FVMbE_JFO_api(b_prhs, nlhs, outputs);
  // Copy over outputs to the caller.
  if (nlhs < 1) {
    i1 = 1;
  } else {
    i1 = nlhs;
  }
  emlrtReturnArrays(i1, &plhs[0], &outputs[0]);
}

// End of code generation (_coder_sorSolver_FVMbE_JFO_mex.cpp)
