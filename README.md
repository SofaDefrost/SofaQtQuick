This project is a plugin and an executable GUI for SOFA based on the QtQuick library. This work is based on an initial project from [Anatoscope](www.anatoscope.com). For your information, the roadmap of the project is available on a dedicated [issue](https://github.com/sofa-framework/SofaQtQuick/issues/1).

# Features 
- Scene graph editing
- Interactive modeling
- Project oriented approach
- Prefab as reusable and parametric object
- 2D Canvas
- Custom widgets per component
- Live coding
- Non-linear workflow

<table>
  <tr>
    <td>Scene editting <a href="https://www.youtube.com/watch?v=IGsgy_pQhb8"><img src="https://img.youtube.com/vi/IGsgy_pQhb8/maxresdefault.jpg"></a> </td>
    <td>Modelling: <a href="https://www.youtube.com/watch?v=9nY6zj3iXXw"><img src="https://img.youtube.com/vi/9nY6zj3iXXw/0.jpg"></a> </td>
 </tr>
 <tr>
    <td>Prefab <a href="https://www.youtube.com/watch?v=K_buPD9uhos"><img src="https://img.youtube.com/vi/K_buPD9uhos/maxresdefault.jpg"></a> </td>
    <td>Parametric modelling <a href="https://www.youtube.com/watch?v=668z91Nj_80"><img src="https://img.youtube.com/vi/668z91Nj_80/maxresdefault.jpg"></a> </td>
 </tr>
 <tr>
    <td>Custom UI<a href="https://www.youtube.com/watch?v=9aTIHwENGaM"><img src="https://img.youtube.com/vi/9aTIHwENGaM/maxresdefault.jpg"></a> </td>
    <td>: <a href="https://www.youtube.com/watch?v=btkhY6d7hpY"><img src="https://img.youtube.com/vi/btkhY6d7hpY/maxresdefault.jpg"></a> </td>
 </tr>
</table>


# How to build runSofa2 on MacOS

## get code, plugins, source dependencies...

### get all the source code
```
$ mkdir runsofa2
$ cd runsofa2
$ mkdir plugins
$ cd plugins
$ git clone git@github.com:SofaDefrost/SofaQtQuick.git -b macos
$ git clone git@github.com:SofaDefrost/plugin.SofaPython3.git -b fix_for_SofaQtQuick
$ cd ..
$ git clone git@github.com:SofaDefrost/sofa.git -b SofaQtQuickGUI
$ git clone git@github.com:paceholder/nodeeditor.git
```

### plugins/CMakeLists.txt

Create a CmakeLists.txt in the plugins/ directory:

```
add_subdirectory(plugin.SofaPython3)
add_subdirectory(SofaQtQuick)
```

## dependencies

### Qt5

Better take brew's version of qt5 instead of downloading it form their website

```
$ brew install qt
```
### pybind

```
$ brew install pybind11
```
### ccache (optionnal)

```
$ brew install ccache
```

### nodeeditor

nodeeditor is a third-party library necessary for some gui widgets.

```
$ cd nodeeditor
$ mkdir build
$ cd build
$ cmake ..
$ make
$ cd ../..
```

## build

```
$ mkdir build
$ cd build
$ cmake ../sofa -DSOFA_EXTERNAL_DIRECTORIES="../plugins" -DAPPLICATION_RUNSOFA2=ON -DSOFA_USE_CCACHE=ON -G "CodeBlocks - Ninja"
$ ninja
```

## have a coffee break during build :-)

## run

```
$ bin/runSofa2
```


***Hopefully, that's all folks !***
