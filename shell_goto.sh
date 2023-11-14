# eval "$(cat shell_goto.sh)" label
# eval "$(cat shell_goto.sh)" '"label:script"'
:<<"EOT"
# this is an example, echo boom forever
#boom#
echo boom
eval "$(cat shell_goto.sh)" boom
EOT
{
	IFS='' read -r shell_goto_jump
	shell_goto_label="${shell_goto_jump%%:*}"
	if [ "$shell_goto_label" = "$shell_goto_jump" ]; then
		shell_goto_script="$0"
	else
		shell_goto_script="${shell_goto_jump#*:}"
	fi
	eval "$(sed -n "/^#$shell_goto_label#\$/{:a;n;p;b a};" "$shell_goto_script")"
	exit
} <<<