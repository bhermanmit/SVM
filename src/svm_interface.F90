module svm_interface

  use, intrinsic :: iso_c_binding

  implicit none

  ! define types
  type, bind(c) :: svm_node
    integer(c_int) :: index
    real(c_double) :: value
  end type

  type :: svm_problem
    integer(c_int) :: l
    real(c_double), allocatable :: y(:)
    type(svm_node), allocatable :: x(:)
  end type svm_problem
    
end module svm_interface
