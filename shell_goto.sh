# eval "$(cat shell_goto.sh)" label
# eval "$(cat shell_goto.sh)" label script
:<<"EOT"
# this is an example, echo boom forever
#boom#
echo boom
eval "$(cat shell_goto.sh)" boom
EOT
function shell_goto ()
{
	[ $# -eq 0 -o $# -gt 2 ] && return 1
	local label="$1"
	[ $# -eq 1 ] && local script="$0" || local script="$2"
	eval "$(sed -n "/^#$label#\$/{:a;n;p;b a};" "$script")"
	exit
}
shell_goto