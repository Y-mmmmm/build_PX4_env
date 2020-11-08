#! /usr/bin/env bash
INSTALL_NUTTX="true"
INSTALL_SIM="true"


# NuttX toolchain (arm-none-eabi-gcc)
if [[ $INSTALL_NUTTX == "true" ]]; then

	echo
	echo "Installing NuttX dependencies"

	sudo DEBIAN_FRONTEND=noninteractive apt-get -y --quiet --no-install-recommends install \
		autoconf \
		automake \
		bison \
		bzip2 \
		flex \
		gdb-multiarch \
		gperf \
		libncurses-dev \
		libtool \
		pkg-config \
		vim-common \
		;

	# add user to dialout group (serial port access)
	sudo usermod -a -G dialout $USER

	# Remove modem manager (interferes with PX4 serial port/USB serial usage).
	sudo apt-get remove modemmanager -y

	# arm-none-eabi-gcc
	NUTTX_GCC_VERSION="7-2017-q4-major"

if [ $(which arm-none-eabi-gc) ]; then
	GCC_VER_STR=$(arm-none-eabi-gcc --version)
	GCC_FOUND_VER=$(echo $GCC_VER_STR | grep -c "${NUTTX_GCC_VERSION}")
fi

	if [ ! ${GCC_FOUND_VER+x} && $GCC_FOUND_VER -eq "1" ]; then
		echo "arm-none-eabi-gcc-${NUTTX_GCC_VERSION} found, skipping installation"

	else
		echo "Installing arm-none-eabi-gcc-${NUTTX_GCC_VERSION}";
		#modify:delate the download codes
		sudo tar -jxf /tmp/gcc-arm-none-eabi-${NUTTX_GCC_VERSION}-linux.tar.bz2 -C /opt/;

		# add arm-none-eabi-gcc to user's PATH
		exportline="export PATH=/opt/gcc-arm-none-eabi-${NUTTX_GCC_VERSION}/bin:\$PATH"

		if grep -Fxq "$exportline" $HOME/.profile;
		then
			echo "${NUTTX_GCC_VERSION} path already set.";
		else
			echo $exportline >> $HOME/.profile;
		fi
	fi

fi

