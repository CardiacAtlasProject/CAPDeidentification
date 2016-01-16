#!/bin/bash

# Inputs: [src_dir] [target_dir] [new_id]

java -Xmx800m -jar /opt/xnat/tools/bin/CAPDeidentification/CapDicomDeidentifications.jar -input /opt/xnat/data/archive/MainUpload/arch001/PAT0001_MR1 -target anonymize metadata -args /tmp/PAT0001_MR1 PAT0001_MR1 CAP PAT0001_MR1 -recursive
