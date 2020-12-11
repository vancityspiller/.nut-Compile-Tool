del data.dat
rmdir /Q /S Compiled

cd >> data.dat
dir /s /b *.nut >> data.dat
fart -q -C "data.dat" \\ \/

robocopy .\ Compiled /e /xf * >nul
rmdir /Q /S "Compiled/Compiled"
rmdir /Q /S "Compiled/plugins"

start server64.exe