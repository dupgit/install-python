#!/bin/env bash
#
#  install-python.bash is a script that may install python and a huge number
#                      of usefull modules
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
# cmake, blas-devel, lapack-devel
#

#
# Below some variables that you can adapt to reflect the version you need
#

# Specify a proxy in the form http_proxy="http://user:pass@my.site:port/"
export http_proxy=""
export https_proxy=""

# Temporary directory where we will run the script.
export TMPDIR="/tmp/install-python"

# Path where to install python. Make sure that you have write access here.
export CONF_PREFIX="/usr/local/python/2.7.3"

# FILE where we want to log things.
export LOG_FILE="$TMPDIR/install-python.log"

############### There should be no need to change anything below ###############

# URL and file to be downloaded and the directory created when untaring the downloaded file :
export PYTHON_FILE="Python-2.7.3.tgz"
export PYTHON_URL="http://www.python.org/ftp/python/2.7.3/Python-2.7.3.tgz"
export PYTHON_DIR="Python-2.7.3"

# setuptools :
export SETUP_TOOLS_FILE="setuptools-0.6c11.tar.gz"
export SETUP_TOOLS_URL="https://pypi.python.org/packages/source/s/setuptools/setuptools-0.6c11.tar.gz#md5=7df2a529a074f613b509fb44feefe74e"
export SETUP_TOOLS_DIR="setuptools-0.6c11"

# vtk :
export VTK_FILE="vtk-5.10.1.tar.gz"
export VTK_URL="http://www.vtk.org/files/release/5.10/vtk-5.10.1.tar.gz"
export VTK_DIR="VTK5.10.1"
export VTK_DATA_FILE="vtkdata-5.10.1.tar.gz"
export VTK_DATA_URL="http://www.vtk.org/files/release/5.10/vtkdata-5.10.1.tar.gz"
export VTK_DATA_DIR="vtkdata-5.10.1"

# wxpython :
export WXPYTHON_URL=" http://downloads.sourceforge.net/wxpython/wxPython-src-2.9.4.0.tar.bz2"
export WXPYTHON_FILE="wxPython-src-2.9.4.0.tar.bz2"
export WXPYTHON_DIR="wxPython-src-2.9.4.0"

# hdf5 library :
export HDF5_URL="http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.10-patch1.tar.gz"
export HDF5_FILE="hdf5-1.8.10-patch1.tar.gz"
export HDF5_DIR="hdf5-1.8.10-patch1"

# h5py
export H5PY_URL="https://github.com/h5py/h5py.git"

# basemap 1.0.6 (does not work with pip nor easy_install) :
export BASEMAP_URL="http://sourceforge.net/projects/matplotlib/files/matplotlib-toolkits/basemap-1.0.6/basemap-1.0.6.tar.gz/download"
export BASEMAP_FILE="basemap-1.0.6.tar.gz"
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
export PYHDF_FILE="pyhdf-0.8.3.tar.gz"
export PYHDF_DIR="pyhdf-0.8.3"


# Some arguments to make : be silent and use 8 threads
export MAKE_ARGS="-s -j 8"

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
    wget -qc $1
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


    echo $(date) " -> Installing  $2"  | tee -a $LOG_FILE 2>&1

    get_and_uncompress $1 $2 $3 >> $LOG_FILE 2>&1

    cd $4
    ./configure $5 >> $LOG_FILE 2>&1
    make $MAKE_ARGS >> $LOG_FILE 2>&1
    make install >> $LOG_FILE 2>&1

    # Cleaning a bit
    cleaning_a_bit $2 $4 >> $LOG_FILE 2>&1
}


###
# Main script is begining here.
#

# Adding a trap if we want to kill everything
trap kill_everything EXIT;


# Making the temporary directory and zeroing the logfile
mkdir -p $TMPDIR
rm -f $LOG_FILE
touch $LOG_FILE


# Copying the file needed for the script :
cp indep_package_list $TMPDIR/


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
export PATH=$PYTHONPATH/bin:$PATH
export CPATH=$PYTHONPATH/include
export LD_LIBRARY_PATH=$PYTHONPATH/lib:$LD_LIBRARY_PATH


###
# Getting setuptools and distutils to enable easy_install
#
echo $(date) " -> Installing setuptools" | tee -a >> $LOG_FILE
get_and_uncompress $SETUP_TOOLS_URL $SETUP_TOOLS_FILE zxf  >> $LOG_FILE 2>&1

# installing setuptools
cd $SETUP_TOOLS_DIR
python setup.py install >> $LOG_FILE 2>&1

# Cleaning a bit
cleaning_a_bit $SETUP_TOOLS_DIR $SETUP_TOOLS_FILE


###
# Installing pip with easy_install. We will use pip to install the other packages
#
easy_install pip


###
# Installing packages that do not need anything else than themselves with pip !
#
cd $TMPDIR
for package in $(cat indep_package_list); do
    echo $(date) " -> Installing $package" | tee -a $LOG_FILE 2>&1
    pip install -q $package; >> $LOG_FILE 2>&1
done


##
# Installing vtk
#
echo $(date) " -> Installing vtk" | tee -a $LOG_FILE 2>&1
get_and_uncompress $VTK_URL $VTK_FILE zxf >> $LOG_FILE 2>&1

# Compiling and installing to the right directory
export CMAKE_INSTALL_PREFIX=$CONF_PREFIX
cd $VTK_DIR
mkdir build
cd build
ccmake ../VTK >> $LOG_FILE 2>&1
cmake $MAKE_ARGS >> $LOG_FILE 2>&1
cmake install >> $LOG_FILE 2>&1

export CPATH=$CONF_PREFIX/include
export LD_LIBRARY_PATH=$CONF_PREFIX/lib:${LD_LIBRARY_PATH}

# Cleaning a bit
cleaning_a_bit $VTK_FILE $VTK_DIR


###
# Installing wxpython
#
echo $(date) " -> Installing wxpython" | tee -a $LOG_FILE 2>&1
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
# Installing h5py by hand because the hdf5 library is in a specific directory
#
echo $(date) " -> Installing h5py" | tee -a $LOG_FILE 2>&1
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
echo $(date) " -> Installing basemap" | tee -a $LOG_FILE 2>&1
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
echo $(date) " -> Installing pydhf" | tee -a $LOG_FILE 2>&1
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
for package in ets etsproxy ; do
    echo $(date) " -> Installing $package" | tee -a $LOG_FILE 2>&1
    pip install $package; >> $LOG_FILE 2>&1
done

