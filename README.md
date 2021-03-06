# Script Compiling Tool
- Compile .nut files in one click.
- Compilers provided for both server and client scripts.
- Retains directory structure.
- Displays all compile-time errors at once.

&nbsp;
# How to use

## Server Side
Just throw all your files inside the **server side** folder and run **Compiler.bat**.

![ServerSide](https://i.imgur.com/6LXsAGw.gif)

&nbsp;

## Client Side
Just throw all your files inside the **client side** folder and run **Client.bat**.

![ClientSide](https://i.imgur.com/AdU3p2d.gif)

However, there is no error handling on client side.

## Notes

- Only .nut files are taken into account, so you can even place entire server folder at once as long as you don't replace server.cfg.
- Previous files are deleted whenever compilation begins.
- Default extension for compiled file is `.cnut`, to change it, replace it in extension.ini.
- Do not put spaces in your client script names.
- [fart-it](https://github.com/lionello/fart-it) was used in the batchfiles 

Download the tool from [here](https://github.com/vancityspiller/.nut-Compile-Tool/releases/tag/v1.1).
