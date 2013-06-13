module initialize

  use constants
  use error,            only: fatal_error
  use global
  use input_xml,        only: read_input_xml
  use output,           only: title, header
  use string,           only: to_str, str_to_int4, starts_with, ends_with, &
                              str_to_real

  implicit none

contains

!===============================================================================
! INITIALIZE_RUN
!===============================================================================

  subroutine initialize_run()

    ! Display title and initialization header
    call title()
    call header("INITIALIZATION", level=1)

    ! Read XML input files
    call read_input_xml()

  end subroutine initialize_run

end module initialize
