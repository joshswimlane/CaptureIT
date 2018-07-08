﻿<#
.SYNOPSIS
    Start creating your gif
.DESCRIPTION
    Start capturing screenshots of either the active window or your full screen and generate a gif
.PARAMETER Screen
    Screenshot of the entire screen 
.PARAMTER ActiveWindow
    Screenshot of the active window 
.PARAMETER Milliseconds
    Milliseconds between screenshot
.PARAMTER FilePath
    Name and location to save the generated gif
.EXAMPLE
    Start-Capture -Screen -FilePath "c:\users\msadministrator\Desktop\mynewgif.gif"
.NOTES
    Name: Start-Capture 
    Author: Josh Rickard (MSAdministrator) 
    DateCreated: 07/07/2018
#>
function Start-Capture {
    [CmdletBinding(DefaultParameterSetName = 'Parameter Set 1',
        PositionalBinding = $false,
        HelpUri = '',
        ConfirmImpact = 'Medium')]
    Param (
        # Screenshot of the entire screen 
        [Parameter(
            Mandatory = $False,
            ParameterSetName = "screen",
            ValueFromPipelineByPropertyName = $True)]
        [switch]$Screen,

        # Screenshot of the active window 
        [Parameter(
            Mandatory = $False,
            ParameterSetName = "window",
            ValueFromPipelineByPropertyName = $False)]
        [switch]$ActiveWindow,
   
        # Milliseconds between screenshot
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true)]
        [int]$Milliseconds = '1000',

        # Name and location to save the generated gif
        [Parameter(
            Mandatory = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateScript( {
                if ($_ -notmatch "(\.gif)") {
                    throw "The file specified in the path argument must be type of gif"
                }
                return $True
            } )
        ]
        [string]$FilePath
    )
    
    $Global:GifFilePath = $FilePath

    if ($Screen) {
        try {
            Write-Verbose -Message 'Calling Start-FullScreenCapture'
            Start-FullScreenCapture -Milliseconds $Milliseconds
        }
        catch {
            Write-Error -Exception $Error[0]
            exit -1
        }

        try {
            Write-Verbose -Message 'Attempting to generate gif'

            ConvertTo-Gif -FilePath $Global:GifFilePath
            
        }
        catch {
            Write-Error -ErrorRecord $Error[0]
        }
    }
    elseif ($ActiveWindow) {
        try {
            Write-Verbose -Message 'Calling Start-ActiveWindowCapture'
            Start-ActiveWindowCapture -Milliseconds $Milliseconds
        }
        catch {
            Write-Error -Exception $Error[0]
            exit -1
        }

        try {
            Write-Verbose -Message 'Attempting to generate gif'

            ConvertTo-Gif -FilePath $Global:GifFilePath
        }
        catch {
            Write-Error -ErrorRecord $Error[0]
        }
    }
    else {
        Write-Warning -Message 'Please add a switch to indicate if you want to capture the Full Screen or Active Window'
    }
}