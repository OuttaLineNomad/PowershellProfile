
function Close-PWS {
    stop-process -Id $PID
}

function chaneDirectoryTitle($dir) {
    Set-Location $dir
    $Name = $((get-item $pwd).Name)
    titleChange $Name
}

function  SynapticsRestart {
    Stop-Process -processname SynTPEnh
    Start-Process "C:\Program Files\Synaptics\SynTP\SynTPEnh.exe"
}

function sps {
    Start-Process powershell
}

function Out-FileUTF8NoBOM($file) {
    Begin {}
    Process {
        [IO.File]::WriteAllLines($file, $_)
    }
    End {}
}

function titleChange($Name) {
    $host.ui.RawUI.WindowTitle = $name
}

# Here is a cool text editor on powershell made by MrMiguu on GitHub
# https://github.com/mrmiguu/Here
Function Here($emptyBodyOrFile, $emptyFileOrBody, $newFile) {
    $PSDefaultParameterValues["*:Encoding"] = "utf8"

    if ($emptyBodyOrFile -eq $null) {
        Set-Clipboard $null
        [System.Windows.Forms.SendKeys]::SendWait('here @"')
    }
    elseif (Test-Path ($emptyBodyOrFile -replace "`r`n|`n", $null)) {
        if ($emptyFileOrBody -eq $null) {
            Get-Content $emptyBodyOrFile | Set-Clipboard
            [System.Windows.Forms.SendKeys]::SendWait('here $emptyBodyOrFile @"')
        }
        else {
            if ($newFile -eq $null) {
                Write-Output $emptyFileOrBody
                return
            }
            else {
                $emptyFileOrBody | Out-FileUtf8NoBom $newFile
                return
            }
        }
    }
    else {
        if ($emptyFileOrBody -eq $null) {
            Write-Output $emptyBodyOrFile
            return
        }
        else {
            $emptyBodyOrFile | Out-FileUtf8NoBom $emptyFileOrBody
            return
        }
    }

    [System.Windows.Forms.SendKeys]::SendWait("~")
    [System.Windows.Forms.SendKeys]::SendWait("^{v}")
}

Function GitAddCommitPush {
    param (
        [Parameter(Position = 0, ParameterSetName = "GIT")]
        [string]$comment, 
        [Parameter( ParameterSetName = "GIT")]
        [switch]$g,

        [Parameter(Position = 0, ParameterSetName = "GITNew")]
        [string]$comment4,
        [Parameter( ParameterSetName = "GITNew")]
        [switch]$gn,
        [Parameter( ParameterSetName = "GITNew")]
        [string]$url,
    
       
        [Parameter(Position = 0, ParameterSetName = "Heroku")]
        [string]$comment2,
        [Parameter( ParameterSetName = "Heroku")]
        [switch]$h,
        
        [Parameter(Position = 0, ParameterSetName = "HerokuLogs")]
        [string]$comment3,
        [Parameter(ParameterSetName = "HerokuLogs")]
        [switch]$hl


    )
  

    switch ($PsCmdlet.ParameterSetName) {
        "GIT" {
            git add -A;
            git commit -m "$comment";
            git push
        }
        "GITNew" {
            git init;
            git add -A;
            git commit -m "$comment4";
            git remote add origin $url;
            git push -u origin master;
        }
        "Heroku" { 
            git add -A;
            git commit -m "$comment2";
            git push heroku master;
        }
        "HerokuLogs" {
            git add -A;
            git commit -m "$comment3";
            git push heroku master;
            heroku logs -t
        }
        
    }


    <#
    .SYNOPSIS
    Helps with committing code to GitHub or Heroku
    
    .DESCRIPTION
    This will execute the git commands to add all changes to your git repository. It also as specific switches for Heroku, to help the commit code directly to Heroku then to look at their logs. 
    
    .PARAMETER comment
    The comment that will show on the git. The reason for committing the code.

    .PARAMETER g
    For committing code directly to github.com.
    
    .PARAMETER h
    For committing code directly to Heroku.
    
    .PARAMETER hl
    For committing code directly to Heroku then showing the logs from the server.
    
    .EXAMPLE
    GitAddCommitPush "This is a test" -hl 
    .NOTES
    The function helps testing and commiting code to Heroku.
    #>
}

# set theme
$PSDefaultParameterValues["*:Encoding"] = 'utf8'
Set-PSReadlineOption -TokenKind String -ForegroundColor Cyan
Set-PSReadlineOption -TokenKind Command -ForegroundColor Magenta
Set-PSReadlineOption -TokenKind Parameter -ForegroundColor Yellow

# set alias
set-alias tc titleChange
set-alias o Out-FileUTF8NoBOM
Set-Alias gap GitAddCommitPush
Set-Alias cdt chaneDirectoryTitle
Set-Alias cps Close-PWS
Set-Alias ss SynapticsRestart