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
    call data_train()

    ! predict data
    call data_predict()

  end subroutine run_svm

!===============================================================================
! DATA_TRAIN 
!===============================================================================

  subroutine data_train()

    integer :: i
    integer, allocatable :: index_vec(:)
    real(8), allocatable :: value_vec(:)

    ! Allocate temp vectors
    allocate(index_vec(n_features_max))
    allocate(value_vec(n_features_max))

    ! Create svm problem object in C++
    prob = SvmProblemCreate(prob, n_train)

    ! Loop around train data and add to C++ problem structure
    do i = 1, n_train

      ! Copy data
      index_vec(1:train_data % datapt(i) % n) = train_data % datapt(i) % &
                                                x(:) % idx
      value_vec(1:train_data % datapt(i) % n) = train_data % datapt(i) % &
                                                x(:) % val 

      ! Store in C++ svm problem structure
      prob = SvmProblemAddData(prob, train_data % datapt(i) % y, i, &
             index_vec, value_vec, train_data % datapt(i) % n)

    end do

    ! Check problem and parameters for problem
    call SvmDataFinalize(prob, param)

    ! Perform Training
    model = SvmTrain(prob, param)

    ! Deallocate temp vectors
    deallocate(index_vec)
    deallocate(value_vec)

  end subroutine data_train 

!===============================================================================
! DATA_PREDICT 
!===============================================================================

  subroutine data_predict() 

    integer :: i
    integer, allocatable :: index_vec(:)
    real(8), allocatable :: value_vec(:)
    real(8) :: y_predict

    ! Allocate temp vectors
    allocate(index_vec(n_features_max))
    allocate(value_vec(n_features_max))

    ! Loop around train data and set to problem
    do i = 1, n_test

      ! Copy data
      index_vec(1:test_data % datapt(i) % n) = test_data % datapt(i) % &
                                                x(:) % idx
      value_vec(1:test_data % datapt(i) % n) = test_data % datapt(i) % &
                                                x(:) % val 

      ! Predict y value
      y_predict = SvmPredict(model, index_vec, value_vec, &
                             test_data % datapt(i) % n)

      print *, test_data % datapt(i) % y, y_predict

    end do

    ! Deallocate temp vectors
    deallocate(index_vec)
    deallocate(value_vec)

  end subroutine data_predict

end module svm
