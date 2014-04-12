#!/bin/env bash
#
#  install-python.bash is a script that may install python and a huge
#                      number of usefull modules
#
#  (C) Copyright 2013 Olivier Delhomme
#  e-mail : olivier.delhomme@free.fr
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software Foundation,
#  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

#
# Please make sure you have installed the following in your system :
# gmake, blas-devel, lapack-devel
#

#
# Below some variables that you can adapt to reflect the version you need
#

# Specify a proxy in the form http_proxy="http://user:pass@my.site:port/"
export http_proxy=""
export https_proxy=""

# Temporary directory where we will run the script.
export TMPDIR="/dev/shm/install-python"

export PYTHON_VERSION="2.7.6"

# Path where to install python. Make sure that you have write access here.
export CONF_PREFIX="/home/dup/local/python/$PYTHON_VERSION"

# FILE where we want to log things.
export LOG_FILE="$TMPDIR/install-python.log"

# Some arguments to make : be silent and use 8 threads
export MAKE_ARGS="-s -j 8"


############### There should be no need to change anything below ###############

# URL and file to be downloaded and the directory created when untaring the downloaded file :
export PYTHON_FILE="Python-2.7.6.tgz"
export PYTHON_URL="http://www.python.org/ftp/python/2.7.6/Python-2.7.6.tgz"
export PYTHON_DIR="Python-2.7.6"

# setuptools :
# Try the new way to install setuptools : https://pypi.python.org/pypi/setuptools/0.8#id1
export SETUP_TOOLS_FILE="setuptools-3.4.tar.gz"
export SETUP_TOOLS_URL="https://pypi.python.org/packages/source/s/setuptools/setuptools-3.4.tar.gz"
export SETUP_TOOLS_DIR="setuptools-3.4"

# vtk :
export VTK_FILE="VTK-6.1.0.tar.gz"
export VTK_URL="http://www.vtk.org/files/release/6.1/VTK-6.1.0.tar.gz"
export VTK_DIR="VTK-6.1.0"

export VTK_DATA_FILE="VTKData-6.1.0.tar.gz"
export VTK_DATA_URL="http://www.vtk.org/files/release/6.1/VTKData-6.1.0.tar.gz"
export VTK_DATA_DIR="VTKData6.1.0"

# wxpython :
export WXPYTHON_URL="http://downloads.sourceforge.net/wxpython/wxPython-src-3.0.0.0.tar.bz2"
export WXPYTHON_FILE="wxPython-src-3.0.0.0.tar.bz2"
export WXPYTHON_DIR="wxPython-src-3.0.0.0"

# hdf5 library :
export HDF5_URL="http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.12.tar.gz"
export HDF5_FILE="hdf5-1.8.12.tar.gz"
export HDF5_DIR="hdf5-1.8.12"

# h5py
export H5PY_URL="https://github.com/h5py/h5py.git"

# basemap 1.0.6 (does not work with pip nor easy_install) :
export BASEMAP_URL="http://sourceforge.net/projects/matplotlib/files/matplotlib-toolkits/basemap-1.0.6/basemap-1.0.6.tar.gz/download"
export BASEMAP_FILE="download"
export BASEMAP_DIR="basemap-1.0.6"

# SZIP needed for hdf4 which is needed for pyhdf
export SZIP_URL="http://www.hdfgroup.org/ftp/lib-external/szip/2.1/src/szip-2.1.tar.gz"
export SZIP_FILE="szip-2.1.tar.gz"
export SZIP_DIR="szip-2.1"

# HDF4
export HDF4_URL="http://www.hdfgroup.org/ftp/HDF/HDF_Current/src/hdf-4.2.9.tar.gz"
export HDF4_FILE="hdf-4.2.9.tar.gz"
export HDF4_DIR="hdf-4.2.9"

# pyhdf 0.8.3
export PYHDF_URL="http://sourceforge.net/projects/pysclint/files/pyhdf/0.8.3/pyhdf-0.8.3.tar.gz/download"
export PYHDF_FILE="download"
export PYHDF_DIR="pyhdf-0.8.3"

# Cmake
export CMAKE_URL="http://www.cmake.org/files/v2.8/cmake-2.8.12.tar.gz"
export CMAKE_FILE="cmake-2.8.12.tar.gz"
export CMAKE_DIR="cmake-2.8.12"

# Lapack
export LAPACK_URL="http://www.netlib.org/lapack/lapack-3.5.0.tgz"
export LAPACK_FILE="lapack-3.5.0.tgz"
export LAPACK_DIR="lapack-3.5.0"

# QT
export QT_URL="http://download.qt-project.org/archive/qt/4.8/4.8.5/qt-everywhere-opensource-src-4.8.5.tar.gz"
export QT_FILE="qt-everywhere-opensource-src-4.8.5.tar.gz"
export QT_DIR="qt-everywhere-opensource-src-4.8.5"

# PCRE (needed by SWIG)
export PCRE_URL="http://sourceforge.net/projects/pcre/files/pcre/8.35/pcre-8.35.tar.gz/download"
export PCRE_FILE="download"
export PCRE_DIR="pcre-8.35"

# SWIG
export SWIG_URL="http://sourceforge.net/projects/swig/files/swig/swig-3.0.0/swig-3.0.0.tar.gz/download"
export SWIG_FILE="download"
export SWIG_DIR="swig-3.0.0"

# WxWIDGETS
export WXWIDGETS_URL="https://sourceforge.net/projects/wxwindows/files/3.0.0/wxWidgets-3.0.0.tar.bz2"
export WXWIDGETS_FILE="wxWidgets-3.0.0.tar.bz2"
export WXWIDGET_DIR="wxWidgets-3.0.0"

###
# Begining of the script itself : function definitions
#

###
# Function that cleans files or directories
# Arguments : files and directories to delete
#
function cleaning_a_bit {

    cd $TMPDIR
    rm -fr $@

}


###
# Function that gets a file from an URL and uncompress it
# $1 the URL where to get the file
# $2 the file itself
# $3 args to the tar command
#
function get_and_uncompress {

    cd $TMPDIR
    wget -qc --no-check-certificate $1
    tar $3 $2

}


###
# Function that kills everything if needed. Used in a trap
#
function kill_everything {

    kill 0;

}


###
# Function to uncompress, configure, make and install a program from source
# $1 the URL where to get the file
# $2 the file itself
# $3 args to the tar command
# $4 the directory where the source is
# $5 configure options
#
function get_configure_make_install {

    pretty_print "$2"

    get_and_uncompress $1 $2 $3 >> $LOG_FILE 2>&1

    cd $4
    ./configure $5 >> $LOG_FILE 2>&1
    make $MAKE_ARGS >> $LOG_FILE 2>&1
    make install >> $LOG_FILE 2>&1

    # Cleaning a bit
    cleaning_a_bit $2 $4 >> $LOG_FILE 2>&1
}



###
# Function to add the install dir to the CmakeCache.txt file
# We assume that we are in the directory contaning CMakeCache.txt file
#
function configure_cmake_cache {

    grep -v CMAKE_INSTALL_PREFIX CMakeCache.txt >> CMakeCache2.txt
    echo "" >> CMakeCache2.txt
    echo "CMAKE_INSTALL_PREFIX:PATH=$CONF_PREFIX" >> CMakeCache2.txt
    rm CMakeCache.txt
    mv CMakeCache2.txt CMakeCache.txt

}


###
# Function to pretty print the date
# $1 is the package name to be installed
function pretty_print {

    echo $(date) " -> Installing $1" | tee -a $LOG_FILE

}


############################### End of functions ###############################


###
# Main script is begining here.
#

# Adding a trap if we want to kill everything upon exit
trap kill_everything EXIT;


# Making the temporary directory and zeroing the logfile
mkdir -p $TMPDIR
rm -f $LOG_FILE
touch $LOG_FILE


# Copying the file needed for the script :
cp indep_package_list $TMPDIR/


###
# Cmake installation
#
pretty_print "Cmake"
get_and_uncompress $CMAKE_URL $CMAKE_FILE zxf  >> $LOG_FILE 2>&1
mkdir -p $CMAKE_DIR/build
cd $CMAKE_DIR/build
../configure  >> $LOG_FILE 2>&1
configure_cmake_cache               # Putting $CONF_PREFIX as the install directory
gmake $MAKE_ARGS >> $LOG_FILE 2>&1
gmake install >> $LOG_FILE 2>&1

cleaning_a_bit $CMAKE_FILE $CMAKE_DIR


###
# Downloading, uncompressing, configuring, making and installing python itself
# Need the rights to write into $CONF_PREFIX directory
#
mkdir -p $CONF_PREFIX/lib
export LDFLAGS="-Wl,-rpath $CONF_PREFIX/lib"
get_configure_make_install $PYTHON_URL $PYTHON_FILE zxf $PYTHON_DIR "--prefix=$CONF_PREFIX --enable-shared --enable-ipv6 --enable-unicode"
unset LDFLAGS


# Exporting paths of the newly installed python (in order to avoid using an
# another installation and avoid to use $CONF_PREFIX/python everywhere)
export PYTHONPATH=$CONF_PREFIX
export PYTHONHOME=$CONF_PREFIX
export PATH=$PYTHONPATH/bin:$PATH
export CPATH=$PYTHONPATH/include
export LD_LIBRARY_PATH=$PYTHONPATH/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$CONF_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH

###
# Lapack and blas installation
#
pretty_print "Lapack and Blas"
get_and_uncompress $LAPACK_URL $LAPACK_FILE zxf  >> $LOG_FILE 2>&1
mkdir -p build
cd build
export CMAKE_INSTALL_PREFIX=$CONF_PREFIX
cmake -D "CMAKE_INSTALL_PREFIX:PATH=$CONF_PREFIX" -D "BUILD_SHARED_LIBS=true" ../$LAPACK_DIR >> $LOG_FILE 2>&1
gmake $MAKE_ARGS >> $LOG_FILE 2>&1
gmake install >> $LOG_FILE 2>&1

cleaning_a_bit $LAPACK_FILE $LAPACK_DIR build


###
# Qt
#
pretty_print "Qt"
get_and_uncompress $QT_URL $QT_FILE zxf  >> $LOG_FILE 2>&1
cd $QT_DIR
sed -i -e "s/read\ acceptance/acceptance=yes/" configure
./configure -prefix $CONF_PREFIX -opensource -shared -silent -optimized-qmake -nomake examples -nomake demos >> $LOG_FILE 2>&1
gmake $MAKE_ARGS >> $LOG_FILE 2>&1
gmake install >> $LOG_FILE 2>&1

cleaning_a_bit $QT_FILE $QT_DIR build


###
# PCRE
#
get_configure_make_install $PCRE_URL $PCRE_FILE zxf $PCRE_DIR "--prefix=$CONF_PREFIX"


###
# SWIG
#
get_configure_make_install $SWIG_URL $SWIG_FILE zxf $SWIG_DIR "--prefix=$CONF_PREFIX"


###
# Getting setuptools and distutils to enable easy_install
#
pretty_print "setuptools"
get_and_uncompress $SETUP_TOOLS_URL $SETUP_TOOLS_FILE zxf  >> $LOG_FILE 2>&1

# installing setuptools
cd $SETUP_TOOLS_DIR
python setup.py install >> $LOG_FILE 2>&1

# Cleaning a bit
cleaning_a_bit $SETUP_TOOLS_DIR $SETUP_TOOLS_FILE


###
# Installing pip with easy_install. We will use pip to install the other packages
#
pretty_print "pip"
easy_install pip


###
# Installing packages that do not need anything else than themselves with pip !
#
cd $TMPDIR
pretty_print ""$(wc -l indep_package_list | cut -d' ' -f1)" packages :"
for package in $(cat indep_package_list); do
    pretty_print "$package"
    pip install -q --allow-unverified --allow-all-external $package; >> $LOG_FILE 2>&1
done


##
# Installing vtk
#
pretty_print "vtk"
get_and_uncompress $VTK_URL $VTK_FILE zxf >> $LOG_FILE 2>&1
get_and_uncompress $VTK_DATA_URL $VTK_DATA_FILE zxf >> $LOG_FILE 2>&1
mv $VTK_DATA_DIR $CONF_PREFIX/share/  # Putting vtk data in $CONF_PREFIX/share/


# Compiling and installing to the right directory
export CMAKE_INSTALL_PREFIX=$CONF_PREFIX
export VTK_DATA_ROOT="$CONF_PREFIX/share/$VTK_DATA_DIR"
export BUILD_SHARED_LIBS=true
export BUILD_EXAMPLES=true
mkdir -p build
cd build
cmake -D "CMAKE_INSTALL_PREFIX:PATH=$CONF_PREFIX" -D "VTK_DATA_ROOT:PATH=$CONF_PREFIX/share/$VTK_DATA_DIR" -D "BUILD_SHARED_LIBS=true" -D "BUILD_EXAMPLES:BOOL=true" ../$VTK_DIR >> $LOG_FILE 2>&1
gmake $MAKE_ARGS >> $LOG_FILE 2>&1
gmake install >> $LOG_FILE 2>&1

# Cleaning a bit
cleaning_a_bit $VTK_FILE $VTK_DIR build $VTK_DATA_FILE
unset VTK_DATA_ROOT


###
# Installing WxWidgets
#
get_configure_make_install $WXWIDGETS_URL $WXWIDGETS_FILE jxf $WXWIDGETS_DIR "--prefix=$CONF_PREFIX"


###
# Installing wxpython
#
pretty_print "wxpython"
get_and_uncompress $WXPYTHON_URL $WXPYTHON_FILE jxf >> $LOG_FILE 2>&1

cd $WXPYTHON_DIR/wxPython
python build-wxpython.py --build_dir=../bld >> $LOG_FILE 2>&1

cleaning_a_bit $WXPYTHON_FILE $WXPYTHON_DIR


###
# Installing hdf5 library
#
get_configure_make_install $HDF5_URL $HDF5_FILE zxf $HDF5_DIR "--prefix=$CONF_PREFIX"

# Variable that may be used to know where hdf5 has been installed
export HDF5_DIR=$CONF_PREFIX


###
# Installing h5py by hand because the hdf5 library is in a specific directory (not in the system's)
#
pretty_print "h5py"
cd $TMPDIR
git clone $H5PY_URL >> $LOG_FILE 2>&1
cd h5py/h5py
python api_gen.py >> $LOG_FILE 2>&1
cd ..
python setup.py build --hdf5=$CONF_PREFIX >> $LOG_FILE 2>&1
python setup.py install >> $LOG_FILE 2>&1

cleaning_a_bit h5py


###
# Installing basemap by hand (it does not work with pip nor easy_install)
# Requires matplotlib, numpy, GEOS, PIL
#
pretty_print "basemap"
get_and_uncompress $BASEMAP_URL $BASEMAP_FILE zxf >> $LOG_FILE 2>&1
cd $BASEMAP_DIR
cd geos-3.3.3
export GEOS_DIR=$CONF_PREFIX
./configure --prefix=$GEOS_DIR >> $LOG_FILE 2>&1
make $MAKE_ARGS >> $LOG_FILE 2>&1
make install >> $LOG_FILE 2>&1
cd ..
python setup.py install >> $LOG_FILE 2>&1

cleaning_a_bit $BASEMAP_DIR $BASEMAP_FILE


###
# Installing SZIP (required for hdf4 which is required for pyhdf)
#
get_configure_make_install $SZIP_URL $SZIP_FILE zxf $SZIP_DIR "--prefix=$CONF_PREFIX"


###
# Installing hdf4 with SZIP
#
get_configure_make_install $HDF4_URL $HDF4_FILE zxf $HDF4_DIR "--prefix=$CONF_PREFIX --enable-shared --disable-fortran --with-szlib=$CONF_PREFIX"

###
# Installing pyhdf knowing that we have SZIP and hdf4 in $CONF_PREFIX
#
pretty_print "pydhf"
get_and_uncompress $PYHDF_URL $PYHDF_FILE zxf >> $LOG_FILE 2>&1
cd $PYHDF_DIR
export INCLUDE_DIRS=$CONF_PREFIX/include
export LIBRARY_DIRS=$CONF_PREFIX/lib
python setup.py install >> $LOG_FILE 2>&1
unset INCLUDE_DIRS
unset LIBRARY_DIRS

cleaning_a_bit $PYHDF_DIR $PYHDF_FILE


# Do we need this ?
#echo "[install]" > $CONF_PREFIX/lib/python2.7/distutils/distutil.cfg
#echo "install_lib = $CONF_PREFIX/lib/python2.7/site-packages" >> $CONF_PREFIX/lib/python2.7/distutils/distutil.cfg
#echo "install_scripts = $CONF_PREFIX/bin" >> $CONF_PREFIX/lib/python2.7/distutils/distutil.cfg

# installing the packages that need vtk, hdf5, h5py and so on
for package in ets etsproxy PySide; do
    pretty_print "$package"
    pip install --allow-unverified --allow-all-external $package; >> $LOG_FILE 2>&1
done

