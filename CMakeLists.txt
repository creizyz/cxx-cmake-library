cmake_minimum_required(VERSION 3.13)

# ================================================================== #

include(cmake/settings/project.cmake)
project(${PROJECT_NAME} VERSION "${${PROJECT_NAME}_MAJOR_VERSION}.${${PROJECT_NAME}_MINOR_VERSION}.${${PROJECT_NAME}_PATCH_VERSION}")

# ================================================================== #
# ================================================== # Options

option(${PROJECT_NAME}_BUILD_DOCS      "Builds project documentation" ON)
option(${PROJECT_NAME}_BUILD_EXAMPLES  "Builds project examples"      ON)
option(${PROJECT_NAME}_BUILD_TESTS     "Builds project tests"         ON)
option(${PROJECT_NAME}_BUILD_STATIC    "Builds static library"        OFF)

# ================================================================== #
# ================================================== # Version file

set(PROJECT_MAJOR_VERSION ${${PROJECT_NAME}_MAJOR_VERSION})
set(PROJECT_MINOR_VERSION ${${PROJECT_NAME}_MINOR_VERSION})
set(PROJECT_PATCH_VERSION ${${PROJECT_NAME}_PATCH_VERSION})

configure_file(src/version.hpp.in include/version.hpp)

# ================================================================== #
# ================================================== # Install directory

if (WIN32)
  if (DEFINED $ENV{ProgramW6432})
    set(DEFAULT_INSTALL_PATH "$ENV{ProgramW6432}/${PROJECT_NAME}")
  else()
    set(DEFAULT_INSTALL_PATH "$ENV{PROGRAMFILES}/${PROJECT_NAME}")
  endif()
else()
  set(DEFAULT_INSTALL_PATH "${CMAKE_BINARY_DIR}/installed")
endif()

if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set (CMAKE_INSTALL_PREFIX "${DEFAULT_INSTALL_PATH}" CACHE PATH "default install path" FORCE)
endif()

# ================================================================== #
# ================================================== # Principal target

file(GLOB_RECURSE HEADERS CONFIGURE_DEPENDS include/*.hpp)
file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS src/*.cpp)

if (${PROJECT_NAME}_BUILD_STATIC)
  add_library(${TARGET_NAME} STATIC ${HEADERS} ${SOURCES})
else()
  add_library(${TARGET_NAME} SHARED ${HEADERS} ${SOURCES})
endif()

include(cmake/settings/cpp.cmake)
target_compile_features(${TARGET_NAME} PUBLIC "${${PROJECT_NAME}_CXX_STANDARD}")
target_compile_options(${TARGET_NAME} PRIVATE "${${PROJECT_NAME}_CXX_FLAGS}")

# ================================================================== #
# ================================================== # Git Version Tracking

add_subdirectory(external/git_watcher)
target_link_libraries(${TARGET_NAME} git_watcher)

# ================================================================== #
# ================================================== # Dependencies

target_link_directories(${TARGET_NAME} PUBLIC external/lib)
target_include_directories(${TARGET_NAME} PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}/include
  ${CMAKE_CURRENT_BINARY_DIR}/include
  ${CMAKE_CURRENT_SOURCE_DIR}/external/include
)

include(cmake/settings/dependencies.cmake)

# ================================================================== #
# ================================================== # Other targets

if(${PROJECT_NAME}_BUILD_DOCS)
  include_directories(docs)
endif()

if(${PROJECT_NAME}_BUILD_EXAMPLES)
  include_directories(examples)
endif()

if(${PROJECT_NAME}_BUILD_TESTS)
  include_directories(tests)
endif()

# ================================================================== #
# ================================================== # Installation

file(GLOB FIND_PACKAGE_FILE CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/cmake/install/Find*.cmake)

install(TARGETS   ${TARGET_NAME}                                  DESTINATION lib)
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/            DESTINATION include)
install(FILES     ${CMAKE_CURRENT_BINARY_DIR}/include/version.hpp DESTINATION include)
install(FILES     ${FIND_PACKAGE_FILE}                            DESTINATION cmake)