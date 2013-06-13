program main

  use finalize,       only: finalize_run
  use global
  use initialize,     only: initialize_run
  use svm,            only: run_svm

  implicit none

  ! initialize program
  call initialize_run() 

  ! run svm program
  call run_svm()

  ! finalize program
  call finalize_run() 

end program main
