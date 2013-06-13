module global

  use constants
  use svm_header
  use, intrinsic :: iso_c_binding

  implicit none
  save

# include "svmfortran.h90"

  ! Message used in message/warning/fatal_error
  character(MAX_LINE_LEN) :: message

  ! SVM variables
  SvmParameter :: param
  SvmProblem   :: prob
  SvmModel     :: model 

  ! Size of problem
  integer :: n_train
  integer :: n_test
  integer :: n_features_max

  ! Data
  type(svm_problem_type) :: train_data
  type(svm_problem_type) :: test_data

  ! Type of SVM problem
  integer :: svm_type

  ! Results
  integer :: correct
  integer :: total
  real(8) :: mse
  real(8) :: rmsp
  real(8) :: r2
  real(8) :: acc

contains

!===============================================================================
! FREE_MEMORY deallocates and clears  all global allocatable arrays in the 
! program
!===============================================================================

  subroutine free_memory()

 
  end subroutine free_memory

end module global
