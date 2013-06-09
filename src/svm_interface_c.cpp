# include <cstdlib>
# include <iostream>
# include "svm_interface_c.hpp"
# include "svm.h"
#define Malloc(type,n) (type *)malloc((n)*sizeof(type))
 
struct svm_problem prob;

void run_svm_c( svm_parameter param, int n_train, double y_train[], svm_node xspace_train[] )
{

    std :: cout << "SVM_TYPE: " << param.svm_type << "\n";
    std :: cout << "KERNEL_TYPE: " << param.kernel_type << "\n";
    std :: cout << "DEGREE: " << param.degree << "\n";
    std :: cout << "GAMMA: " << param.gamma << "\n";
    std :: cout << "COEF0: " << param.coef0 << "\n";
    std :: cout << "CACHE_SIZE: " << param.cache_size << "\n";
    std :: cout << "EPS: " << param.cache_size << "\n";
    std :: cout << "C: " << param.C << "\n";
    std :: cout << "NR_WEIGHT: " << param.nr_weight << "\n";
    std :: cout << "WEIGHT_LABEL: " << param.weight_label << "\n";
    std :: cout << "WEIGHT: " << param.weight << "\n";
    std :: cout << "P: " << param.p << "\n";
    std :: cout << "SHRINKING: " << param.shrinking << "\n";
    std :: cout << "PROBABILITY: " << param.probability << "\n";

    param.weight_label = NULL;
    param.weight = NULL;

    std :: cout << "First y value: " << y_train[0] << "\n";
    std :: cout << "X PAIR: " << xspace_train[0].index << ", " << xspace_train[0].value << "\n";

    prob.l = n_train;

    prob.y = Malloc(double, prob.l);
    prob.x = Malloc(struct svm_node *, prob.l);
    prob.y = y_train;
  
    int j = 0;
    for (int i = 0; i < prob.l; i++)
    {
      prob.x[i] = &xspace_train[j];
      while(1)
      {
        if (xspace_train[j].index == -1) break;
        j++;
      }
      j++;
    }

    const char *error_msg;
    error_msg = svm_check_parameter(&prob, &param);
    std :: cout << "HERE" << error_msg << "\n";
    if(error_msg)
    {
      std :: cout << "ERROR: " << error_msg << "\n";
      exit(1);
    }

    return;
}
