# CAPDeidentification with XNAT Pipeline

This subfolder contains two XML files needed to run CAP de-identification protocol as XNAT pipeline. You need to familiar yourself with [XNAT Server](http://www.xnat.org) and [XNAT Pipeline Engine](https://wiki.xnat.org/display/XNAT16/Pipeline+Engine).

The files are:

1. **CAPDeidentifier.xml**

   This is a XNAT's resource XML file, which will call the `../CAPDeidentifier.sh` script.

2. **DeidentifyMRSession.xml**

   This is the XNAT pipeline to run the deidentification protocol on an imaging session.

## Pre-requisites

* XNAT 1.6.5 [[download](http://xnat.org/)]
* Command line `curl` [[download](http://curl.haxx.se/)]

## Deidentification process

The pipeline consists of several steps. It can be set triggered by an action menu or automatically. The pipeline can only be applied on an MRSession data.

The steps are defined in the **DeidentifyMRSession.xml** under `steps` element:

1. **INIT_SETUP**

  This step will remove existing output directory. The CAPDeidentification script will raise error if output directory already exists.

2. **IDENTIFY**

  This is the main de-identification process. The pipeline will call a resource XML file with arguments of source directory, target directory and new PatientID to generate. The resource will eventually call a java program with this command:

  ```bash
  java -Xmx800m -jar $jar_dir/CapDicomDeidentifications.jar -input $src_dir -target anonymize metadata -args $target_dir/$new_id $new_id CAP $new_id -recursive
  ```

3. **ZIP_DATA**

  This step zips the de-identified output directory into a ZIP file for re-uploading. The output directory will be deleted after ZIP.

5. **UPLOAD_ZIP**

  This step will re-upload the de-identified data into XNAT by using a `targetProject` and `newPatientID` parameters (see Parameters below). The ZIP file will be deleted after upload.

## Parameters in **DeidentifyMRSession.xml**

### Input parameters
*Values of these parameters can be modified by using a user interface when the pipeline is triggered manually. However, if the pipeline is triggered automatically, then the default values are used. You need to modify it directly on the XML source file.*

| Name | Default value | Description | Action |
| ---- | ------------- | ---- | ------ |
| imageSessionID | xnat:imageSessionData/ID | Current image session ID to apply the pipeline. | **DO NOT MODIFY** |
| imageSessionLabel | xnat:imageSessionData/label | Current image session label, usually `SubjectName_SessionName`. | **DO NOT MODIFY** |
| newPatientID | xnat:imageSessionData/dcmPatientI | New PatientID to be generated. | Change it according to your naming protocol. |
| targetProject | Shared | The target project to upload de-identified data. | Replace it with the project name on your XNAT server to receive de-identified cases. |
| tmpDir | /var/tmp/ | Temporary directory. | Specify a temporary folder to generate the output of CAPDeidentification process. |

### Internal parameters

*Some of these parameters need to be adjusted according to your filesystem. Note that `CAP_DEIDENTIFY_FOLDER` refers to the specific folder during installation (see the modification of XML files below).*

| Name | Value | Description | Modify to |
| ---- | ----- | ----------- | ------ |
| tooldir | /opt/xnat/tools/CAPDeidentification/ | The location where the CAPDeidentification tool is installed. | `CAP_DEIDENTIFY_FOLDER` |
| logdir | /opt/xnat/tools/logs | Location of log, output and error files. | A temporary log files, such as `/var/logs`. |
| resolvedHost | *computed* | URI of the XNAT server. | **DO NOT MODIFY** |
| archiveRootPath | *computed* | Path to the archive folder in the local filesystem. | **DO NOT MODIFY** |
| archiveSessionPath | *computed* | Path to the image session data in the local filesystem. | **DO NOT MODIFY** |
| resolvedNewPatientID | *computed* | Some checks if the input newPatientID parameter is empty. | **DO NOT MODIFY** |

## Setting up XNAT projects

This pipeline needs two projects. One is for upload new studies, that can be identified. The other project is to store the de-identified studies. Depending on the setup, you can install this pipeline to be triggered automatically upon new data upload or manually by using a menu.

* Login to your XNAT server as **admin**.
* Create the first project to upload, say `Upload`. Set it as private that only **admin** or a designated user are allowed to upload new data.
* Create the second project for sharing, say `Shared`. You can set it as protected or public, and add the designated upload user as a Member. Note that admin is by default allow to do anything.
* Go to `Administer -> Data Types` menu.
* Click `xnat:mrSessionData` element.
* Click `Edit` action menu.
* In the Available Report Actions section, add new report with the following values:

  * Name = `PipelineScreen_launch_pipeline`
  * Display Name = `Pipeline`
  * Image = `wrench.gif`
  * Popup = `always`
  * Sequence = `18`

  Click `submit`.

  This will create a new menu item `Pipeline` in the MRSession level.

## Modifying the XML files

* [Download the CAPDeidentification ZIP file](https://github.com/CardiacAtlasProject/CAPDeidentification/archive/master.zip).
* Unzip it to a directory on the XNAT server (let's called it `CAP_DEIDENTIFY_FOLDER`).
* Open **CAPDeidentifier.xml** and modify the statement

  ```xml
  <location>/opt/xnat/tools/CAPDeidentification</location>
  ```

  with `CAP_DEIDENTIFY_FOLDER`.

* Open **DeidentifyMRSession.xml**.

  You need to modify several places:

  * Find `location` element at the top:

    ```xml
    <location>/opt/xnat/tools/CAPDeidentification/XNAT_Pipeline</location>
    ```

    and change it into `CAP_DEIDENTIFY_FOLDER/XNAT_Pipeline`.

  * Find `targetProject` parameter under `input-parameters` element. If in the previous section you created the second project not as `Shared`, then you you need to replace it. Note that user can change this value if the pipeline is triggered manually.

  * Locate a `step` element with `id=IDENTIFY`. This is the main step to call the `../CAPDeidentifier.sh` script. So you need to modify the location attribute of `CAPDeidentifier` resource to `CAP_DEIDENTIFY_FOLDER/XNAT_Pipeline`.

  * Find `tooldir` parameter, replace it with `CAP_DEIDENTIFY_FOLDER`.

## Pipeline installation on XNAT

* Change the owner and permission for all files under `CAP_DEIDENTIFY_FOLDER` as the same user that runs XNAT (*it is usually a `tomcat` user*). You may need to have root or admin access to do this.

* Login to XNAT as admin.

* Go to `Administer -> Pipelines`.

* Click `Add Pipeline to Repository` link and enter `CAP_DEIDENTIFY_FOLDER/XNAT_Pipeline` value. Leave the second field empty.

* Go to project `Upload`.

* Click `Pipelines` tab and add the new `DeidentifyMRSession` pipeline to the project. You can set whether to trigger it automatically or not.

## Troubleshooting
