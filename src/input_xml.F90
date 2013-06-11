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
    call SvmParameterCreate(param)

    ! Check SVM Type 
    if (svm_type_ /= "") then
      call SvmParameterSetSvmType(param, svm_type_)
    end if

    ! Check Kernel Type
    if (kernel_type_ /= "") then
      call SvmParameterSetKernelType(param, kernel_type_)
    end if

    ! Check degree
    if (degree_ /= DEFAULT_INT) then
      call SvmParameterSetDegree(param, degree_)
    end if

    ! Check gamma
    if (gamma_ /= DEFAULT_REAL) then
      call SvmParameterSetGamma(param, gamma_)
    end if

    ! Check coef0
    if (coef0_ /= DEFAULT_REAL) then 
      call SvmParameterSetCoef0(param, coef0_)
    end if

    ! Check cache size
    if (cache_size_ /= DEFAULT_REAL) then
      call SvmParameterSetCacheSize(param, cache_size_)
    end if

    ! Check eps
    if (eps_ /= DEFAULT_REAL) then
      call SvmParameterSetEps(param, eps_)
    end if

    ! Check C
    if (C_ /= DEFAULT_REAL) then
      call SvmParameterSetC(param, C_)
    end if

    ! Check Nu
    if (nu_ /= DEFAULT_REAL) then
      call SvmParameterSetNu(param, nu_)
    end if

    ! Check p
    if (p_ /= DEFAULT_REAL) then
      call SvmParameterSetP(param, p_)
    end if

    ! Check Shrinking
    if (shrinking_ /= DEFAULT_INT) then
      call SvmParameterSetShrinking(param, shrinking_)
    end if

    ! Check Probability
    if (probability_ /= DEFAULT_INT) then
      call SvmParameterSetProbability(param, probability_)
    end if

    ! Print out parameters
    call SvmParameterPrint(param)

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
    call SvmProblemCreate(prob, n_train, n_features)

    ! Loop around train data and set to problem
    do i = 1, 1

      ! print out 
      call SvmProblemAddData(prob, traindata_(i) % yvalue, i, &
           traindata_(i) % xinputs(:) % index, &
           traindata_(i) % xinputs(:) % value, &
           size(traindata_(i) % xinputs(:) % index))

    end do

  end subroutine read_data_xml

end module input_xml
