program main

  use finalize,       only: finalize_run
  use global
  use initialize,     only: initialize_run
  use svm_interface,  only: run_svm_f

  implicit none

  ! initialize program
  call initialize_run() 

  ! run svm
  call run_svm_f(param)

  ! finalize program
  call finalize_run() 

end program main
