module input_xml

  use constants
  use error,   only: fatal_error
  use global
  use output,  only: write_message
  use svm_interface, only: print_parameters

  implicit none
  save

contains

!===============================================================================
! READ_INPUT_XML calls each of the separate subroutines for reading settings,
! and data 
!===============================================================================

  subroutine read_input_xml()

    call read_settings_xml()
    call read_data_xml()

  end subroutine read_input_xml

!===============================================================================
! READ_SETTINGS_XML
!===============================================================================

  subroutine read_settings_xml()

    use xml_data_settings_t

    character(MAX_WORD_LEN) :: type
    character(MAX_LINE_LEN) :: filename
    logical :: file_exists

    ! Display output message
    message = "Reading settings XML file..."
    call write_message(5)

    ! Check if settings.xml exists
    filename = "settings.xml"
    inquire(FILE=filename, EXIST=file_exists)
    if (.not. file_exists) then
      message = "Settings XML file '" // trim(filename) // "' does not exist!"
      call fatal_error()
    end if

    ! Set default values
    param % svm_type = C_SVC
    param % kernel_type = RBF
    param % degree = 3
    param % coef0 = 0
    param % cache_size = 100.0_8
    param % eps = 1.e-3_8
    param % C = 1
    param % nr_weight = 0
    param % weight_label = 0
    param % weight = 0.0_8
    param % nu = 0.5_8
    param % p = 0.1_8
    param % shrinking = 1
    param % probability = 0

    ! Parse settings.xml file
    call read_xml_file_settings_t(filename)

    ! Print length of datapts
    npts_train = npts_train_ 
    print *, npts_train

  end subroutine read_settings_xml


!===============================================================================
! READ_DATA_XML
!===============================================================================

  subroutine read_data_xml()

    use xml_data_data_t

    character(MAX_WORD_LEN) :: type
    character(MAX_LINE_LEN) :: filename
    integer :: ninputs_train
    integer :: ninputs_predict
    integer :: i, j
    integer :: idx
    integer :: max_index
    integer :: max_index_tmp
    logical :: file_exists

    ! Display output message
    message = "Reading data XML file..."
    call write_message(5)

    ! Check if settings.xml exists
    filename = "data.xml"
    inquire(FILE=filename, EXIST=file_exists)
    if (.not. file_exists) then
      message = "Data XML file '" // trim(filename) // "' does not exist!"
      call fatal_error()
    end if

    ! Parse settings.xml file
    call read_xml_file_data_t(filename)

    ! Print length of datapts
    npts = size(datapt_)
    print *, npts 

    ! Check to make sure subset of training points is valid
    if (npts_train >= npts) then
      message = 'Number of trainings points too high.'
      call fatal_error()
    end if

    ! Loop around to get number of elements
    ninputs_train = 0
    ninputs_predict = 0
    do i = 1, npts
      if (i <= npts_train) then
        ninputs_train = ninputs_train + &
               size(datapt_(i) % xinputs)
      else
        ninputs_predict = ninputs_predict + &
               size(datapt_(i) % xinputs)
      end if
    end do

    ! Allocate data objects
    allocate(data_train % y(npts_train))
    allocate(data_predict % y(npts - npts_train))
    allocate(data_train % x(ninputs_train + npts_train)) ! accounts for -1 on each line
    allocate(data_predict % x(ninputs_predict + npts - npts_train)) ! accounts for -1 on each line

    ! Read in training data
    idx = 1
    max_index = 0
    max_index_tmp = 0
    do i = 1, npts_train
      data_train % y(i) = datapt_(i) % yvalue
      do j = 1, size(datapt_(i) % xinputs)
        data_train % x(idx) % index = datapt_(i) % xinputs(j) % index
        data_train % x(idx) % value = datapt_(i) % xinputs(j) % value
        idx = idx + 1
        max_index_tmp = j
      end do
      if (max_index_tmp > max_index) max_index = max_index_tmp
      data_train % x(idx) % index = -1
      data_train % x(idx) % value = ZERO
      idx = idx + 1
    end do

    ! Read in prediction data
    idx = 1
    do i = npts_train + 1, npts
      data_predict % y(i-npts_train) = datapt_(i) % yvalue
      do j = 1, size(datapt_(i) % xinputs)
        data_predict % x(idx) % index = datapt_(i) % xinputs(j) % index
        data_predict % x(idx) % value = datapt_(i) % xinputs(j) % value
        idx = idx + 1
      end do
      data_predict % x(idx) % index = -1
      data_predict % x(idx) % value = ZERO
      idx = idx + 1
    end do

    ! Check to set gamma
    if (param % gamma < 1.e-8_8) param % gamma = ONE/dble(max_index)

    ! Print parameters
    call print_parameters(param)
 
  end subroutine read_data_xml

end module input_xml
