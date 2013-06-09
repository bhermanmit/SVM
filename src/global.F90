module global

  use constants
  use svm_interface, only: svm_problem_f, svm_parameter_f

  implicit none
  save

  ! Message used in message/warning/fatal_error
  character(MAX_LINE_LEN) :: message

  ! SVM problem data for training and predicting
  type(svm_problem_f) :: data_train
  type(svm_problem_f) :: data_predict

  ! Number of training points, rest are used for predicting
  integer :: npts
  integer :: npts_train

  ! SVM Parameters
  type(svm_parameter_f) :: param

contains

!===============================================================================
! FREE_MEMORY deallocates and clears  all global allocatable arrays in the 
! program
!===============================================================================

  subroutine free_memory()

    ! deallocate data points
    if (allocated(data_train % y)) deallocate(data_train % y)
    if (allocated(data_train % x)) deallocate(data_train % x)
    if (allocated(data_predict % y)) deallocate(data_predict % y)
    if (allocated(data_predict % x)) deallocate(data_predict % x)
 
  end subroutine free_memory

end module global
