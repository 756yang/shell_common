#!/bin/bash
# 以awk修改conf配置文件
# ./awk_conf.sh var_name var_val
# var_name 在conf文件中行首作为配置名称
# var_val 应该带分隔符，作为配置项的值
# 例如: cat /etc/sysctl.conf | ./awk_conf.sh net.ipv4.ip_forward "=1"

awk_script=$'{\n\tif(0);\n'
end_script=$'END{\n'
while [ $# -gt 0 ]; do
	var_name="$1"
	var_id="var$#"
	#var_val="${2:1}"
	var_ifs="${2:0:1}"
	awk_script="$awk_script"$'\telse if(match($0,"^'"$var_name$var_ifs"$'")){\n'
	awk_script="$awk_script"$'\t\t'"$var_id"$'="'"$1$2"$'";\n'
	awk_script="$awk_script"$'\t\tprint '"$var_id"$';\n\t}\n'
	end_script="$end_script"$'\tif(!length('"$var_id"$'))print "'"$1$2"$'";\n'
	shift 2
done
awk_script="$awk_script"$'\telse print $0;\n}'
end_script="$end_script"$'}'

awk "$awk_script"' '"$end_script"
