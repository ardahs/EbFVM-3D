//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// sorSolver_FVMbE_JFO.cpp
//
// Code generation for function 'sorSolver_FVMbE_JFO'
//

// Include files
#include "sorSolver_FVMbE_JFO.h"
#include "rt_nonfinite.h"
#include "sorSolver_FVMbE_JFO_data.h"
#include "blas.h"
#include "coder_array.h"
#include <cstddef>

// Variable Definitions
static emlrtRTEInfo emlrtRTEI{
    55,                    // lineNo
    21,                    // colNo
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m" // pName
};

static emlrtRTEInfo b_emlrtRTEI{
    53,                    // lineNo
    19,                    // colNo
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m" // pName
};

static emlrtBCInfo emlrtBCI{
    -1,                    // iFirst
    -1,                    // iLast
    57,                    // lineNo
    37,                    // colNo
    "B_BC",                // aName
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m", // pName
    0                                                    // checkKind
};

static emlrtBCInfo b_emlrtBCI{
    -1,                    // iFirst
    -1,                    // iLast
    58,                    // lineNo
    35,                    // colNo
    "JA",                  // aName
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m", // pName
    0                                                    // checkKind
};

static emlrtBCInfo c_emlrtBCI{
    -1,                    // iFirst
    -1,                    // iLast
    58,                    // lineNo
    47,                    // colNo
    "JA",                  // aName
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m", // pName
    0                                                    // checkKind
};

static emlrtBCInfo d_emlrtBCI{
    -1,                    // iFirst
    -1,                    // iLast
    61,                    // lineNo
    62,                    // colNo
    "Atheta_BC",           // aName
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m", // pName
    0                                                    // checkKind
};

static emlrtBCInfo e_emlrtBCI{
    -1,                    // iFirst
    -1,                    // iLast
    61,                    // lineNo
    74,                    // colNo
    "Ap_BC",               // aName
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m", // pName
    0                                                    // checkKind
};

static emlrtBCInfo f_emlrtBCI{
    -1,                    // iFirst
    -1,                    // iLast
    59,                    // lineNo
    52,                    // colNo
    "Ap_BC",               // aName
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m", // pName
    0                                                    // checkKind
};

static emlrtBCInfo g_emlrtBCI{
    -1,                    // iFirst
    -1,                    // iLast
    59,                    // lineNo
    65,                    // colNo
    "pHydro",              // aName
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m", // pName
    0                                                    // checkKind
};

static emlrtBCInfo h_emlrtBCI{
    -1,                    // iFirst
    -1,                    // iLast
    59,                    // lineNo
    70,                    // colNo
    "JA",                  // aName
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m", // pName
    0                                                    // checkKind
};

static emlrtBCInfo i_emlrtBCI{
    -1,                    // iFirst
    -1,                    // iLast
    59,                    // lineNo
    91,                    // colNo
    "Atheta_BC",           // aName
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m", // pName
    0                                                    // checkKind
};

static emlrtBCInfo j_emlrtBCI{
    -1,                    // iFirst
    -1,                    // iLast
    59,                    // lineNo
    108,                   // colNo
    "thetaHydro",          // aName
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m", // pName
    0                                                    // checkKind
};

static emlrtBCInfo k_emlrtBCI{
    -1,                    // iFirst
    -1,                    // iLast
    62,                    // lineNo
    85,                    // colNo
    "pHydro",              // aName
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m", // pName
    0                                                    // checkKind
};

static emlrtBCInfo l_emlrtBCI{
    -1,                    // iFirst
    -1,                    // iLast
    63,                    // lineNo
    34,                    // colNo
    "thetaHydro",          // aName
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m", // pName
    0                                                    // checkKind
};

static emlrtBCInfo m_emlrtBCI{
    -1,                    // iFirst
    -1,                    // iLast
    65,                    // lineNo
    44,                    // colNo
    "Ap_BC",               // aName
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m", // pName
    0                                                    // checkKind
};

static emlrtBCInfo n_emlrtBCI{
    -1,                    // iFirst
    -1,                    // iLast
    65,                    // lineNo
    82,                    // colNo
    "pHydro",              // aName
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m", // pName
    0                                                    // checkKind
};

static emlrtBCInfo o_emlrtBCI{
    -1,                    // iFirst
    -1,                    // iLast
    66,                    // lineNo
    84,                    // colNo
    "Ap_BC",               // aName
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m", // pName
    0                                                    // checkKind
};

static emlrtBCInfo p_emlrtBCI{
    -1,                    // iFirst
    -1,                    // iLast
    66,                    // lineNo
    133,                   // colNo
    "thetaHydro",          // aName
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m", // pName
    0                                                    // checkKind
};

static emlrtRTEInfo c_emlrtRTEI{
    49,                    // lineNo
    5,                     // colNo
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m" // pName
};

static emlrtRTEInfo d_emlrtRTEI{
    50,                    // lineNo
    5,                     // colNo
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m" // pName
};

static emlrtRTEInfo e_emlrtRTEI{
    72,                    // lineNo
    40,                    // colNo
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m" // pName
};

static emlrtRTEInfo f_emlrtRTEI{
    73,                    // lineNo
    40,                    // colNo
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m" // pName
};

static emlrtRTEInfo g_emlrtRTEI{
    80,                    // lineNo
    17,                    // colNo
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m" // pName
};

static emlrtRTEInfo h_emlrtRTEI{
    81,                    // lineNo
    17,                    // colNo
    "sorSolver_FVMbE_JFO", // fName
    "/Users/suhaibardah/Library/CloudStorage/Dropbox/MATLAB/1. "
    "LUBST/LUBST++/modelPressure/sorSolver_FVMbE_JFO.m" // pName
};

// Function Definitions
void sorSolver_FVMbE_JFO(const emlrtStack *sp, coder::array<real_T, 2U> &pHydro,
                         coder::array<real_T, 2U> &thetaHydro,
                         const coder::array<uint32_T, 2U> &JA,
                         const coder::array<real_T, 2U> &Ap_BC,
                         const coder::array<real_T, 2U> &Atheta_BC,
                         const coder::array<real_T, 2U> &B_BC, real_T pcav,
                         real_T w_pHydro, real_T w_thetaHydro, real_T maxIter,
                         real_T tol)
{
  ptrdiff_t incx_t;
  ptrdiff_t n_t;
  coder::array<real_T, 2U> pHydroOLD;
  coder::array<real_T, 2U> thetaHydroOLD;
  int32_T i;
  int32_T loop_ub;
  int32_T numIter;
  int32_T numNodes_tmp;
  boolean_T exitg1;
  emlrtHeapReferenceStackEnterFcnR2012b((emlrtConstCTX)sp);
  //  *************************************************************************************************************************************************************
  //  Library   : solverLinear
  //  Function  : Modified SOR solver 2.0 (MSR storage scheme)
  //             Convergence error: relative error 2 (less accurate, faster)
  //  References:
  //     [1] A. Jaramillo, H. M. Checo, and G. Buscaglia.  Non-homogeneous
  //     boundary conditions and cavitation modeling for Reynolds equation
  //     (2016) [2] A. Jaramillo, H. M. Checo, and G. Buscaglia. Incorporation
  //     of back-pressure effects in the modeling of the piston ring/cylinder
  //     liner (2016) [3] H. M. Checo, M. Jai and G. Buscaglia.  An improved
  //     fixed-point algorithm to solve the lubrication problem with cavitation
  //     (2016)
  //
  //  *** INPUTS
  //  **************************************************************************************************************************************************
  //      pHydro ................... (1,N) array with initial guess of the
  //      hydrodynamic pressure [real] thetaHydro ............... (1,N) array
  //      with initial guess of the film fraction [real] JA
  //      ....................... integer (1,Nz) array containing the column
  //      indices of the nonzero values of the matrix
  //                                   - for each element AA(1,k), the integer
  //                                   JA(1,k) represents its column index on
  //                                   the matrix
  //                                   - the n+1 first positions of JA contain
  //                                   the pointer to the beginning of each row
  //                                   in AA and JA
  //      Ap_BC .................... real (1,Nz) array containing the nonzeros
  //      values for pressure solution Atheta_BC ................ real (1,Nz)
  //      array containing the nonzeros values for film fraction solution
  //                                   - the first n positions contain the
  //                                   diagonal elements of the matrix in order
  //                                   - the unused position n+1 may sometimes
  //                                   carry information concerning the matrix
  //                                   - starting at position n+2, the nonzero
  //                                   entries, excluding its diagonal elements,
  //                                   are stored by row
  //      B_BC ..................... real (1,Nz) array containing the elements
  //      of the right side vector of the system [A]{x} = {B_BC} pcav
  //      ..................... threshold for cavitation pressure [real]
  //      w_pHydro ................. relaxation factor for pHydro (0 < w < 2)
  //      [real] w_thetaHydro ............. relaxation factor for thetaHydro (0
  //      < w < 2) [real] maxIter .................. maximum number of
  //      iterations [integer] tol ...................... error tolerance [real]
  //
  //  *** OUTPUTS
  //  *************************************************************************************************************************************************
  //      pHydro ................... (1,N) array with solution of the
  //      hydrodynamic pressure [real] thetaHydro ............... (1,N) array
  //      with solution of the film fraction maxError ................. maximum
  //      error  [real] numIter .................. number of iterations
  //      performed [integer] convFlag ................. flag informing if
  //      convergence was achieved
  //                                    0 - solution found to tolerance
  //                                    1 - no convergence given maxIter
  //
  //  *************************************************************************************************************************************************************
  //    Francisco J. Profito       -     fprofito@hotmail.com
  //    Demetrio C. Zachariadis    -     dczachar@usp.br
  //    Last updated               -     17/10/2011
  //  *************************************************************************************************************************************************************
  //  Inicialization
  numNodes_tmp = pHydro.size(1);
  pHydroOLD.set_size(&c_emlrtRTEI, sp, 1, numNodes_tmp);
  for (i = 0; i < numNodes_tmp; i++) {
    pHydroOLD[i] = pHydro[i];
  }
  loop_ub = thetaHydro.size(1);
  thetaHydroOLD.set_size(&d_emlrtRTEI, sp, 1, loop_ub);
  for (i = 0; i < loop_ub; i++) {
    thetaHydroOLD[i] = thetaHydro[i];
  }
  //  Start iterations
  emlrtForLoopVectorCheckR2021a(1.0, 1.0, maxIter, mxDOUBLE_CLASS,
                                static_cast<int32_T>(maxIter), &b_emlrtRTEI,
                                (emlrtConstCTX)sp);
  numIter = 0;
  exitg1 = false;
  while ((!exitg1) && (numIter <= static_cast<int32_T>(maxIter) - 1)) {
    real_T Bp_res;
    real_T b_pHydroAux_tmp;
    real_T pHydroAux;
    real_T pHydroAux_tmp;
    int32_T b_loop_ub;
    int32_T c_loop_ub;
    for (int32_T oe{0}; oe < 2; oe++) {
      i = static_cast<int32_T>(
          static_cast<real_T>((static_cast<uint32_T>(numNodes_tmp) -
                               static_cast<uint32_T>(oe)) +
                              1U) /
          2.0);
      emlrtForLoopVectorCheckR2021a(
          static_cast<real_T>(oe) + 1.0, 2.0, static_cast<real_T>(numNodes_tmp),
          mxDOUBLE_CLASS, i, &emlrtRTEI, (emlrtConstCTX)sp);
      for (int32_T p{0}; p < i; p++) {
        real_T d;
        uint32_T b_p;
        uint32_T q0;
        uint32_T qY;
        uint32_T u;
        boolean_T b;
        b_p = (static_cast<uint32_T>(oe) + static_cast<uint32_T>(p << 1)) + 1U;
        //  Calculate pressure
        if ((static_cast<int32_T>(b_p) < 1) ||
            (static_cast<int32_T>(b_p) > B_BC.size(1))) {
          emlrtDynamicBoundsCheckR2012b(static_cast<int32_T>(b_p), 1,
                                        B_BC.size(1), &emlrtBCI,
                                        (emlrtConstCTX)sp);
        }
        Bp_res = B_BC[static_cast<int32_T>(b_p) - 1];
        loop_ub = JA.size(1);
        if ((static_cast<int32_T>(b_p) < 1) ||
            (static_cast<int32_T>(b_p) > JA.size(1))) {
          emlrtDynamicBoundsCheckR2012b(static_cast<int32_T>(b_p), 1,
                                        JA.size(1), &b_emlrtBCI,
                                        (emlrtConstCTX)sp);
        }
        u = JA[static_cast<int32_T>(b_p) - 1];
        if ((static_cast<int32_T>(b_p + 1U) < 1) ||
            (static_cast<int32_T>(b_p + 1U) > JA.size(1))) {
          emlrtDynamicBoundsCheckR2012b(static_cast<int32_T>(b_p + 1U), 1,
                                        JA.size(1), &c_emlrtBCI,
                                        (emlrtConstCTX)sp);
        }
        q0 = JA[static_cast<int32_T>(b_p)];
        qY = q0 - 1U;
        if (q0 - 1U > q0) {
          qY = 0U;
        }
        for (q0 = u; q0 <= qY; q0++) {
          if ((static_cast<int32_T>(q0) < 1) ||
              (static_cast<int32_T>(q0) > Ap_BC.size(1))) {
            emlrtDynamicBoundsCheckR2012b(static_cast<int32_T>(q0), 1,
                                          Ap_BC.size(1), &f_emlrtBCI,
                                          (emlrtConstCTX)sp);
          }
          b_loop_ub = pHydro.size(1);
          if ((static_cast<int32_T>(q0) < 1) ||
              (static_cast<int32_T>(q0) > loop_ub)) {
            emlrtDynamicBoundsCheckR2012b(static_cast<int32_T>(q0), 1, loop_ub,
                                          &h_emlrtBCI, (emlrtConstCTX)sp);
          }
          c_loop_ub = static_cast<int32_T>(JA[static_cast<int32_T>(q0) - 1]);
          if ((c_loop_ub < 1) || (c_loop_ub > b_loop_ub)) {
            emlrtDynamicBoundsCheckR2012b(c_loop_ub, 1, b_loop_ub, &g_emlrtBCI,
                                          (emlrtConstCTX)sp);
          }
          if ((static_cast<int32_T>(q0) < 1) ||
              (static_cast<int32_T>(q0) > Atheta_BC.size(1))) {
            emlrtDynamicBoundsCheckR2012b(static_cast<int32_T>(q0), 1,
                                          Atheta_BC.size(1), &i_emlrtBCI,
                                          (emlrtConstCTX)sp);
          }
          b_loop_ub = thetaHydro.size(1);
          if (c_loop_ub > b_loop_ub) {
            emlrtDynamicBoundsCheckR2012b(c_loop_ub, 1, b_loop_ub, &j_emlrtBCI,
                                          (emlrtConstCTX)sp);
          }
          Bp_res = (Bp_res - Ap_BC[static_cast<int32_T>(q0) - 1] *
                                 pHydro[c_loop_ub - 1]) +
                   Atheta_BC[static_cast<int32_T>(q0) - 1] *
                       thetaHydro[c_loop_ub - 1];
          if (*emlrtBreakCheckR2012bFlagVar != 0) {
            emlrtBreakCheckR2012b((emlrtConstCTX)sp);
          }
        }
        b = ((static_cast<int32_T>(b_p) < 1) ||
             (static_cast<int32_T>(b_p) > Atheta_BC.size(1)));
        if (b) {
          emlrtDynamicBoundsCheckR2012b(static_cast<int32_T>(b_p), 1,
                                        Atheta_BC.size(1), &d_emlrtBCI,
                                        (emlrtConstCTX)sp);
        }
        if ((static_cast<int32_T>(b_p) < 1) ||
            (static_cast<int32_T>(b_p) > Ap_BC.size(1))) {
          emlrtDynamicBoundsCheckR2012b(static_cast<int32_T>(b_p), 1,
                                        Ap_BC.size(1), &e_emlrtBCI,
                                        (emlrtConstCTX)sp);
        }
        pHydroAux_tmp = Ap_BC[static_cast<int32_T>(b_p) - 1];
        b_pHydroAux_tmp = Atheta_BC[static_cast<int32_T>(b_p) - 1];
        pHydroAux = (Bp_res + b_pHydroAux_tmp) / pHydroAux_tmp;
        loop_ub = pHydro.size(1);
        if ((static_cast<int32_T>(b_p) < 1) ||
            (static_cast<int32_T>(b_p) > loop_ub)) {
          emlrtDynamicBoundsCheckR2012b(static_cast<int32_T>(b_p), 1, loop_ub,
                                        &k_emlrtBCI, (emlrtConstCTX)sp);
        }
        pHydro[static_cast<int32_T>(b_p) - 1] =
            w_pHydro * pHydroAux +
            (1.0 - w_pHydro) * pHydro[static_cast<int32_T>(b_p) - 1];
        loop_ub = thetaHydro.size(1);
        if ((static_cast<int32_T>(b_p) < 1) ||
            (static_cast<int32_T>(b_p) > loop_ub)) {
          emlrtDynamicBoundsCheckR2012b(static_cast<int32_T>(b_p), 1, loop_ub,
                                        &l_emlrtBCI, (emlrtConstCTX)sp);
        }
        thetaHydro[static_cast<int32_T>(b_p) - 1] = 1.0;
        //  Check cavitation
        if ((static_cast<int32_T>(b_p) < 1) ||
            (static_cast<int32_T>(b_p) > Ap_BC.size(1))) {
          emlrtDynamicBoundsCheckR2012b(static_cast<int32_T>(b_p), 1,
                                        Ap_BC.size(1), &m_emlrtBCI,
                                        (emlrtConstCTX)sp);
        }
        d = pHydroAux_tmp * pcav;
        if (pHydroAux * pHydroAux_tmp > d) {
          loop_ub = pHydro.size(1);
          if ((static_cast<int32_T>(b_p) < 1) ||
              (static_cast<int32_T>(b_p) > loop_ub)) {
            emlrtDynamicBoundsCheckR2012b(static_cast<int32_T>(b_p), 1, loop_ub,
                                          &n_emlrtBCI, (emlrtConstCTX)sp);
          }
          if (pHydro[static_cast<int32_T>(b_p) - 1] < pcav) {
            if ((static_cast<int32_T>(b_p) < 1) ||
                (static_cast<int32_T>(b_p) > Ap_BC.size(1))) {
              emlrtDynamicBoundsCheckR2012b(static_cast<int32_T>(b_p), 1,
                                            Ap_BC.size(1), &o_emlrtBCI,
                                            (emlrtConstCTX)sp);
            }
            loop_ub = thetaHydro.size(1);
            if ((static_cast<int32_T>(b_p) < 1) ||
                (static_cast<int32_T>(b_p) > loop_ub)) {
              emlrtDynamicBoundsCheckR2012b(static_cast<int32_T>(b_p), 1,
                                            loop_ub, &p_emlrtBCI,
                                            (emlrtConstCTX)sp);
            }
            thetaHydro[static_cast<int32_T>(b_p) - 1] =
                w_thetaHydro / b_pHydroAux_tmp * (d - Bp_res) +
                (1.0 - w_thetaHydro) *
                    thetaHydro[static_cast<int32_T>(b_p) - 1];
            pHydro[static_cast<int32_T>(b_p) - 1] = pcav;
          }
        }
        if (*emlrtBreakCheckR2012bFlagVar != 0) {
          emlrtBreakCheckR2012b((emlrtConstCTX)sp);
        }
      }
      if (*emlrtBreakCheckR2012bFlagVar != 0) {
        emlrtBreakCheckR2012b((emlrtConstCTX)sp);
      }
    }
    //  Compute error (relative error 2, less accurate and faster)
    if (pHydro.size(1) == 0) {
      Bp_res = 0.0;
    } else if (pHydro.size(1) < 1) {
      Bp_res = 0.0;
    } else {
      n_t = (ptrdiff_t)pHydro.size(1);
      incx_t = (ptrdiff_t)1;
      Bp_res = dnrm2(&n_t, &pHydro[0], &incx_t);
    }
    loop_ub = pHydro.size(1);
    pHydroOLD.set_size(&e_emlrtRTEI, sp, 1, loop_ub);
    b_loop_ub = pHydro.size(1) - 1;
    for (i = 0; i <= b_loop_ub; i++) {
      pHydroOLD[i] = pHydro[i] - pHydroOLD[i];
    }
    if (pHydroOLD.size(1) == 0) {
      pHydroAux_tmp = 0.0;
    } else {
      n_t = (ptrdiff_t)pHydroOLD.size(1);
      incx_t = (ptrdiff_t)1;
      pHydroAux_tmp = dnrm2(&n_t, &pHydroOLD[0], &incx_t);
    }
    if (thetaHydro.size(1) == 0) {
      b_pHydroAux_tmp = 0.0;
    } else if (thetaHydro.size(1) < 1) {
      b_pHydroAux_tmp = 0.0;
    } else {
      n_t = (ptrdiff_t)thetaHydro.size(1);
      incx_t = (ptrdiff_t)1;
      b_pHydroAux_tmp = dnrm2(&n_t, &thetaHydro[0], &incx_t);
    }
    b_loop_ub = thetaHydro.size(1);
    thetaHydroOLD.set_size(&f_emlrtRTEI, sp, 1, b_loop_ub);
    c_loop_ub = thetaHydro.size(1) - 1;
    for (i = 0; i <= c_loop_ub; i++) {
      thetaHydroOLD[i] = thetaHydro[i] - thetaHydroOLD[i];
    }
    if (thetaHydroOLD.size(1) == 0) {
      pHydroAux = 0.0;
    } else {
      n_t = (ptrdiff_t)thetaHydroOLD.size(1);
      incx_t = (ptrdiff_t)1;
      pHydroAux = dnrm2(&n_t, &thetaHydroOLD[0], &incx_t);
    }
    //  Check error
    if (pHydroAux_tmp * (Bp_res / ((Bp_res + 1.0E-30) * (Bp_res + 1.0E-30))) +
            pHydroAux * (b_pHydroAux_tmp / ((b_pHydroAux_tmp + 1.0E-30) *
                                            (b_pHydroAux_tmp + 1.0E-30))) <=
        tol) {
      exitg1 = true;
    } else {
      pHydroOLD.set_size(&g_emlrtRTEI, sp, 1, loop_ub);
      for (i = 0; i < loop_ub; i++) {
        pHydroOLD[i] = pHydro[i];
      }
      thetaHydroOLD.set_size(&h_emlrtRTEI, sp, 1, b_loop_ub);
      for (i = 0; i < b_loop_ub; i++) {
        thetaHydroOLD[i] = thetaHydro[i];
      }
      numIter++;
    }
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b((emlrtConstCTX)sp);
    }
  }
  emlrtHeapReferenceStackLeaveFcnR2012b((emlrtConstCTX)sp);
}

// End of code generation (sorSolver_FVMbE_JFO.cpp)
