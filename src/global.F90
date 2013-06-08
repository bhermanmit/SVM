module global

  use constants

  implicit none
  save

  ! Message used in message/warning/fatal_error
  character(MAX_LINE_LEN) :: message

contains

!===============================================================================
! FREE_MEMORY deallocates and clears  all global allocatable arrays in the 
! program
!===============================================================================

  subroutine free_memory()
 
  end subroutine free_memory

end module global
