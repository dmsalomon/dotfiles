#!/bin/bash
date >> /tmp/date.txt
pwd >> /tmp/pwd.txt
root_dir="$(git rev-parse --show-toplevel 2>/dev/null)" || exit
{
	bazel query 'kind("generated file", deps(.))' |
		grep '^@maven.*\.jar$' |
		sed -e "s|@maven//:|$root_dir/bazel-bin/external/maven/|"
	bazel query 'kind(kt_jvm_library, deps(.))' |
		sed -e "s|^//|$root_dir/bazel-bin/|" -e 's|:|/|' |
		awk '{printf "%s.jar\n%s-sources.jar\n",$0,$0}'
} | paste -sd: - | tee -a /tmp/jars.txt
