module input_xml

  use constants
  use error,   only: fatal_error
  use global
  use output,  only: write_message

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
    call SvmParameterPrint(param)

    optstr = "gamma"
    input = c_loc(gamma_)
    param = SvmParameterSet(param, optstr, input)

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
    integer :: i

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

    ! sizes
    n_train = size(traindata_)
    n_test = size(testdata_)
    n_features = max_features_

    ! Create the problem
    prob = SvmProblemCreate(prob, n_train, n_features)

    ! Loop around train data and set to problem
    do i = 1, n_train 

      prob = SvmProblemAddData(prob, traindata_(i) % yvalue, i, &
           traindata_(i) % xinputs(:) % index, &
           traindata_(i) % xinputs(:) % value, &
           size(traindata_(i) % xinputs(:) % index))

!     call SvmProblemPrintData(prob, i)

    end do

    ! Check problem
    call SvmDataFinalize(prob, param)
    call SvmTrain(prob, param)

  end subroutine read_data_xml

end module input_xml
