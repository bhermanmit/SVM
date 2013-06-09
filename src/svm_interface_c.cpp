# include <cstdlib>
# include <iostream>
# include "svm_interface_c.hpp"
# include "svm.h"

void run_svm_c( svm_parameter param )
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

    return;

}
