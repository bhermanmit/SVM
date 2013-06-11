#include <stdlib.h>
#include "svm.h"
#define Malloc(type,n) (type *)malloc((n)*sizeof(type))

char * deblank (const char *str)
{
  char *out, *put;
  out = const_cast<char *>(str);
  put = const_cast<char *>(str);

  for(; *str != '\0'; ++str)
  {
    if(*str != ' ')
      *put++ = *str;
  }
  *put = '\0';

  return out;
}

extern "C"
{
    void svmproblemcreate_(svm_problem *prob, int *n, int *nf);
    void svmproblemadddata_(svm_problem *prob, double *y, int *yidx, int *xidx, double *xval, int *n);
    void svmparametercreate_(svm_parameter *param);
    void svmparameterprint_(svm_parameter *param);
    void svmparametersetsvmtype_(svm_parameter *param, const char *valstr);
    void svmparametersetkerneltype_(svm_parameter *param, const char *valstr);
    void svmparametersetdegree_(svm_parameter *param, int *val);
    void svmparametersetgamma_(svm_parameter *param, double *val);
    void svmparametersetcoef0_(svm_parameter *param, double *val);
    void svmparametersetcachesize_(svm_parameter *param, int *val);
    void svmparameterseteps_(svm_parameter *param, double *val);
    void svmparametersetc_(svm_parameter *param, double *val);
    void svmparametersetnu_(svm_parameter *param, double *val);
    void svmparametersetp_(svm_parameter *param, double *val);
    void svmparametersetshrinking_(svm_parameter *param, int *val);
    void svmparametersetprobability_(svm_parameter *param, int *val);
}
