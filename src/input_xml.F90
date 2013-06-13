module input_xml

  use constants
  use error,   only: fatal_error
  use global
  use output,  only: write_message

  implicit none

  logical :: calc_gamma = .false.

contains

!===============================================================================
! READ_INPUT_XML calls each of the separate subroutines for reading settings,
! and data 
!===============================================================================

  subroutine read_input_xml()

    ! read in settings input file
    call read_settings_xml()

    ! read in data input file
    call read_data_xml()

    ! print out parameter list
    call SvmParameterPrint(param)

  end subroutine read_input_xml

!===============================================================================
! READ_SETTINGS_XML
!===============================================================================

  subroutine read_settings_xml()

    use xml_data_settings_t

    character(MAX_LINE_LEN) :: filename
    logical :: file_exists
    type(c_ptr) :: input
    character(kind=c_char, len=25) :: optstr

    ! Display output message
    message = "Reading settings XML file..."
    call write_message()

    ! Check if settings.xml exists
    filename = "settings.xml"
    inquire(FILE=filename, EXIST=file_exists)
    if (.not. file_exists) then
      message = "Settings XML file '" // trim(filename) // "' does not exist!"
      call fatal_error()
    end if

    ! Parse settings.xml file
    call read_xml_file_settings_t(filename)

    ! Create a parameter object
    param = SvmParameterCreate(param)

    ! Check SVM Type 
    if (svm_type_ /= "") then
      optstr = "svm_type"
      input = c_loc(svm_type_)
      param = SvmParameterSet(param, optstr, input)
    end if

    ! Check Kernel Type
    if (kernel_type_ /= "") then
      optstr = "kernel_type"
      input = c_loc(kernel_type_)
      param = SvmParameterSet(param, optstr, input)
    end if

    ! Check degree
    if (degree_ /= DEFAULT_INT) then
      optstr = "degree"
      input = c_loc(degree_)
      param = SvmParameterSet(param, optstr, input)
    end if

    ! Check gamma
    if (gamma_ /= DEFAULT_REAL) then
      optstr = "gamma"
      input = c_loc(gamma_)
      param = SvmParameterSet(param, optstr, input)
    else
      calc_gamma = .true.
    end if

    ! Check coef0
    if (coef0_ /= DEFAULT_REAL) then 
      optstr = "coef0"
      input = c_loc(coef0_)
      param = SvmParameterSet(param, optstr, input)
    end if

    ! Check cache size
    if (cache_size_ /= DEFAULT_REAL) then
      optstr = "cache_size"
      input = c_loc(cache_size_)
      param = SvmParameterSet(param, optstr, input)
    end if

    ! Check eps
    if (eps_ /= DEFAULT_REAL) then
      optstr = "eps"
      input = c_loc(eps_)
      param = SvmParameterSet(param, optstr, input)
    end if

    ! Check C
    if (C_ /= DEFAULT_REAL) then
      optstr = "C"
      input = c_loc(C_)
      param = SvmParameterSet(param, optstr, input)
    end if

    ! Check Nu
    if (nu_ /= DEFAULT_REAL) then
      optstr = "nu"
      input = c_loc(nu_)
      param = SvmParameterSet(param, optstr, input)
    end if

    ! Check p
    if (p_ /= DEFAULT_REAL) then
      optstr = "p"
      input = c_loc(p_)
      param = SvmParameterSet(param, optstr, input)
    end if

    ! Check shrinking
    if (shrinking_ /= DEFAULT_INT) then
      optstr = "shrinking"
      input = c_loc(shrinking_)
      param = SvmParameterSet(param, optstr, input)
    end if

    ! Check probability
    if (probability_ /= DEFAULT_INT) then
      optstr = "probability"
      input = c_loc(probability_)
      param = SvmParameterSet(param, optstr, input)
    end if

  end subroutine read_settings_xml


!===============================================================================
! READ_DATA_XML
!===============================================================================

  subroutine read_data_xml()

    use xml_data_data_t

    character(MAX_LINE_LEN) :: filename
    logical :: file_exists
    integer :: n_train
    integer :: n_test
    integer :: n_features
    integer :: n_features_max
    integer :: i
    integer, allocatable :: index_vec(:)
    real(8), allocatable :: value_vec(:)
    real(8) :: temp_real
    character(len=25) :: temp_char
    type(c_ptr) :: cptr

    ! Display output message
    message = "Reading data XML file..."
    call write_message()

    ! Check if settings.xml exists
    filename = "data.xml"
    inquire(FILE=filename, EXIST=file_exists)
    if (.not. file_exists) then
      message = "Data XML file '" // trim(filename) // "' does not exist!"
      call fatal_error()
    end if

    ! Parse settings.xml file
    call read_xml_file_data_t(filename)

    ! Get data sizes
    n_train = size(traindata_)
    n_test = size(testdata_)
    n_features_max = max_features_
    if (n_features_max == 0) then
      message = "Maximum number of features is 0"
      call fatal_error()
    end if 

    ! Allocate data
    allocate(index_vec(n_features_max))
    allocate(value_vec(n_features_max))

    ! Create the problem
    prob = SvmProblemCreate(prob, n_train)

    ! Loop around train data and set to problem
    do i = 1, n_train

      ! Get the number of features 
      n_features = size(traindata_(i) % xinputs)

      ! Set values to temp arrays
      index_vec(1:n_features) = traindata_(i) % xinputs(:) % index
      value_vec(1:n_features) = traindata_(i) % xinputs(:) % value

      ! Store in svm problem structure
      prob = SvmProblemAddData(prob, traindata_(i) % yvalue, i, &
             index_vec, value_vec, n_features) 

    end do

    ! Check to see if gamma needs to be calculated
    if (calc_gamma) then
      temp_real = ONE/dble(n_features_max)
      cptr = c_loc(temp_real)
      temp_char = "gamma"
      param = SvmParameterSet(param, temp_char, cptr)
    end if

    ! Check problem
    call SvmDataFinalize(prob, param)

    ! Deallocate
    deallocate(index_vec)
    deallocate(value_vec)

  end subroutine read_data_xml

end module input_xml
