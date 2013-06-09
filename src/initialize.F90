module initialize

  use constants
  use error,            only: fatal_error
  use global
  use input_xml,        only: read_input_xml
  use output,           only: title, header, print_version, print_usage
  use string,           only: to_str, str_to_int4, starts_with, ends_with, &
                              str_to_real
  use svm_interface,    only: print_parameters

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

    ! Read command line arguments
    call read_command_line()

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
        case ('-?', '-help', '--help')
          call print_usage()
          stop
        case ('-s', '-svm_type', '--svm_type')
          i = i + 1
          param % svm_type = str_to_int4(argv(i))
        case ('-t', '-kernel_type', '--kernel_type')
          i = i + 1
          param % kernel_type = str_to_int4(argv(i))
        case ('-d', '-degree', '--degree')
          i = i + 1
          param % degree = str_to_int4(argv(i))
        case ('-g', '-gamma', '--gamma')
          i = i + 1
          param % gamma = str_to_real(argv(i))
        case ('-r', '-coef0', '--coef0')
          i = i + 1
          param % coef0 = str_to_real(argv(i))
        case ('-c', '-cost', '--cost')
          i = i + 1
          param % C = str_to_real(argv(i))
        case ('-n', '-nu', '--nu')
          i = i + 1
          param % nu = str_to_real(argv(i))
        case ('-p', '-eps_svr', '--eps_svr')
          i = i + 1
          param % p = str_to_real(argv(i))
        case ('-m', '-cache', '--cache')
          i = i + 1
          param % cache_size = str_to_real(argv(i))
        case ('-e', '-eps', '--eps')
          i = i + 1
          param % eps = str_to_real(argv(i))
        case ('-h', '-shrink', '--shrink')
          i = i + 1
          param % shrinking = str_to_int4(argv(i))
        case ('-b', '-probability', '--probability')
          i = i + 1
          param % probability = str_to_int4(argv(i))
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

    ! Print parameters
    call print_parameters(param)

  end subroutine read_command_line

end module initialize
