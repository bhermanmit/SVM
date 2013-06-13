module finalize

  use global
  use output,  only: print_results

contains

!===============================================================================
! FINALIZE_RUN
!===============================================================================

  subroutine finalize_run()

    ! display results
    call print_results()

    ! deallocate arrays
    call free_memory()

  end subroutine finalize_run

end module finalize
