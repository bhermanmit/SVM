module finalize

  use global

contains

!===============================================================================
! FINALIZE_RUN
!===============================================================================

  subroutine finalize_run()

    ! deallocate arrays
    call free_memory()

  end subroutine finalize_run

end module finalize
