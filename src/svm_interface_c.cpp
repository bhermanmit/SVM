# include <cstdlib>
# include <iostream>
# include <math.h>
# include "svm_interface_c.hpp"
# include "svm.h"
#define Malloc(type,n) (type *)malloc((n)*sizeof(type))
 
struct svm_problem prob;
struct svm_problem predict;
struct svm_model *model;
struct svm_node x;

void run_svm_c( svm_parameter param, int n_train, double y_train[], svm_node xspace_train[],
                int n_predict, double y_predict[], svm_node xspace_predict[] )
{

    // Re-print all of the options while we are still developing
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

    // Make sure we have a valid y and X pair
    std :: cout << "First y value: " << y_train[0] << "\n";
    std :: cout << "X PAIR: " << xspace_train[0].index << ", " << xspace_train[0].value << "\n";

    // Allocate problem (Get help from Jeremy to make sure we aren't duplicating memory
    prob.l = n_train;
    prob.y = Malloc(double, prob.l);
    prob.x = Malloc(struct svm_node *, prob.l);
    prob.y = y_train;
  
    // Populate, hopefully references, to the problem
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

    // Check to make sure the problem and parameters were set up correctly
    const char *error_msg;
    error_msg = svm_check_parameter(&prob, &param);
    if(error_msg)
    {
      std :: cout << "ERROR: " << error_msg << "\n";
      exit(1);
    }

    // Train the model with the problem data
    model = svm_train(&prob, &param);

    // Set up prediction problem and predict y values
    double y_predicted;
    int correct = 0;
    int total = 0;
    double error = 0;
    double sump = 0, sumt = 0, sumpp = 0, sumtt = 0, sumpt = 0;
    predict.x = Malloc(struct svm_node *, n_predict);
    j = 0;
    for (int i = 0; i < n_predict; i++)
    {

      // Set up x values for prediction
      predict.x[i] = &xspace_predict[j];

      // Run prediction
      y_predicted = svm_predict(model, predict.x[i]);

      // Check if we are correct
      if (y_predicted == y_predict[i]) ++correct;
      error += (y_predicted - y_predict[i])*(y_predicted - y_predict[i]);
      sump += y_predicted;
      sumt += y_predict[i];
      sumpp += y_predicted*y_predicted;
      sumtt += y_predict[i]*y_predict[i];
      sumpt += y_predicted*y_predict[i];
      ++total;

      // Traverse to start of next x values
      while(1)
      {
        if (xspace_predict[j].index == -1) break;
        j++;
      }
      j++;
    }

    if (param.svm_type == NU_SVR || param.svm_type == EPSILON_SVR)
    {
      std :: cout << "Mean squared error = " << error/total << " (regression)\n";
      std :: cout << "Root Mean squared error = " << sqrt(error/total)*100 
                  << "% (regression)\n";
      std :: cout << "Squared correlation coefficient = " <<
			((total*sumpt-sump*sumt)*(total*sumpt-sump*sumt))/
			((total*sumpp-sump*sump)*(total*sumtt-sumt*sumt)) <<
            " (regression)\n";
    }
    else
      std :: cout << "Accuracy = " << (double)correct/total*100 << "% ("
                  << correct << "/" << total << ") (classification)\n";

    return;
}
