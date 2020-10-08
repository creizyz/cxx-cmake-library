# ================================================================== #
# ================================================== # C++ Standard

set(${PROJECT_NAME}_CXX_STANDARD cxx_std_20)

# ================================================================== #
# ================================================== # CLANG flags
if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  set(${PROJECT_NAME}_CXX_FLAGS
    # nothing
  )
# ================================================================== #
# ================================================== # GCC flags
elseif (CMAKE_CXX_COMPILER_ID MATCHES "GNU")
  set(${PROJECT_NAME}_CXX_FLAGS
    -Wall
    -Wextra
    -pedantic
    -Werror
  )
# ================================================================== #
# ================================================== # Intel flags
elseif (CMAKE_CXX_COMPILER_ID MATCHES "Intel")
  set(${PROJECT_NAME}_CXX_FLAGS
    # nothing
  )
# ================================================================== #
# ================================================== # GCC flags
elseif (CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
  set(${PROJECT_NAME}_CXX_FLAGS
    /W4
    /WX
  )
endif()