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

  end subroutine read_data_xml

end module input_xml
