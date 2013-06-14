#include <stdlib.h>
#include "svm.h"

extern "C"
{
    double svmpredict(svm_model *model, int *xidx, double *xval, int n);
    svm_model *svmtrain(svm_problem *prob, svm_parameter *param);
    svm_model *svmmodeldestroy(svm_model *model);
    void svmdatafinalize(svm_problem *prob, svm_parameter *param);
    svm_problem *svmproblemcreate(int n);
    svm_problem *svmproblemdestroy(svm_problem *prob);
    svm_problem *svmproblemadddata(svm_problem *prob, double y, int yidx, int *xidx, double *xval, int n);
    void svmproblemprintdata(svm_problem *prob, int i);
    svm_parameter *svmparametercreate();
    svm_parameter *svmparameterdestroy(svm_parameter *param);
    svm_parameter *svmparameterset(svm_parameter *param, const char *optstr, void *val);
    void svmparameterprint(svm_parameter *param);
}
