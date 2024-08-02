# SPDX-License-Identifier: GPL-2.0
FROM ubuntu:24.04

LABEL name=mptcp-upstream-virtme-docker

# dependencies for the script
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive \
	apt-get dist-upgrade -y && \
	DEBIAN_FRONTEND=noninteractive \
	apt-get install -y --no-install-recommends \
		build-essential libncurses5-dev gcc libssl-dev bc bison byacc automake \
		libelf-dev flex git curl tar hashalot qemu-kvm sudo expect \
		python3 python3-pip python3-pkg-resources file virtiofsd \
		busybox-static coreutils python3-requests libvirt-clients udev \
		iputils-ping ethtool klibc-utils kbd rsync ccache netcat-openbsd \
		ca-certificates gnupg2 net-tools kmod \
		libdbus-1-dev libnl-genl-3-dev libibverbs-dev \
		tcpdump \
		pkg-config libmnl-dev \
		clang clangd clang-tidy lld llvm llvm-dev libcap-dev \
		gdb gdb-multiarch crash dwarves strace trace-cmd \
		iptables ebtables nftables vim psmisc bash-completion less jq \
		gettext-base libevent-dev libtraceevent-dev libnewt0.52 libslang2 libutempter0 python3-newt tmux \
		libdwarf-dev libbfd-dev libnuma-dev libzstd-dev libunwind-dev libdw-dev libslang2-dev python3-dev python3-setuptools binutils-dev libiberty-dev libbabeltrace-dev systemtap-sdt-dev libperl-dev python3-docutils \
		libtap-formatter-junit-perl \
		zstd \
		wget xz-utils lftp cpio u-boot-tools \
		cscope \
		bpftrace \
		&& \
	apt-get clean

COPY extra_packages /
RUN bash /extra_packages

# CCache for quicker builds with default colours
# Note: use 'ccache -M xG' to increase max size, default is 5GB
ENV PATH /usr/lib/ccache:${PATH}
ENV CCACHE_COMPRESS true
ENV KBUILD_BUILD_TIMESTAMP "0"
ENV GCC_COLORS error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01

COPY entrypoint.sh tap2json.py /

ENTRYPOINT ["/entrypoint.sh"]
