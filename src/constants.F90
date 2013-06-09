module constants

  implicit none

  ! ============================================================================
  ! VERSIONING NUMBERS

  ! OpenMC major, minor, and release numbers
  integer, parameter :: VERSION_MAJOR   = 0
  integer, parameter :: VERSION_MINOR   = 1
  integer, parameter :: VERSION_RELEASE = 0

  ! ============================================================================
  ! ADJUSTABLE PARAMETERS 

  ! NOTE: This is the only section of the constants module that should ever be
  ! adjusted. Modifying constants in other sections may cause the code to fail.

  ! Maximum number of words in a single line, length of line, and length of
  ! single word
  integer, parameter :: MAX_WORDS    = 500
  integer, parameter :: MAX_LINE_LEN = 250
  integer, parameter :: MAX_WORD_LEN = 150
  integer, parameter :: MAX_FILE_LEN = 255

  ! ============================================================================
  ! PHYSICAL CONSTANTS

  real(8), parameter ::            &
       INFINITY     = huge(0.0_8),       & ! positive infinity
       ZERO         = 0.0_8,             &
       ONE          = 1.0_8,             &
       TWO          = 2.0_8

  ! ============================================================================
  ! MISCELLANEOUS CONSTANTS

  ! indicates that an array index hasn't been set
  integer, parameter :: NONE = 0

  ! Codes for read errors -- better hope these numbers are never used in an
  ! input file!
  integer, parameter :: ERROR_INT  = -huge(0)
  real(8), parameter :: ERROR_REAL = -huge(0.0_8) * 0.917826354_8

  ! ============================================================================
  ! SVM OPTIONS

  ! svm-type
  integer, parameter :: C_SVC = 0
  integer, parameter :: NU_SVC = 1
  integer, parameter :: ONE_CLASS = 2
  integer, parameter :: EPSILON_SVR = 3
  integer, parameter :: NU_SVR = 4

  ! kernel-type
  integer, parameter :: LINEAR = 0
  integer, parameter :: POLY = 1
  integer, parameter :: RBF = 2
  integer, parameter :: SIGMOID = 3
  integer, parameter :: PRECOMPUTED = 4
  
end module constants
