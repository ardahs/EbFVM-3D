//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// sorSolver_FVMbE_JFO_initialize.cpp
//
// Code generation for function 'sorSolver_FVMbE_JFO_initialize'
//

// Include files
#include "sorSolver_FVMbE_JFO_initialize.h"
#include "_coder_sorSolver_FVMbE_JFO_mex.h"
#include "rt_nonfinite.h"
#include "sorSolver_FVMbE_JFO_data.h"

// Function Declarations
static void sorSolver_FVMbE_JFO_once();

// Function Definitions
static void sorSolver_FVMbE_JFO_once()
{
  mex_InitInfAndNan();
}

void sorSolver_FVMbE_JFO_initialize()
{
  emlrtStack st{
      nullptr, // site
      nullptr, // tls
      nullptr  // prev
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2022b(&st);
  emlrtClearAllocCountR2012b(&st, false, 0U, nullptr);
  emlrtEnterRtStackR2012b(&st);
  if (emlrtFirstTimeR2012b(emlrtRootTLSGlobal)) {
    sorSolver_FVMbE_JFO_once();
  }
}

// End of code generation (sorSolver_FVMbE_JFO_initialize.cpp)
