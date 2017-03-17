#!/bin/bash

# This file is part of BOINC.
# http://boinc.berkeley.edu
# Copyright (C) 2017 University of California
#
# BOINC is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License
# as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
#
# BOINC is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with BOINC.  If not, see <http://www.gnu.org/licenses/>.

# Script to build a wxWidgets GTK version for BOINC

# Usage:
#  cd [path]/wxWidgets-3.0.2/
#  source path_to_this_script [--clean] [--debug] [--prefix PATH]
#
# the --clean argument will force a full rebuild.
# the --debug argument will build the debug version of the library
# if --prefix is given as absolute path the library is installed into there


doclean=""
configuration="Release"
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -clean|--clean)
        doclean="yes"
        ;;
        -debug|--debug)
        configuration="Debug"
        ;;
        -prefix|--prefix)
        lprefix="$2"
        shift
        ;;
    esac
    shift # past argument or value
done

debug_flag="--disable-debug_flag"
if [ $configuration = "Debug" ]; then
    debug_flag="--enable-debug"
fi

if [ "${doclean}" = "yes" ]; then
    make clean
fi

mkdir buildgtk
if [  $? -ne 0 ]; then exit 1; fi
cd buildgtk || return 1

../configure --prefix="${lprefix}" --with-gtk --disable-shared --enable-webview --disable-gtktest --disable-sdltest ${debug_flag}
if [ $? -ne 0 ]; then cd ..; return 1; fi
make 1>/dev/null # the wxWidgets build is very noisy so tune it down to warnings and errors only
if [ $? -ne 0 ]; then cd ..; return 1; fi
make install
if [ $? -ne 0 ]; then cd ..; return 1; fi

cd ..
return 0
