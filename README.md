# VTrade
An application to virtual trade operations. It's free, open-source and released under the GPLv3 license.

You can build and run VTrade on smart phones like iOS and Androids or on the Linux, Windows or macOS.

## How to Build

### Dependencies

VTrade client depended on below library and modules.

#### Required Dependencies

- Qt 5.15.2 or newer [ [Source](https://download.qt.io/official_releases/qt/5.15/5.15.4/single/), [Binary Package](https://download.qt.io/official_releases/online_installers/)]
- QtAseman 3.1.5 or newer [[Git Repository](https://github.com/Aseman-Land/QtAseman)]

### Build

To build VTrade just clone it and build it using QtCreator. You can also build it from command line using below commands:

```bash
git clone https://github.com/Aseman-Land/vtrade --recursive --depth 1
cd Tricks
mkdir build && cd build
qmake -r .. CONFIG+="qtquickcompiler"
make -j4
make install
```

