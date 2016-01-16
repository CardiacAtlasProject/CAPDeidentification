# CAPDeidentification
De-Identification protocol of Private Health Information (PHI) used by the Cardiac Atlas Project. The CAP's de-identification tool requires command line java program.

## Running the tool

```console
$ java -Xmx800m -jar CapDicomDeidentifications.jar -input [original_study] -target anonymize metadata
-args [output_study_folder] [log_file] CAP [new_patientID]
```

The optional argument -Xmx800m determines the minimum memory size to run this tool.

Input arguments:

- [original_study] points to an image folder of the original DICOM files.
- [output_study_folder] points to a non-existed folder to put the newly generated
  anonymized DICOM images.
- [log_file] is a log filename
- [new_patientID] is string identifier for a new anonymized patient ID

> Use recursive argument to browse inside the input folder recursively

Example:

```console
$ java -Xmx800m -jar CapDicomDeidentifications.jar -input /Users/mine/PAT0201/images -target anonymize metadata
-args /Users/mine/anon/ID001 ID001 CAP ID001 -recursive
```

This will generate anonymized PAT0201 study into a new study with identifier = ID001.

A bash script is available for more easier call
```text
CAPDeidentifier.sh [src_dir] [target_dir] [new_id]
```

E.g.
```console
$ CAPDeidentifier.sh /Users/mine/PAT0201/images /Users/mine/anon/ ID001
```
