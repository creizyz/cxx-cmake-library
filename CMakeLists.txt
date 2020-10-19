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

configure_file(src/version.hpp.in version.hpp)

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

message("Install directory set to : ${CMAKE_INSTALL_PREFIX}")

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

# ================================================================== #
# ================================================== # Git Version Tracking

add_subdirectory(external/git_watcher)
target_link_libraries(${TARGET_NAME} PRIVATE git_watcher)

# ================================================================== #
# ================================================== # Dependencies

target_link_directories(${TARGET_NAME} PUBLIC
  $<INSTALL_INTERFACE:external/lib>
)
target_include_directories(${TARGET_NAME} PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
  $<INSTALL_INTERFACE:include>
)
target_include_directories(${TARGET_NAME} PRIVATE
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/external/include>
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

include(GenerateExportHeader)

install(TARGETS ${TARGET_NAME} EXPORT ${PROJECT_NAME}Targets
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  RUNTIME DESTINATION bin
  INCLUDES DESTINATION include
)

install(DIRECTORY include/ DESTINATION include)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/version.hpp DESTINATION include)

# ================================================================== #
# ================================================== # Package Generation


# set_property(TARGET ${TARGET_NAME} PROPERTY VERSION ${${PROJECT_NAME}_MAJOR_VERSION})
# set_property(TARGET ${TARGET_NAME} PROPERTY SOVERSION 3)
# set_property(TARGET ${TARGET_NAME} PROPERTY INTERFACE_${PROJECT_NAME}_MAJOR_VERSION ${${PROJECT_NAME}_MAJOR_VERSION})
# set_property(TARGET ${TARGET_NAME} APPEND PROPERTY
#   COMPATIBLE_INTERFACE_STRING ${PROJECT_NAME}_MAJOR_VERSION
# )

# 
include(CMakePackageConfigHelpers)

write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/cmake/${PROJECT_NAME}ConfigVersion.cmake"
  VERSION ${${PROJECT_NAME}_VERSION}
  COMPATIBILITY AnyNewerVersion
)

export(EXPORT ${PROJECT_NAME}Targets
  FILE "${CMAKE_CURRENT_BINARY_DIR}/cmake/${PROJECT_NAME}Targets.cmake"
  NAMESPACE ${PROJECT_NAME}::
)

configure_file(cmake/install/ProjectConfig.cmake "${CMAKE_CURRENT_BINARY_DIR}/cmake/${PROJECT_NAME}Config.cmake")

install(EXPORT ${PROJECT_NAME}Targets
  FILE ${PROJECT_NAME}Targets.cmake
  NAMESPACE ${PROJECT_NAME}::
  DESTINATION cmake
)

install(
  FILES
    cmake/${PROJECT_NAME}Config.cmake
    "${CMAKE_CURRENT_BINARY_DIR}/cmake/${PROJECT_NAME}ConfigVersion.cmake"
  DESTINATION cmake
  COMPONENT Devel
)