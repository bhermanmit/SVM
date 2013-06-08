module global

  use constants
  use svm_interface, only: svm_problem

  implicit none
  save

  ! Message used in message/warning/fatal_error
  character(MAX_LINE_LEN) :: message

  ! SVM problem data for training and predicting
  type(svm_problem) :: data_train
  type(svm_problem) :: data_predict

contains

!===============================================================================
! FREE_MEMORY deallocates and clears  all global allocatable arrays in the 
! program
!===============================================================================

  subroutine free_memory()
 
  end subroutine free_memory

end module global
