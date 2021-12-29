# Create Rhino5 Zoo License File for easy Deployment


1. Deploy **Rhinoceros5** with your favorite tool (munki for example)

2. Launch **Rhino5** on one Mac

	To retrieve the Correct **ProductID** and **PluginId** from your Zoo Licence Server.
	
	Look  at here: `/Library/Application Support/McNeel/Rhinoceros/License Manager`

3. Then enter in the `Generate-Rhino5-ZooLicenseClientFile.sh` script:
	- the correct **ProductID** and **PluginId**
	- the **Zoo Server FQDN**

4. Use the script `Generate-Rhino5-ZooLicenseClientFile.sh`

	You can run the script as a **.nopkg** or a **postinstall_script** in a payload free package

5. **BONUS**: 

	A script `Create-Rhino5-ZooLicenseClientFile-pkg.sh` to create the .pkg with `pkgbuild`.
