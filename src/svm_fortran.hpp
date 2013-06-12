#include <stdlib.h>
#include "svm.h"

extern "C"
{
    void svmtrain(svm_problem *prob, svm_parameter *param);
    void svmdatafinalize(svm_problem *prob, svm_parameter *param);
    svm_problem *svmproblemcreate(svm_problem *prob, int n);
    svm_problem *svmproblemadddata(svm_problem *prob, double y, int yidx, int *xidx, double *xval, int n);
    void svmproblemprintdata(svm_problem *prob, int i);
    svm_parameter *svmparametercreate(svm_parameter *param);
    svm_parameter *svmparameterset(svm_parameter *param, const char *optstr, void *val);
    void svmparameterprint(svm_parameter *param);
}
