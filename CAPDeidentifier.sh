#!/bin/bash

# Inputs: [src_dir] [target_dir] [new_id]
src_dir=$1
target_dir=$2
new_id=$3
jar_dir=$4

java -Xmx800m -jar $jar_dir/CapDicomDeidentifications.jar -input $src_dir -target anonymize metadata -args $target_dir/$new_id $new_id CAP $new_id -recursive
