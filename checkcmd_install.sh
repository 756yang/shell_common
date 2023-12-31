#!/bin/bash
# 检查命令是否存在并尝试安装软件包

function has_command () {
	local ans
	IFS='| ' read -a ans <<< "$*"
	for var in "${ans[@]}"; do
		command -v "$var" &>/dev/null && return
		ls "/usr/sbin/$var" &>/dev/null && return
	done
	return 1
}
[ $(id -u) -eq 0 ] && sudocmd="" || sudocmd=sudo
while [ $# -gt 0 ]; do
	if ! has_command "$1"; then
		if { cat /proc/version | grep -E "MINGW|MSYS" &>/dev/null;}; then
			! ls /bin/pkgfile &>/dev/null && pacman -S pkgfile && pkgfile -u
			pkgname=$(pkgfile -r "^/(usr/local/bin|usr/bin|bin)/${1%%|*}.exe\$")
			[ -n "$pkgname" ] && pacman -S ${pkgname##*/} || {
				pkgname=$(pkgfile -r "^/(usr/local/bin|usr/bin|bin)/${1%%|*}\$")
				[ -n "$pkgname" ] && pacman -S ${pkgname##*/}
			}
		elif has_command apt-get; then
			! ls /bin/apt-file &>/dev/null && $sudocmd apt install apt-file && $sudocmd apt-file update
			pkgname=$(apt-file -x search "^/(usr/local/sbin|usr/local/bin|usr/sbin|usr/bin|sbin|bin)/${1%%|*}\$")
			[ -n "$pkgname" ] && $sudocmd apt install ${pkgname%%:*}
		elif has_command pacman; then
			! ls /bin/pkgfile &>/dev/null && $sudocmd pacman -S pkgfile && $sudocmd pkgfile -u
			pkgname=$(pkgfile -r "^/(usr/local/sbin|usr/local/bin|usr/sbin|usr/bin|sbin|bin)/${1%%|*}\$")
			[ -n "$pkgname" ] && $sudocmd pacman -S ${pkgname##*/}
		fi
		[ $? -ne 0 ] && {
			echo "$1 can not to execute!"
			exit 126
		}
	fi
	shift
done
