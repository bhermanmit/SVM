module global

  use constants

  implicit none
  save

# include "svmfortran.h90"

  ! Message used in message/warning/fatal_error
  character(MAX_LINE_LEN) :: message

  ! SVM variables
  SvmParameter :: param
  SvmProblem   :: prob
  SvmModel     :: model 

  ! Number of training points, rest are used for predicting
  integer :: npts
  integer :: npts_train


contains

!===============================================================================
! FREE_MEMORY deallocates and clears  all global allocatable arrays in the 
! program
!===============================================================================

  subroutine free_memory()

 
  end subroutine free_memory

end module global
