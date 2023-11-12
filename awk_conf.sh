#!/bin/bash
# 以awk修改conf配置文件

awk_script=$'{\n\tif(0);\n'
end_script=$'END{\n'
while [ $# -gt 0 ]; do
	var_name="${1%%[^_A-Za-z0-9]*}"
	awk_script="$awk_script"$'\telse if(match($0,"^[^#]*'"$var_name"$'[^_A-Za-z0-9]")){\n'
	awk_script="$awk_script"$'\t\t'"$var_name"$'="'"$1"$'";\n'
	awk_script="$awk_script"$'\t\tprint '"$var_name"$';\n\t}\n'
	end_script="$end_script"$'\tif(!length('"$var_name"$'))print "'"$1"$'";\n'
	shift
done
awk_script="$awk_script"$'\telse print $0;\n}'
end_script="$end_script"$'}'

awk "$awk_script"' '"$end_script"
