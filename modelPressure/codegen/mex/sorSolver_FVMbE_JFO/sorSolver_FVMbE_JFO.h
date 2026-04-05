//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// sorSolver_FVMbE_JFO.h
//
// Code generation for function 'sorSolver_FVMbE_JFO'
//

#pragma once

// Include files
#include "rtwtypes.h"
#include "coder_array.h"
#include "emlrt.h"
#include "mex.h"
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

// Function Declarations
void sorSolver_FVMbE_JFO(const emlrtStack *sp, coder::array<real_T, 2U> &pHydro,
                         coder::array<real_T, 2U> &thetaHydro,
                         const coder::array<uint32_T, 2U> &JA,
                         const coder::array<real_T, 2U> &Ap_BC,
                         const coder::array<real_T, 2U> &Atheta_BC,
                         const coder::array<real_T, 2U> &B_BC, real_T pcav,
                         real_T w_pHydro, real_T w_thetaHydro, real_T maxIter,
                         real_T tol);

// End of code generation (sorSolver_FVMbE_JFO.h)
