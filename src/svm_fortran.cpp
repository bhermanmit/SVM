#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "svm_fortran.hpp"

char *trim(const char *str)
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

svm_model *svmtrain(svm_problem *prob, svm_parameter *param)
{
    svm_model *model = new svm_model;
    model = svm_train(prob, param);
    return model;
}

void svmdatafinalize(svm_problem *prob, svm_parameter *param)
{
    const char *error_msg;

    error_msg = svm_check_parameter(prob, param);

    if (error_msg)
    {
      fprintf(stderr, "ERROR: %s\n", error_msg);
      exit(1);
    }
}

svm_problem *svmproblemcreate(svm_problem *prob, int n)
{
    // Allocate a pointer of svm_problem type
    prob = new svm_problem;

    // Set and allocate data in problem
    prob -> l = n; // copies n over to problem
    prob -> y = new double [n]; // allocate 1-D array of y
    prob -> x = new svm_node *[n]; // allocate 1-D array of pointers to svm_nodes

    return prob;
}


svm_problem *svmproblemadddata(svm_problem *prob, double y, int yidx, int *xidx, double *xval, int n)
{

    // Copy over y value
    prob -> y[yidx - 1] = y;

    // Create a new pointer to array of svm nodes
    svm_node *xtemp = new svm_node [n+1];
    for (int i = 0; i < n; i++)
    {
      xtemp[i].index = xidx[i];
      xtemp[i].value = xval[i];
    }

    // Terminate array with -1 for index
    xtemp[n].index = -1;
    xtemp[n].value = 0;

    // Point first value in x to first value of xtemp
    prob -> x[yidx - 1] = &xtemp[0];

    return prob;
}

void svmproblemprintdata(svm_problem *prob, int i)
{
    // Create temporary pointer to a svm_mode
    svm_node * a_node;

    // Print out y value
    printf("Y VALUE: %f\n", prob -> y[i-1]);

    // Point a_node to the first value in x, loop around and print
    a_node = prob -> x[i-1];
    while(a_node -> index != -1)
    {
       printf("X INDEX: %d  X VALUE: %f\n", a_node -> index, a_node -> value);
       a_node ++;
    }
}

svm_parameter *svmparametercreate(svm_parameter *param)
{
    // Allocate a svm_parameter
    param = new svm_parameter;

    // Setup default values
    param -> svm_type = C_SVC;
    param -> kernel_type = RBF;
    param -> degree = 3;
    param -> gamma = 1.0/13.0;    // 1/num_features
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

    return param;
}

svm_parameter *svmparameterset(svm_parameter *param, const char *optstr, void *val)
{
    char *optionstr;
    optionstr = trim(optstr);

    if (strcmp(optionstr,"svm_type") == 0)
    {
        const char *valchar = static_cast<const char*>(val);
        char *tempstr;
        tempstr = trim(valchar);
        if (strcmp(tempstr,"c_svc") == 0)
            param -> svm_type = C_SVC;
        else if (strcmp(tempstr,"nu_svc") == 0)
            param -> svm_type = NU_SVC;
        else if (strcmp(tempstr,"one_class") == 0)
            param -> svm_type = ONE_CLASS;
        else if (strcmp(tempstr, "epsilon_svr") == 0)
            param -> svm_type = EPSILON_SVR;
        else if (strcmp(tempstr, "nu_svr") == 0)
            param -> svm_type = NU_SVR;
        else
            printf("SVM TYPE not recognized.\n");
    }
    else if (strcmp(optionstr,"kernel_type") == 0)
    {
        const char *valchar = static_cast<const char*>(val);
        char *tempstr;
        tempstr = trim(valchar);
        if (strcmp(tempstr,"linear") == 0)
            param -> kernel_type = LINEAR;
        else if (strcmp(tempstr,"poly") == 0)
            param -> kernel_type = POLY;
        else if (strcmp(tempstr,"rbf") == 0)
            param -> kernel_type = RBF;
        else if (strcmp(tempstr,"sigmoid") == 0)
            param -> kernel_type = SIGMOID;
        else if (strcmp(tempstr,"precomputed") == 0)
            param -> kernel_type = PRECOMPUTED;
        else
            printf("KERNEL TYPE not recognized.\n");
    }
    else if (strcmp(optionstr,"degree") == 0)
    {
        int *valint = static_cast<int *>(val);
        param -> degree = *valint;
    }
    else if (strcmp(optionstr,"gamma") == 0)
    {
        double *valdoub = static_cast<double *>(val);
        param -> gamma = *valdoub;
    }
    else if (strcmp(optionstr,"coef0") == 0)
    {
        double *valdoub = static_cast<double *>(val);
        param -> coef0 = *valdoub;
    }
    else if (strcmp(optionstr,"cache_size") == 0)
    {
        double *valdoub = static_cast<double *>(val);
        param -> cache_size = *valdoub;
    }
    else if (strcmp(optionstr,"eps") == 0)
    {
        double *valdoub = static_cast<double *>(val);
        param -> eps = *valdoub;
    }
    else if (strcmp(optionstr,"C") == 0)
    {
        double *valdoub = static_cast<double *>(val);
        param -> C = *valdoub;
    }
    else if (strcmp(optionstr,"nr_weight") == 0)
    {
        int *valint = static_cast<int *>(val);
        param -> nr_weight = *valint;
    }
    else if (strcmp(optionstr,"nu") == 0)
    {
        double *valdoub = static_cast<double *>(val);
        param -> nu = *valdoub;
    }
    else if (strcmp(optionstr,"p") == 0)
    {
        double *valdoub = static_cast<double *>(val);
        param -> p = *valdoub;
    }
    else if (strcmp(optionstr,"probability") == 0)
    {
        int *valint = static_cast<int *>(val);
        param -> probability = *valint;
    }
    else if (strcmp(optionstr,"shrinking") == 0)
    {
        int *valint = static_cast<int *>(val);
        param -> shrinking = *valint;
    }
    else
        printf("Parameter option not recognized.\n");

    return param;
} 

void svmparameterprint(svm_parameter *param)
{
    // Print out all parameter options
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
