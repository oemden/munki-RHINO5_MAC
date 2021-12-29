#!/bin/bash
#
# oem at oemden dot com © 2106
#
## ======== Create Rhino5 Zoo License File for easy Deployment =========
#
# Deploy Rhinoceros5 with your favorite tool (munki for example)
#
# FIRST : Launch Rhino5 on one Mac
# to get the Correct ProductID and PluginId from your Zoo Licence Server
#
# SECOND :
# Then enter
# - the correct ProductID and PluginId below
# - the Zoo Server FQDN
# and run this script as a nopkg or a postinstall in a payload free package
#
# TODO : make a script to create the pkg with pkgbuild.
## =====================================================================

# MàJ zoo serveur sur Zoo

## ================ EDIT BELOW : =================
# launch FIRST Rhino on one Mac to get the Correct ProductID and PluginId
# and enter them below.
ProductID="781b000c-8d0b-4ed3-8ead-213bdb848f39"
PluginId="51e3409b-68e9-4535-bd6e-a8e85509f07f"
ZooServer="zoo.int.example.com"
## ===============================================

## ============ DON'T EDIT BELOW : ===============
TargetDir="/Library/Application Support/McNeel/Rhinoceros/License Manager"
LicenceId=$(uuidgen | tr '[:upper:]' '[:lower:]')
LicenseFile="${TargetDir}/Licenses/${ProductID}.lic"
ZooSettingsFile="${TargetDir}/LicensesZooClient.settings"
HostName=`scutil --get HostName`

## ========== PREREQ =============
function sudo_check {
	if [ `id -u` -ne 0 ] ; then
		printf "must be run as sudo, exiting"
		echo
		exit 1
	fi
}

function create_dir {
	# Warning will delete existing directory if any
	if [[ -d "${TargetDir}" ]] ; then
		rm -Rf "${TargetDir}"
	fi
	if [[ ! -d "${TargetDir}" ]] ; then
		mkdir -p "${TargetDir}"
		mkdir -p "${TargetDir}/Licenses"
#		chmod -R 775 "${TargetDir}/Licenses"
	fi
}

function create_LicenseId_file {
echo "<ZooLicense xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://schemas.datacontract.org/2004/07/ZooCommon\"><Data><Capabilities>NoCapabilities</Capabilities><DateAdded i:nil=\"true\" /><DateToExpire i:nil=\"true\" /><LicenseCount>1</LicenseCount><LicenseTitle></LicenseTitle><ProductLicense></ProductLicense><RegisteredOrganization></RegisteredOrganization><RegisteredOwner></RegisteredOwner><SerialNumber></SerialNumber><TextMask i:nil=\"true\" /></Data><Header><BuildType>Unspecified</BuildType><LicenseId>${LicenceId}</LicenseId><LicenseInstance>0</LicenseInstance><PluginId>${PluginId}</PluginId><ProductId>${ProductID}</ProductId></Header><NodeType>Network</NodeType><Owner>${HostName}</Owner><Status><DateAssigned i:nil=\"true\" /><DateToExpireCheckOut i:nil=\"true\" /><DateUpdated i:nil=\"true\" /><Sessions xmlns:d3p1=\"http://schemas.microsoft.com/2003/10/Serialization/Arrays\" /><StateType>Available</StateType><User><HostName></HostName><ProcessId>0</ProcessId><UserName></UserName></User></Status></ZooLicense>" #> "${LicenseFile}"
}

function write_LicensesZooClient_settings {
echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<!--Zoo client settings file writen by Rhino-->
<ZooClient>
  <Software_McNeel_Rhinoceros_5.0_License_Manager Server=\"${ZooServer}\" />
</ZooClient>
"
}

function do_it {
	sudo_check
	create_dir
	create_LicenseId_file > "${LicenseFile}"
	write_LicensesZooClient_settings > "${ZooSettingsFile}"
}

do_it

exit 0

#### dev
function echo_stuff {
echo ------
echo "ProductID $ProductID"
echo "LicenseFile: $LicenseFile"
echo "LicenceId: $LicenceId"
echo "ZooServer: $ZooServer"
echo "ZooSettingsFile: $ZooSettingsFile"
echo ------
create_LicenseId_file > "${LicenseFile}"
echo ------
write_LicensesZooClient_settings > "${ZooSettingsFile}"
echo ------
}

