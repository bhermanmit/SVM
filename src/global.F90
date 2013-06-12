module global

  use constants
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

contains

!===============================================================================
! FREE_MEMORY deallocates and clears  all global allocatable arrays in the 
! program
!===============================================================================

  subroutine free_memory()

 
  end subroutine free_memory

end module global
