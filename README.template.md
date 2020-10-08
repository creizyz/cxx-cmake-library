# ExampleProject

This project was initialized using [cxx-cmake-project](https://github.com/creizyz/cxx-cmake-project).

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