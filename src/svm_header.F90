module svm_header

  use constants

  implicit none

  type :: svm_node_type
    integer :: idx
    real(8) :: val
  end type svm_node_type

  type :: svm_data_type
    integer :: n
    real(8) :: y = DEFAULT_REAL
    type(svm_node_type), allocatable :: x(:)
  end type svm_data_type

  type :: svm_problem_type
    integer :: n
    type(svm_data_type), allocatable :: datapt(:)
  end type

contains

!===============================================================================
! ALLOCATE_PROBLEM
!===============================================================================

  subroutine allocate_problem(this, n)

    type(svm_problem_type) :: this
    integer :: n  ! number of data points

    this % n = n
    if (.not.allocated(this % datapt)) allocate(this % datapt(n))

  end subroutine allocate_problem

!===============================================================================
! ALLOCATE_DATA
!===============================================================================

  subroutine allocate_data(this, n)

    type(svm_data_type) :: this
    integer :: n

    this % n = n
    if (.not.allocated(this % x)) allocate(this % x(n))

  end subroutine allocate_data

!===============================================================================
! DEALLOCATE_PROBLEM
!===============================================================================

  subroutine deallocate_problem(this)

    type(svm_problem_type) :: this

    if (allocated(this % datapt)) deallocate(this % datapt)

  end subroutine deallocate_problem

!===============================================================================
! DEALLOCATE_DATA
!===============================================================================

  subroutine deallocate_data(this)

    type(svm_data_type) :: this

    if (allocated(this % x)) deallocate(this % x)

  end subroutine deallocate_data

end module svm_header
