#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "svm_fortran.hpp"

void svmproblemcreate_(svm_problem *prob, int *n, int *nf)
{
    prob -> l = *n;
    prob -> y = new double [*n];
    prob -> x = new svm_node *[*n];
}

void svmproblemadddata_(svm_problem *prob, double *y, int *yidx, int *xidx, double *xval, int *n)
{
    printf("SIZE is: %d\n", prob -> l);
    printf("Y is: %f\n", *y);
    for (int i = 0; i < *n; i++)
    {
       printf("INDEX: %d  VALUE: %f\n", *(xidx + i), *(xval + i));
    }
    prob -> y[*yidx - 1] = *yidx;
    printf("Y is now: %f\n", prob -> y[*yidx-1]);
    svm_node *xtemp = new svm_node [*n+1];
    for (int i = 0; i < *n; i++)
    {
      xtemp[i].index = xidx[i];
      xtemp[i].value = xval[i];
      printf("%d, %f\n", xtemp[i].index, xtemp[i].value);
    }
    xtemp[*n].index = -1;
    xtemp[*n].value = 0;
    prob -> x[*yidx - 1] = &xtemp[0];
    printf("%d %f\n", (prob -> x[*yidx - 1] +1) -> index, (prob -> x[*yidx - 1] +1) -> value);
}


void svmparametercreate_(svm_parameter *param)
{
    printf("HELLO\n");

    param -> svm_type = C_SVC;
    param -> kernel_type = RBF;
    param -> degree = 3;
    param -> gamma = 0;    // 1/num_features
    param -> coef0 = 0;
    param -> nu = 0.5;
    param -> cache_size = 100;
    param -> C = 1;
    param -> eps = 1e-3;
    param -> p = 0.1;
    param -> shrinking = 1;
    param -> probability = 0;
    param -> nr_weight = 0;
    param -> weight_label = NULL;
    param -> weight = NULL;
}

void svmparameterprint_(svm_parameter *param)
{

    printf("SVM TYPE: %d\n", param -> svm_type);
    printf("KERNEL TYPE: %d\n", param -> kernel_type);
    printf("DEGREE: %d\n", param -> degree);
    printf("GAMMA: %f\n", param -> gamma);
    printf("COEF0: %f\n", param -> coef0);
    printf("Nu: %f\n", param -> nu);
    printf("Cache Size: %f\n", param -> cache_size);
    printf("C: %f\n", param -> C);
    printf("EPS: %f\n", param -> eps);
    printf("P: %f\n", param -> p);
    printf("SHRINKING: %d\n", param -> shrinking);
    printf("PROBABILITY: %d\n", param -> probability);
    printf("NR WEIGHT: %d\n", param -> nr_weight);

}

void svmparametersetsvmtype_(svm_parameter *param, const char *valstr)
{
    char *cvalstr;

    // Convert fortran to c strings
    cvalstr = deblank(valstr);

    // Check string options 
    if (strcmp(cvalstr,"c_svc") == 0)
      param -> svm_type = C_SVC;
    else if (strcmp(cvalstr,"nu_svc") == 0)
      param -> svm_type = NU_SVC;
    else if (strcmp(cvalstr,"one_class") == 0)
      param -> svm_type = ONE_CLASS;
    else if (strcmp(cvalstr,"epsilon_svr") == 0)
      param -> svm_type = EPSILON_SVR;
    else if (strcmp(cvalstr,"nu_svr") == 0)
      param -> svm_type = NU_SVR;
    else
      printf("svm_type input not recognized\n");
}

void svmparametersetkerneltype_(svm_parameter *param, const char *valstr)
{
    char *cvalstr;

    // Convert fortran to c strings
    cvalstr = deblank(valstr);

    // Check string options 
    if (strcmp(cvalstr,"linear") == 0)
      param -> kernel_type = LINEAR;
    else if (strcmp(cvalstr,"poly") == 0)
      param -> svm_type = POLY;
    else if (strcmp(cvalstr,"rbf") == 0)
      param -> svm_type = RBF;
    else if (strcmp(cvalstr,"sigmoid") == 0)
      param -> svm_type = SIGMOID;
    else if (strcmp(cvalstr,"precomputed") == 0)
      param -> svm_type = PRECOMPUTED;
    else
      printf("svm_type input not recognized\n");
}
void svmparametersetdegree_(svm_parameter *param, int *val)
{
    param -> degree = *val;
}

void svmparametersetgamma_(svm_parameter *param, double *val)
{
    param -> gamma = *val;
}

void svmparametersetcoef0_(svm_parameter *param, double *val)
{
    param -> coef0 = *val;
}

void svmparametersetcachesize_(svm_parameter *param, int *val)
{
    param -> cache_size = *val;
}

void svmparameterseteps_(svm_parameter *param, double *val)
{
    param -> eps = *val;
}

void svmparametersetc_(svm_parameter *param, double *val)
{
    param -> C = *val;
}

void svmparametersetnu_(svm_parameter *param, double *val)
{
    param -> nu = *val;
}

void svmparametersetp_(svm_parameter *param, double *val)
{
    param -> p = *val;
}

void svmparametersetshrinking_(svm_parameter *param, int *val)
{
    param -> shrinking = *val;
}

void svmparametersetprobability_(svm_parameter *param, int *val)
{
    param -> probability = *val;
}
