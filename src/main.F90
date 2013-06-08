program main

  use finalize,    only: finalize_run
  use initialize,  only: initialize_run

  implicit none

  ! initialize program
  call initialize_run() 

  ! finalize program
  call finalize_run() 

end program main
