# CAPDeidentification with XNAT Pipeline

This subfolder contains two XML files needed to run CAP de-identification protocol as XNAT pipeline. You need to familiar yourself with [XNAT Server](http://www.xnat.org) and [XNAT Pipeline Engine](https://wiki.xnat.org/display/XNAT16/Pipeline+Engine).

The files are:
1. **CAPDeidentifier.XML**: This is a XNAT's resource XML file, which will call the `CAPDeidentifier.sh` script.
2. **CAPDeidentificationXNATPipeline.xml**: This is the XNAT pipeline to run the deidentification protocol on an imaging session.

## Pipeline installation

* Assume you have installed an XNAT server properly and you are an admin user.
* Copy the whole CAPDeidentification folder to the XNAT server, e.g. `/opt/CAPDeidentification/`.
* Change the owner and permission for all files and directories under CAPDeidentification with the owner that runs XNAT (*it is usually a tomcat user*).
* Edit the pipeline  **CAPDeidentificationXNATPipeline.xml** file:
  * Modify the location element

    ```xml
    <location>/opt/xnat/tools/pipelines</location>
    ```

    to the absolute location of this file in the server.

  * Locate step element with `id=CAPDidentification` and modify the location attribute

    ```xml
    <resource name="CAPDeidentifier" location="/opt/xnat/tools/resources">
    ```

    to the absolute location of `CAPDeidentifier.sh` file.
* Login to XNAT as admin.
* Follow XNAT's [installing new pipeline procedure](https://wiki.xnat.org/display/XNAT16/Installing+Pipelines+in+XNAT).

  > Write the correct absolute path to the **CAPDeidentificationXNATPipeline.xml** file.

* Add pipeline and attach it to a project.

## Triggering the pipeline

The pipeline can be triggered on an MR session, either automatically when a new MR session is uploaded or by using an action menu. See [how to create a pipeline menu item](http://avansp.github.io/notes/understanding-XNAT-pipeline/).
