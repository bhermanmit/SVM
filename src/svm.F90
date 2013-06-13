module svm

  use global

  implicit none
  private
  public :: run_svm

contains

!===============================================================================
! RUN_SVM
!===============================================================================

  subroutine run_svm()

    ! train data
    call train_data()

    ! predict data
    call predict_data()

  end subroutine run_svm

!===============================================================================
! TRAIN_DATA
!===============================================================================

  subroutine train_data()

    ! call svm train
    model = SvmTrain(prob, param)

  end subroutine train_data

!===============================================================================
! PREDICT_DATA
!===============================================================================

  subroutine predict_data()

    

  end subroutine predict_data

end module svm
