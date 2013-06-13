module svm

  use constants
  use global
  use output,    only: header, print_columns, print_prediction

  implicit none
  private
  public :: run_svm

contains

!===============================================================================
! RUN_SVM
!===============================================================================

  subroutine run_svm()

    ! train data
    call header("TRAINING MACHINE", level=1)
    call data_train()

    ! predict data
    call header("PREDICTING DATA", level=1)
    call print_columns()
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
    real(8) :: y_test
    real(8) :: error
    real(8) :: sump
    real(8) :: sumt
    real(8) :: sumpp
    real(8) :: sumtt
    real(8) :: sumpt

    ! Allocate temp vectors
    allocate(index_vec(n_features_max))
    allocate(value_vec(n_features_max))

    ! Initialize sums
    total = 0
    correct = 0
    error = ZERO
    sump = ZERO
    sumt = ZERO
    sumpp = ZERO
    sumtt = ZERO
    sumpt = ZERO

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

      ! Collect data
      y_test = test_data % datapt(i) % y
      if (y_test /= DEFAULT_REAL) then

        ! Print prediction
        call print_prediction(i, y_predict, y_test)

        ! Increment total counter
        total = total + 1

        ! Classification analysis
        if (svm_type == CLASSIFICATION) then

          ! Check if values agree
          if (abs(y_predict - y_test) < TINY_BIT) correct = correct + 1

        else ! regression

          ! Collect errors
          error = error + (y_predict - y_test)**2
          sump = sump + y_predict
          sumt = sumt + y_test
          sumpp = sumpp + y_predict**2
          sumtt = sumtt + y_test**2
          sumpt = sumpt + y_predict*y_test

        end if

      else

        ! Just print y value
        call print_prediction(i, y_predict)

      end if
 
    end do

    ! Compute Results
    if (svm_type == CLASSIFICATION) then

      ! Calculate accuracy[%]
      acc = dble(correct)/dble(total) * 100._8

    else ! regression

      ! Calculate mean squared error
      mse = error/dble(total)

      ! Calculate root mean squared error [%]
      rmsp = sqrt(error/dble(total))*100._8

      ! Calculate squared correlation coefficient
      r2 = ((dble(total)*sumpt - sump*sumt)*(dble(total)*sumpt - sump*sumt)) / &
           ((dble(total)*sumpp - sump*sump)*(dble(total)*sumtt - sumt*sumt))

    end if

    ! Deallocate temp vectors
    deallocate(index_vec)
    deallocate(value_vec)

  end subroutine data_predict

end module svm
