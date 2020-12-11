rmdir /Q /S Compiled
dir /s /b *.nut >> data.dat

set /p Ext=<extension.ini

copy data.dat compile.dat
fart -q "compile.dat" ".nut" %Ext%

fart --remove "data.dat" "%cd%\\"
fart -c --remove "compile.dat" "%cd%\\"

setlocal EnableDelayedExpansion

set i=0
for /F %%a in (data.dat) do (
   set /A i+=1
   set array[!i!]=%%a
)
set n=%i%

set j=0
for /F %%b in (compile.dat) do (
   set /A j+=1
   set array2[!j!]=%%b
)
set m=%j%

robocopy .\ Compiled /e /xf * >nul
rmdir /Q /S "Compiled/Compiled"

for /l %%x in (1, 1, %n%) do (
	sq -c -o Compiled\!array2[%%x]! !array[%%x]!
)

del compile.dat
del data.dat