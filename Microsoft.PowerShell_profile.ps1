function GoInsallHerokuLocal () {
    Clear-Host
    go install
    heroku local
    
}

function Git-All {
    Get-ChildItem -Recurse -Depth 2 -Force | 
        Where-Object { $_.Mode -match "h" -and $_.FullName -like "*\.git" } |
        ForEach-Object {
        cd $_.FullName
        cd ../
        git pull
        cd ../
    }
}

function Close-PWS {
    stop-process -Id $PID
}

function Prompt {
    $host.UI.RawUI.WindowTitle = $pwd
    "PS: > "
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

Function GitAddCommitPush($comment) {
    git add -A;
    git commit -m "$comment";
    git push
}

function Save-HerokuKeys($file) {
    $envVars = Import-Csv "$file"
    foreach ($item in $envVars) {
        $command = $($item.Key + "=" + $item.Value)
        heroku config:set $command
    }
    heroku config
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
Set-Alias cps Close-PWS
Set-Alias ss SynapticsRestart
Set-Alias shk Save-HerokuKeys
Set-Alias hls GoInsallHerokuLocal
Set-Alias gita Git-All
