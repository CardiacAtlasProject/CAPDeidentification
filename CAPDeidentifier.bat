echo off

SET src_dir=%1
SET target_dir=%2
SET new_id=%3
SEt jar_dir=%4

java -Xmx800m -jar %jar_dir%/CapDicomDeidentifications.jar -input %src_dir% -target anonymize metadata -args %target_dir%/%new_id% %new_id% CAP %new_id% -recursive
