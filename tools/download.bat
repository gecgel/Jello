@echo off
setlocal enabledelayedexpansion

:: Constants
set "projectDirectory=%~dp0.."
set "downloadDirectory=%projectDirectory%\downloads"

if not exist "%downloadDirectory%" mkdir "%downloadDirectory%" || (
    echo ERROR: Could not create the downloads directory at %downloadDirectory%!
    exit /b 1
)

:: Counters
set failedCount=0
set completedCount=0
set skippedCount=0

:: Git repositories
call :DownloadViaGit "yyjson" "https://github.com/ibireme/yyjson.git" "0.12.0"

:: Report the outcome
if %failedCount% gtr 0 (
    echo ERROR: %failedCount% downloads failed!
    exit /b 1
)

echo INFO: %completedCount% downloads were completed, and %skippedCount% were already up-to-date.
exit /b 0

:: Takes the download name, repository URL, and the argument to specify the
:: commit, which can be a commit hash, branch, or tag.
:DownloadViaGit
set "name=%~1"
set "url=%~2"
set "branch=%~3"

:: Constants
set "repositoryDirectory=%downloadDirectory%\%name%"
set "logFile=%downloadDirectory%\%name%.txt"

:: Find the GIT commit hash that should be downloaded
set desiredHash=
for /f "tokens=1" %%H in ('git ls-remote "%url%" "%branch%^{}" 2^>nul') do set desiredHash=%%H
if not defined desiredHash (
    for /f "tokens=1" %%H in ('git ls-remote "%url%" "%branch%" 2^>nul') do set desiredHash=%%H
)
if not defined desiredHash (
    set /a failedCount+=1
    echo ERROR: Cannot resolve the GIT reference to %branch% from %url% for %name%!
    exit /b 1
)

:: Check whether we can skip this one
if exist "%repositoryDirectory%\.git" (
    set currentHash=
    for /f "tokens=1" %%H in ('git -C "%repositoryDirectory%" rev-parse HEAD 2^>nul') do set currentHash=%%H
    if defined currentHash (
        if !currentHash!==!desiredHash! (
            set /a skippedCount+=1
            echo INFO: GIT repository %name% is already up-to-date with %url%.
            exit /b 0
        )
    )
)

if exist "%repositoryDirectory%" (
    echo INFO: Removing the existing GIT repository at %repositoryDirectory%...
    rmdir /s /q "%repositoryDirectory%" || (
        set /a failedCount+=1
        echo ERROR: Could not remove the GIT repository at %repositoryDirectory% for %name%!
        exit /b 1
    )
)

echo INFO: Cloning the GIT branch %branch% from %url% for %name% to %repositoryDirectory%...
git clone -v --progress --depth 1 --shallow-submodules --recurse-submodules -b "%branch%" -- "%url%" "%repositoryDirectory%" >"%logFile%" 2>&1 || (
    set /a failedCount+=1
    echo ERROR: Cannot clone the GIT branch %branch% from %url% for %name% to %repositoryDirectory%!
    exit /b 1
)

set /a completedCount+=1
echo INFO: Completed cloning the GIT %branch% from %url% for %name% to %repositoryDirectory%.
exit /b 0
