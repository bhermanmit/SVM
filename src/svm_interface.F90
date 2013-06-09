module svm_interface

  use, intrinsic :: iso_c_binding

  implicit none

  ! define types
  type, bind(c) :: svm_node_f
    integer(c_int) :: index
    real(c_double) :: value
  end type svm_node_f

  type :: svm_problem_f
    integer(c_int) :: l
    real(c_double), allocatable :: y(:)
    type(svm_node_f), allocatable :: x(:)
  end type svm_problem_f

  type, bind(c) :: svm_parameter_f
    integer(c_int) :: svm_type
    integer(c_int) :: kernel_type
    integer(c_int) :: degree
    real(c_double) :: gamma
    real(c_double) :: coef0
    real(c_double) :: cache_size
    real(c_double) :: eps
    real(c_double) :: C
    integer(c_int) :: nr_weight
    real(c_double) :: nu
    real(c_double) :: p
    integer(c_int) :: shrinking
    integer(c_int) :: probability
    integer(c_int) :: weight_label
    real(c_double) :: weight
  end type svm_parameter_f

  interface
    subroutine run_svm_c(param, n_train, y_train, xspace_train) bind (c)
      import :: svm_parameter_f, svm_node_f, c_double, c_int 
      implicit none
      type(svm_parameter_f), value :: param
      integer(c_int), value :: n_train
      real(c_double) :: y_train(*)
      type(svm_node_f) :: xspace_train(*)
    end subroutine run_svm_c
  end interface 

contains

!===============================================================================
! RUN_SVM_F
!===============================================================================

  subroutine run_svm_f(param, data_train, data_predict)

    type(svm_parameter_f) :: param
    type(svm_problem_f) :: data_train
    type(svm_problem_f) :: data_predict
    print *, 'FORTRAN Y:', data_train % y(1)
    call run_svm_c(param, data_train % l, data_train % y, data_train % x)

  end subroutine run_svm_f

!===============================================================================
! PRINT_PARAMETERS
!===============================================================================

  subroutine print_parameters(this)

    type(svm_parameter_f) :: this

    ! print all
    print *, 'SVM_TYPE:', this % svm_type
    print *, 'KERNEL_TYPE:', this % kernel_type
    print *, 'DEGREE:', this % degree
    print *, 'GAMMA:', this % gamma
    print *, 'COEF0:', this % coef0
    print *, 'CACHE_SIZE:', this % cache_size
    print *, 'EPS:', this % eps
    print *, 'C:', this % C
    print *, 'NR_WEIGHT:', this % nr_weight
    print *, 'WEIGHT_LABEL:', this % weight_label
    print *, 'WEIGHT:', this % weight
    print *, 'NU:', this % nu
    print *, 'P:', this % p
    print *, 'SHRINKING:', this % shrinking
    print *, 'PROBABILITY:', this % probability
 
  end subroutine print_parameters

end module svm_interface
