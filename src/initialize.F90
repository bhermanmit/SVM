module initialize

  use constants
  use error,            only: fatal_error
  use global
  use input_xml,        only: read_input_xml
  use output,           only: title, header, print_version, print_usage
  use string,           only: to_str, str_to_int, starts_with, ends_with

  implicit none

contains

!===============================================================================
! INITIALIZE_RUN
!===============================================================================

  subroutine initialize_run()

    ! Read command line arguments
!   call read_command_line()

    ! Display title and initialization header
    call title()
    call header("INITIALIZATION", level=1)

    ! Read XML input files
    call read_input_xml()

  end subroutine initialize_run

!===============================================================================
! READ_COMMAND_LINE reads all parameters from the command line
!===============================================================================

  subroutine read_command_line()

    integer :: i         ! loop index
    integer :: argc      ! number of command line arguments
    integer :: last_flag ! index of last flag
    character(MAX_FILE_LEN) :: pwd      ! present working directory
    character(MAX_WORD_LEN), allocatable :: argv(:) ! command line arguments

    ! Get working directory
    call GET_ENVIRONMENT_VARIABLE("PWD", pwd)

    ! Check number of command line arguments and allocate argv
    argc = COMMAND_ARGUMENT_COUNT()

    ! Allocate and retrieve command arguments
    allocate(argv(argc))
    do i = 1, argc
      call GET_COMMAND_ARGUMENT(i, argv(i))
    end do

    ! Process command arguments
    last_flag = 0
    i = 1
    do while (i <= argc)
      ! Check for flags
      if (starts_with(argv(i), "-")) then
        select case (argv(i))
!       case ('-p', '-plot', '--plot')
!         run_mode = MODE_PLOTTING
!       case ('-n', '-n_particles', '--n_particles')
!         ! Read number of particles per cycle
!         i = i + 1
!         n_particles = str_to_int(argv(i))
        case default
          message = "Unknown command line option: " // argv(i)
          call fatal_error()
        end select

        last_flag = i
      end if

      ! Increment counter
      i = i + 1
    end do

    ! Free memory from argv
    deallocate(argv)

  end subroutine read_command_line

end module initialize
