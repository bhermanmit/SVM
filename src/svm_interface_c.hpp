#include "svm.h"

extern "C"
{
  void run_svm_c( svm_parameter param, int n_train, double y_train[], svm_node xspace_train[],
                  int n_predict, double y_predict[], svm_node xspace_predict[] );
}
