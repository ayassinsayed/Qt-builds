#!/bin/bash

#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of 'Qt-builds' project.
# Copyright (c) 2013 by Alexpux (alexpux@gmail.com)
# All rights reserved.
#
# Project: Qt-builds ( https://github.com/Alexpux/Qt-builds )
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# - Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in
#     the documentation and/or other materials provided with the distribution.
# - Neither the name of the 'Qt-builds' nor the names of its contributors may
#     be used to endorse or promote products derived from this software
#     without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# **************************************************************************

P=qt
P_V=$P-$QTVER
PKG_TYPE="git"
PKG_SRC_FILE=

PKG_TYPE=git

PKG_URLS=(
	"git://gitorious.org/qt/qt5.git|repo:$PKG_TYPE|branch:$QT_GIT_BRANCH"
	"git://gitorious.org/qt/qtactiveqt.git|repo:$PKG_TYPE|dir:qtactiveqt|branch:$QT_GIT_BRANCH"
	"git://gitorious.org/qt/qtbase.git|repo:$PKG_TYPE|dir:qtbase|branch:$QT_GIT_BRANCH"
	"git://gitorious.org/qt/qtdeclarative.git|repo:$PKG_TYPE|dir:qtdeclarative|branch:$QT_GIT_BRANCH"
	"git://gitorious.org/qt/qtdoc.git|repo:$PKG_TYPE|dir:qtdoc|branch:$QT_GIT_BRANCH"
	"git://gitorious.org/qt/qtgraphicaleffects.git|repo:$PKG_TYPE|dir:qtgraphicaleffects|branch:$QT_GIT_BRANCH"
	"git://gitorious.org/qt/qtimageformats.git|repo:$PKG_TYPE|dir:qtimageformats|branch:$QT_GIT_BRANCH"
	"git://gitorious.org/qt/qtjsbackend.git|repo:$PKG_TYPE|dir:qtjsbackend|branch:$QT_GIT_BRANCH"
	"git://gitorious.org/qt/qtmultimedia.git|repo:$PKG_TYPE|dir:qtmultimedia|branch:$QT_GIT_BRANCH"
	"git://gitorious.org/qt/qtquick1.git|repo:$PKG_TYPE|dir:qtquick1|branch:$QT_GIT_BRANCH"
	"git://gitorious.org/qt/qtquickcontrols.git|repo:$PKG_TYPE|dir:qtquickcontrols|branch:$QT_GIT_BRANCH"
	"git://gitorious.org/qt/qtscript.git|repo:$PKG_TYPE|dir:qtscript|branch:$QT_GIT_BRANCH"
	"git://gitorious.org/qt/qtserialport.git|repo:$PKG_TYPE|dir:qtserialport|branch:$QT_GIT_BRANCH"
	"git://gitorious.org/qt/qtsvg.git|repo:$PKG_TYPE|dir:qtsvg|branch:$QT_GIT_BRANCH"
	"git://gitorious.org/qt/qttools.git|repo:$PKG_TYPE|dir:qttools|branch:$QT_GIT_BRANCH"
	"git://gitorious.org/qt/qttranslations.git|repo:$PKG_TYPE|dir:qttranslations|branch:$QT_GIT_BRANCH"
	"git://gitorious.org/qt/qtwebkit.git|repo:$PKG_TYPE|dir:qtwebkit|branch:$QT_GIT_BRANCH"
	"git://gitorious.org/qt/qtwebkit-examples.git|repo:$PKG_TYPE|dir:qtwebkit-examples|branch:$QT_GIT_BRANCH"
	"git://gitorious.org/qt/qtxmlpatterns.git|repo:$PKG_TYPE|dir:qtxmlpatterns|branch:$QT_GIT_BRANCH"
)

PKG_DEPENDS=(gperf icu fontconfig freetype libxml2 libxslt pcre perl ruby)

change_paths() {
	local _sql_include=
	local _sql_lib=
	[[ $STATIC_DEPS == no ]] && {
		_sql_include="$QTDIR/databases/firebird/include:$QTDIR/databases/mysql/include/mysql:$QTDIR/databases/pgsql/include:$QTDIR/databases/oci/include"
		_sql_lib="$QTDIR/databases/firebird/lib:$QTDIR/databases/mysql/lib:$QTDIR/databases/pgsql/lib:$QTDIR/databases/oci/lib"
	}
	export INCLUDE="$MINGWHOME/$HOST/include:$PREFIX/include:$PREFIX/include/libxml2:${_sql_include}"
	export LIB="$MINGWHOME/$HOST/lib:$PREFIX/lib:${_sql_lib}"
	export CPATH="$MINGWHOME/$HOST/include:$PREFIX/include:$PREFIX/include/libxml2:${_sql_include}"
	export LIBRARY_PATH="$MINGWHOME/$HOST/lib:$PREFIX/lib:${_sql_lib}"
	OLD_PATH=$PATH
	export PATH=$BUILD_DIR/$P_V-${QTDIR_PREFIX}/qtbase/bin:$BUILD_DIR/$P_V-${QTDIR_PREFIX}/qtbase/lib:$MINGW_PART_PATH:$MSYS_PART_PATH:$WINDOWS_PART_PATH
	#$SRC_DIR/$P_V-${QTDIR_PREFIX}/gnuwin32/bin:
}

restore_paths() {
	unset INCLUDE
	unset LIB
	unset CPATH
	unset LIBRARY_PATH
	export PATH=$OLD_PATH
	unset OLD_PATH
}

src_download() {
	func_download
}

src_unpack() {
	echo "---> Empty unpack"
}

src_patch() {
	local _patches=(
		$P/5.0.x/qt-5.0.0-use-fbclient-instead-of-gds32.patch
		$P/5.0.x/qt-5.0.0-oracle-driver-prompt.patch
		$P/5.1.x/qt-5.1.0-win32-g++-mkspec-optimization.patch
		$P/5.1.x/qt-5.1.x-fix-configure-tests.patch
		$P/5.1.x/qt-5.1.x-syncqt-fix.patch
		$P/5.1.x/qt-5.1.x-win_flex-replace.patch
	)

	func_apply_patches \
		_patches[@]
}

src_configure() {
	pushd $UNPACK_DIR/$P_V/qtbase/mkspecs/win32-g++ > /dev/null
		[[ -f qmake.conf.patched ]] && {
			rm -f qmake.conf
			cp -f qmake.conf.patched qmake.conf
		} || {
			cp -f qmake.conf qmake.conf.patched
		}

		cat qmake.conf | sed 's|%OPTIMIZE_OPT%|'"$OPTIM"'|g' \
					| sed 's|%STATICFLAGS%|'"$STATIC_LD"'|g' > qmake.conf.tmp
		rm -f qmake.conf
		mv qmake.conf.tmp qmake.conf
	popd > /dev/null
	
	[[ ! -d ${QTDIR}/databases && $STATIC_DEPS == no ]] && {
		mkdir -p ${QTDIR}/databases
		echo "---> Sync database folder... "
		rsync -av ${PATCH_DIR}/${P}/databases-${ARCHITECTURE}/ ${QTDIR}/databases/ > /dev/null
		echo "done"
	}

	[[ -f $BUILD_DIR/$P_V-${QTDIR_PREFIX}/configure.marker ]] && {
		echo "---> configured"
	} || {
		mkdir -p $BUILD_DIR/$P_V-${QTDIR_PREFIX}
		pushd $BUILD_DIR/$P_V-${QTDIR_PREFIX} > /dev/null
		echo -n "---> configure..."
		local _opengl
		[[ $USE_OPENGL_DESKTOP == yes ]] && {
			_opengl="-opengl desktop"
		} || {
			_opengl="-angle"
		}
	
		change_paths
		local _mode=shared
		[[ $STATIC_DEPS == yes ]] && {
			_mode=static
		}
		local _conf_flags=(
			-prefix $QTDIR_WIN
			-opensource
			-$_mode
			-confirm-license
			$( [[ $STATIC_DEPS == no ]] \
				&& echo "-plugin-sql-ibase \
						 -plugin-sql-mysql \
						 -plugin-sql-psql \
						 -plugin-sql-odbc \
						 -no-iconv \
						 -icu \
						 -system-pcre \
						 -system-zlib" \
				|| echo "-no-icu \
						 -no-iconv \
						 -qt-sql-sqlite \
						 -qt-zlib \
						 -qt-pcre" \
			)
			-fontconfig
			-openssl
			-no-dbus
			$_opengl
			-platform win32-g++
			-nomake tests
			-nomake examples
		)
		local _allconf="${_conf_flags[@]}"
		local _rel_path=$( func_absolute_to_relative $BUILD_DIR/${P_V}-${QTDIR_PREFIX} $UNPACK_DIR/${P_V} )
		$_rel_path/configure.bat \
			$_allconf \
			> ${LOG_DIR}/${P_V}_configure.log 2>&1 || die "Qt configure error"
	
		restore_paths
		echo " done"
		touch configure.marker
		popd > /dev/null
	}
}

pkg_build() {
	change_paths
	[[ $USE_OPENGL_DESKTOP == no ]] && {
		#Workaround for
		#https://bugreports.qt-project.org/browse/QTBUG-28845
		mkdir -p $BUILD_DIR/$P_V-${QTDIR_PREFIX}/qtbase/src/angle/src/libGLESv2
		pushd $BUILD_DIR/$P_V-${QTDIR_PREFIX}/qtbase/src/angle/src/libGLESv2 > /dev/null
		[[ -f workaround.marker ]] && {
			echo "---> Workaround applied"
		} || {
			echo -n "---> Applying workaround..."
			local _rel_path=$( func_absolute_to_relative $BUILD_DIR/${P_V}-${QTDIR_PREFIX}/qtbase/src/angle/src/libGLESv2 $SRC_DIR/${P_V}/qtbase/src/angle/src/libGLESv2 )
			qmake $_rel_path/libGLESv2.pro
			cat Makefile.Debug | grep fxc.exe | cmd > workaround.log 2>&1
			echo " done"
			touch workaround.marker
		}
		popd > /dev/null
	} 
	
	local _make_flags=(
		${MAKE_OPTS}
	)
	local _allmake="${_make_flags[@]}"
	func_make \
		$P_V-${QTDIR_PREFIX} \
		"mingw32-make" \
		"$_allmake" \
		"building..." \
		"built"

	restore_paths
}

pkg_install() {
	change_paths
	
	local _install_flags=(
		${MAKE_OPTS}
		install
	)
	local _allinstall="${_install_flags[@]}"
	func_make \
		$P_V-${QTDIR_PREFIX} \
		"mingw32-make" \
		"$_allinstall" \
		"installing..." \
		"installed"

	install_docs
	put_sha1

	# Workaround for build other components (qbs, qtcreator, etc)
	[[ ! -f $BUILD_DIR/$P_V-${QTDIR_PREFIX}/qwindows.marker && $STATIC_DEPS == yes ]] && {
		cp -f ${QTDIR}/plugins/platforms/libqwindows.a ${QTDIR}/lib/
		cp -f ${QTDIR}/plugins/platforms/libqwindowsd.a ${QTDIR}/lib/
		touch $BUILD_DIR/$P_V-${QTDIR_PREFIX}/qwindows.marker
	}

	restore_paths
}

install_docs() {

	local _make_flags=(
		${MAKE_OPTS}
		docs
	)
	local _allmake="${_make_flags[@]}"
	func_make \
		$P_V-${QTDIR_PREFIX} \
		"mingw32-make" \
		"$_allmake" \
		"building docs..." \
		"built-docs"

	_make_flags=(
		${MAKE_OPTS}
		install_qch_docs
	)
	_allmake="${_make_flags[@]}"
	func_make \
		$P_V-${QTDIR_PREFIX} \
		"mingw32-make" \
		"$_allmake" \
		"installing docs..." \
		"installed-docs"
}

put_sha1() {
	[[ -d $SRC_DIR/$P_V ]] && {
		pushd $SRC_DIR/$P_V > /dev/null
			echo -n "$MAINMODULE SHA1: " > $QTDIR/sha1s
			git log -1 --pretty=format:%H >> $QTDIR/sha1s
			echo " ;" >> $QTDIR/sha1s
		popd > /dev/null
	}

	local mod=
	for mod in ${SUBMODULES[@]}; do
		[[ -d $SRC_DIR/$P_V/$mod ]] && {
			pushd $SRC_DIR/$P_V/$mod > /dev/null
				echo -n "$mod SHA1: " >> $QTDIR/sha1s
				git log -1 --pretty=format:%H >> $QTDIR/sha1s
				echo " ;" >> $QTDIR/sha1s
			popd > /dev/null
		}
	done
}
