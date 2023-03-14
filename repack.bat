@echo off
rem Authored by danke.
rem Repack CB archives with baseline JPEG decompression.

where /q 7z
if ERRORLEVEL 1 (
    echo "7z" missing from System PATH.
    echo https://www.7-zip.org/
    pause
    exit /B
)

where /q pingo
if ERRORLEVEL 1 (
    echo "pingo" missing from System PATH.
    echo https://css-ig.net/pingo
    pause
    exit /B
)

where /q pingo_b63
if ERRORLEVEL 1 (
    echo "pingo_b63" missing from System PATH.
    echo https://sourceforge.net/projects/nikkhokkho/files/FileOptimizer/14.10.2534/
    pause
    exit /B
)

pushd %~dp1
set ORIGINAL=%~nx1
set REPACK=%ORIGINAL:-Empire=%
set REPACK=%REPACK:.cb7=.cbz%
set REPACK=%REPACK:.cba=.cbz%
set REPACK=%REPACK:.cbr=.cbz%
set REPACK=%REPACK:.cbt=.cbz%
set REPACK=%REPACK:).cbz=-Repack).zip%
set TMPDIR=%TEMP%\MangaToolsnke
if %~x1 EQU .cbz (
  copy "%ORIGINAL%" "%REPACK%"
  7z d "%REPACK%" * -r
)
rd /S /Q %TMPDIR%
7z e -o"%TMPDIR%" "%ORIGINAL%"
echo "%TMPDIR%"
pingo_b63 -uncompress -strip=0 "%TMPDIR%\*.jpg"
pingo -jpgtype=0 -sb -nostrip "%TMPDIR%\*.jpg"
7z a -mx=0 -mtc=off "%REPACK%" "%TMPDIR%\*.*"
move "%REPACK%" "%REPACK:.zip=.cbz%"
rd /S /Q %TMPDIR%
popd
rem pause
