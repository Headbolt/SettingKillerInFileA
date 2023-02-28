#!/bin/bash
#
###############################################################################################################################################
#
# ABOUT THIS PROGRAM
#
#	SettingKillerInFileA.sh
#	https://github.com/Headbolt/SettingKillerInFileA
#
#   This Script is designed for use in JAMF and was designed to force remove settings of a certain format from a file
#	This was done to comply with "CIS Apple macOS 13.0 Ventura Benchmark 1.0.0" Security Reccomendations
#
###############################################################################################################################################
#
# HISTORY
#
#   Version: 1.0 - 28/02/2023
#
#	28/02/2023 - V1.0 - Created by Headbolt
#
###############################################################################################################################################
#
#   DEFINE VARIABLES & READ IN PARAMETERS
#
###############################################################################################################################################
#
File="$4" # Grab the path to the file from JAMF variable #4 eg /etc/asl/com.apple.install
String="$5" # Grab the relevant setting to remove from JAMF variable #5 eg all_max=
#
Output="" # Ensure the Output Variable starts blank
ScriptName="MacOS | Remove Setting from Settings File A" # Set the name of the script for later logging
ExitCode=0 # Ensure the ExitCode Variable starts as 0
#
###############################################################################################################################################
#
#   Checking and Setting Variables Complete
#
###############################################################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
###############################################################################################################################################
#
# Defining Functions
#
###############################################################################################################################################
#
# Section End Function
#
SectionEnd(){
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
/bin/echo  ----------------------------------------------- # Outputting a Dotted Line for Reporting Purposes
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
}
#
###############################################################################################################################################
#
# Script End Function
#
ScriptEnd(){
#
/bin/echo Ending Script '"'$ScriptName'"'
/bin/echo # Outputting a Blank Line for Reporting Purposes
/bin/echo  ----------------------------------------------- # Outputting a Dotted Line for Reporting Purposes
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
exit $ExitCode
#
}
#
###############################################################################################################################################
#
# End Of Function Definition
#
###############################################################################################################################################
# 
# Begin Processing
#
###############################################################################################################################################
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
SectionEnd
#
while IFS= read -r line # Read in the File
	do
		LineCheck=$(echo $line | /usr/bin/grep -i "$String")
		if [[ $LineCheck == "" ]]
			then
				if [[ $Output == "" ]]
                	then
						Output="${line}"
					else
						Output="${Output}\n${line}"
				fi
		fi
		if [[ $LineCheck != "" ]]
			then
				Line=$(/usr/bin/grep -i "$String" $File)
				NewLine=""
				for i in {1..15}
					do
						Tester=$(/bin/echo '/bin/echo "$Line" | awk '\'{ print '$'$i' }'\''')
						Check=$( eval $Tester )
						if [[ $Check != $String* ]]
							then
								if [[ $i == "1" ]]
									then
										NewLine=$(/bin/echo "${Check}")
								fi
								if [[ $i != "1" ]]
									then
										NewLine=$(/bin/echo "${NewLine}" "${Check}")
								fi
						fi
				done
				Output="${Output}\n${NewLine}"
		fi
done < $File
echo -e "${Output}" > $File
#
ScriptEnd
