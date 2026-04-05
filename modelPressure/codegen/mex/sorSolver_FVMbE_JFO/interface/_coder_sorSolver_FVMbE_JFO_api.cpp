//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// _coder_sorSolver_FVMbE_JFO_api.cpp
//
// Code generation for function '_coder_sorSolver_FVMbE_JFO_api'
//

// Include files
#include "_coder_sorSolver_FVMbE_JFO_api.h"
#include "rt_nonfinite.h"
#include "sorSolver_FVMbE_JFO.h"
#include "sorSolver_FVMbE_JFO_data.h"
#include "coder_array.h"

// Function Declarations
static void b_emlrt_marshallIn(const emlrtStack &sp, const mxArray *src,
                               const emlrtMsgIdentifier *msgId,
                               coder::array<real_T, 2U> &ret);

static void b_emlrt_marshallIn(const emlrtStack &sp, const mxArray *src,
                               const emlrtMsgIdentifier *msgId,
                               coder::array<uint32_T, 2U> &ret);

static real_T b_emlrt_marshallIn(const emlrtStack &sp, const mxArray *src,
                                 const emlrtMsgIdentifier *msgId);

static void emlrt_marshallIn(const emlrtStack &sp, const mxArray *b_nullptr,
                             const char_T *identifier,
                             coder::array<real_T, 2U> &y);

static void emlrt_marshallIn(const emlrtStack &sp, const mxArray *u,
                             const emlrtMsgIdentifier *parentId,
                             coder::array<real_T, 2U> &y);

static void emlrt_marshallIn(const emlrtStack &sp, const mxArray *b_nullptr,
                             const char_T *identifier,
                             coder::array<uint32_T, 2U> &y);

static void emlrt_marshallIn(const emlrtStack &sp, const mxArray *u,
                             const emlrtMsgIdentifier *parentId,
                             coder::array<uint32_T, 2U> &y);

static real_T emlrt_marshallIn(const emlrtStack &sp, const mxArray *b_nullptr,
                               const char_T *identifier);

static real_T emlrt_marshallIn(const emlrtStack &sp, const mxArray *u,
                               const emlrtMsgIdentifier *parentId);

static void emlrt_marshallOut(coder::array<real_T, 2U> &u, const mxArray *y);

// Function Definitions
static void b_emlrt_marshallIn(const emlrtStack &sp, const mxArray *src,
                               const emlrtMsgIdentifier *msgId,
                               coder::array<real_T, 2U> &ret)
{
  static const int32_T dims[2]{1, -1};
  int32_T iv[2];
  boolean_T bv[2]{false, true};
  emlrtCheckVsBuiltInR2012b((emlrtConstCTX)&sp, msgId, src, "double", false, 2U,
                            (const void *)&dims[0], &bv[0], &iv[0]);
  ret.prealloc(iv[0] * iv[1]);
  ret.set_size(static_cast<emlrtRTEInfo *>(nullptr), &sp, iv[0], iv[1]);
  ret.set(static_cast<real_T *>(emlrtMxGetData(src)), ret.size(0), ret.size(1));
  emlrtDestroyArray(&src);
}

static void b_emlrt_marshallIn(const emlrtStack &sp, const mxArray *src,
                               const emlrtMsgIdentifier *msgId,
                               coder::array<uint32_T, 2U> &ret)
{
  static const int32_T dims[2]{1, -1};
  int32_T iv[2];
  boolean_T bv[2]{false, true};
  emlrtCheckVsBuiltInR2012b((emlrtConstCTX)&sp, msgId, src, "uint32", false, 2U,
                            (const void *)&dims[0], &bv[0], &iv[0]);
  ret.prealloc(iv[0] * iv[1]);
  ret.set_size(static_cast<emlrtRTEInfo *>(nullptr), &sp, iv[0], iv[1]);
  ret.set(static_cast<uint32_T *>(emlrtMxGetData(src)), ret.size(0),
          ret.size(1));
  emlrtDestroyArray(&src);
}

static real_T b_emlrt_marshallIn(const emlrtStack &sp, const mxArray *src,
                                 const emlrtMsgIdentifier *msgId)
{
  static const int32_T dims{0};
  real_T ret;
  emlrtCheckBuiltInR2012b((emlrtConstCTX)&sp, msgId, src, "double", false, 0U,
                          (const void *)&dims);
  ret = *static_cast<real_T *>(emlrtMxGetData(src));
  emlrtDestroyArray(&src);
  return ret;
}

static void emlrt_marshallIn(const emlrtStack &sp, const mxArray *b_nullptr,
                             const char_T *identifier,
                             coder::array<real_T, 2U> &y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = const_cast<const char_T *>(identifier);
  thisId.fParent = nullptr;
  thisId.bParentIsCell = false;
  emlrt_marshallIn(sp, emlrtAlias(b_nullptr), &thisId, y);
  emlrtDestroyArray(&b_nullptr);
}

static void emlrt_marshallIn(const emlrtStack &sp, const mxArray *u,
                             const emlrtMsgIdentifier *parentId,
                             coder::array<real_T, 2U> &y)
{
  b_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void emlrt_marshallIn(const emlrtStack &sp, const mxArray *b_nullptr,
                             const char_T *identifier,
                             coder::array<uint32_T, 2U> &y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = const_cast<const char_T *>(identifier);
  thisId.fParent = nullptr;
  thisId.bParentIsCell = false;
  emlrt_marshallIn(sp, emlrtAlias(b_nullptr), &thisId, y);
  emlrtDestroyArray(&b_nullptr);
}

static void emlrt_marshallIn(const emlrtStack &sp, const mxArray *u,
                             const emlrtMsgIdentifier *parentId,
                             coder::array<uint32_T, 2U> &y)
{
  b_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static real_T emlrt_marshallIn(const emlrtStack &sp, const mxArray *b_nullptr,
                               const char_T *identifier)
{
  emlrtMsgIdentifier thisId;
  real_T y;
  thisId.fIdentifier = const_cast<const char_T *>(identifier);
  thisId.fParent = nullptr;
  thisId.bParentIsCell = false;
  y = emlrt_marshallIn(sp, emlrtAlias(b_nullptr), &thisId);
  emlrtDestroyArray(&b_nullptr);
  return y;
}

static real_T emlrt_marshallIn(const emlrtStack &sp, const mxArray *u,
                               const emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = b_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static void emlrt_marshallOut(coder::array<real_T, 2U> &u, const mxArray *y)
{
  emlrtMxSetData((mxArray *)y, &(u.data())[0]);
  emlrtSetDimensions((mxArray *)y, u.size(), 2);
  u.no_free();
}

void sorSolver_FVMbE_JFO_api(const mxArray *const prhs[11], int32_T nlhs,
                             const mxArray *plhs[2])
{
  coder::array<real_T, 2U> Ap_BC;
  coder::array<real_T, 2U> Atheta_BC;
  coder::array<real_T, 2U> B_BC;
  coder::array<real_T, 2U> pHydro;
  coder::array<real_T, 2U> thetaHydro;
  coder::array<uint32_T, 2U> JA;
  emlrtStack st{
      nullptr, // site
      nullptr, // tls
      nullptr  // prev
  };
  const mxArray *prhs_copy_idx_0;
  const mxArray *prhs_copy_idx_1;
  real_T maxIter;
  real_T pcav;
  real_T tol;
  real_T w_pHydro;
  real_T w_thetaHydro;
  st.tls = emlrtRootTLSGlobal;
  emlrtHeapReferenceStackEnterFcnR2012b(&st);
  prhs_copy_idx_0 = emlrtProtectR2012b(prhs[0], 0, true, -1);
  prhs_copy_idx_1 = emlrtProtectR2012b(prhs[1], 1, true, -1);
  // Marshall function inputs
  pHydro.no_free();
  emlrt_marshallIn(st, emlrtAlias(prhs_copy_idx_0), "pHydro", pHydro);
  thetaHydro.no_free();
  emlrt_marshallIn(st, emlrtAlias(prhs_copy_idx_1), "thetaHydro", thetaHydro);
  JA.no_free();
  emlrt_marshallIn(st, emlrtAlias(prhs[2]), "JA", JA);
  Ap_BC.no_free();
  emlrt_marshallIn(st, emlrtAlias(prhs[3]), "Ap_BC", Ap_BC);
  Atheta_BC.no_free();
  emlrt_marshallIn(st, emlrtAlias(prhs[4]), "Atheta_BC", Atheta_BC);
  B_BC.no_free();
  emlrt_marshallIn(st, emlrtAlias(prhs[5]), "B_BC", B_BC);
  pcav = emlrt_marshallIn(st, emlrtAliasP(prhs[6]), "pcav");
  w_pHydro = emlrt_marshallIn(st, emlrtAliasP(prhs[7]), "w_pHydro");
  w_thetaHydro = emlrt_marshallIn(st, emlrtAliasP(prhs[8]), "w_thetaHydro");
  maxIter = emlrt_marshallIn(st, emlrtAliasP(prhs[9]), "maxIter");
  tol = emlrt_marshallIn(st, emlrtAliasP(prhs[10]), "tol");
  // Invoke the target function
  sorSolver_FVMbE_JFO(&st, pHydro, thetaHydro, JA, Ap_BC, Atheta_BC, B_BC, pcav,
                      w_pHydro, w_thetaHydro, maxIter, tol);
  // Marshall function outputs
  pHydro.no_free();
  emlrt_marshallOut(pHydro, prhs_copy_idx_0);
  plhs[0] = prhs_copy_idx_0;
  if (nlhs > 1) {
    thetaHydro.no_free();
    emlrt_marshallOut(thetaHydro, prhs_copy_idx_1);
    plhs[1] = prhs_copy_idx_1;
  }
  emlrtHeapReferenceStackLeaveFcnR2012b(&st);
}

// End of code generation (_coder_sorSolver_FVMbE_JFO_api.cpp)
