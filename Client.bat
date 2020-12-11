dir /s /b *.nut >> data.dat

copy data.dat compile.dat
fart -q "compile.dat" ".nut" ".cnut"

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

for /l %%x in (1, 1, %n%) do (
	sq -c -o !array2[%%x]! !array[%%x]!
)

del compile.dat
del data.dat