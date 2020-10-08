# cxx-cmake-project

Basic C++ CMAKE project settings to make starting projects easier !

## Project structure

```
root
  - bin            : default executable output dir
  - lib            : default lib output dir
  - include        : default headers output dir

  - external
    + include      : default include dir for imported libs without a find package script
    + lib          : default lib dir for imported libs without a find package script
  
  - sources        : source directory
    + module 1     : a target (lib or exec)
    + module 2     : another target (lib or exec)
    + ...
  
  - cmake-settings : cmake utilities and settings

```

## How to declare a new target

To declare a new target, create a new subdirectory in the ```sources``` directory, and copy paste the ```blank-target.cmake``` file there. Rename it to ```CMakeLists.txt``` and modify values as needed.

Variables declared in this file :
```
TARGET_NAME            : the name of your target
TARGET_TYPE            : the type of your target (EXEC or LIB)

TARGET_PUBLIC_HEADERS  : headers used by your target (public)
TARGET_PRIVATE_HEADERS : headers used by your target (private)
TARGET_SOURCES         : sources used by your target

TARGET_LIBS            : declares the target dependencies
TARGET_LIBS_INCLUDE    : declare include folders of your dependencies here
```

**note** : when building a library, ***public*** headers are exported to the ```INSTALL_INCLUDE_DIR``` directory. ***Private*** headers are not. There are no effects when building executables.

## How to build the project

To configure the project in a ```build``` directory, run :
```bash
mkdir build && cd build
cmake .. -G <GENERATOR> -DCMAKE_BUILD_TYPE=<Release | Debug>
```
Then to build and install the project, run :
```bash
cmake --build . --target install
```

Examples of ***generator values*** :
- ```"Unix Makefiles"```
- ```"Visual Studio 16 2019"```
