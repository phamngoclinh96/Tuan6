ml.exe /coff /c %1.asm
rc %1.rc
link.exe /SUBSYSTEM:WINDOWS /LIBPATH:c:\masm32\lib %1.obj %1.res