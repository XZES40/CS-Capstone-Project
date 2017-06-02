@ECHO OFF

::
:: Get rid of studio components that are inherited between .NET build invocations
::

:: erase "%USERPROFILE%\Local Settings\Application Data\Microsoft\VisualStudio\7.1\VCComponents.dat"
:: erase "%USERPROFILE%\Local Settings\Application Data\Microsoft\VisualStudio\7.1\toolbox*.tbd

::
:: Establish clean working environment variables
::

SET PATH=%WINDIR%\system32;%WINDIR%;%WINDIR%\Wbem
SET INCLUDE=
SET LIB=
SET LIBPATH=
SET SOURCE=

:: Common source directory for xalan-src and xerces-src directories

SET XROOTDIR=C:\lems2k-3.4.1\Apache

::
:: The LIBPATH and SOURCE environment variables are not set by the "vcvars32.bat"
:: When launching "devenv.exe" /useenv, the values become empty. Therefore we
:: should redefine them here for default .NET IDE consistency.
::

SET LIBPATH=$(FrameWorkDir)$(FrameWorkVersion)
SET SOURCE=$(VCInstallDir)atlmfc\src\mfc;$(VCInstallDir)atlmfc\src\atl;$(VCInstallDir)crt\src

::
:: Apply the C++ project path definitions from the Visual C++ compiler installation
:: This is similar to an expansion of the Visual Studio .NET defaults definitions.
::

call "%VS71COMNTOOLS%\..\..\VC7\bin\vcvars32.bat"
:: call "C:\Program Files\Microsoft Visual Studio 8\VC\bin\vcvars32.bat"
:: call "%VS90COMNTOOLS%vsvars32.bat"

::
:: Now to setup the product specific build environment
::

:: SET XERCESCROOT=%XROOTDIR%\xerces-src
:: SET XALANCROOT=%XROOTDIR%\xalan-src\c

SET XERCESCPKGDIR=%XROOTDIR%\XERCESCPKG
SET XALANCPKGDIR=%XROOTDIR%\XALANCPKG

SET XERCESCROOT=%XERCESCPKGDIR%\include
SET XALANCROOT=%XALANCPKGDIR%\include

SET INCLUDE=%INCLUDE%;%XERCESCROOT%
SET INCLUDE=%INCLUDE%;%XALANCROOT%;%XALANCPKGDIR%\include\Nls\Include

SET PATH=%PATH%;%XERCESCPKGDIR%\bin
SET PATH=%PATH%;%XALANCPKGDIR%\bin

SET LIB=%LIB%;%XERCESCPKGDIR%\lib
SET LIB=%LIB%;%XALANCPKGDIR%\lib

::=================================================================================
::
:: Here we can validate the standard Visual Studio .NET C++ directory paths
:: before we call "devenv.exe" /useenv that inserts these variables into the 
:: development environment.  Just remove the :: comment codes
::
 echo "--------------------------"
 echo PATH    = %PATH%
 echo "--------------------------"
 echo INCLUDE = %INCLUDE%
 echo "--------------------------"
 echo LIB     = %LIB%
 echo "--------------------------"
 echo LIBPATH = %LIBPATH%
 echo "--------------------------"
 echo SOURCE  = %SOURCE%
 echo "--------------------------"

::
:: Startup Visual Studio .NET (IDE) with the customized environment variables.
:: Note:  our custom environment variables $(LEMSDIR) etc. are usable in the
:: development environment, but are not visible in the macro table definitions.
:: Visual Studio .NET 2005 TeamWorks should be able to make these visible.
::

devenv.exe "exslt\exslt.sln" /useenv

:: From within Visual Studio .NET you can open Tools->Options->Project->C++ Directories
:: to validate the definitions of PATH, INCLUDE, LIB, LIBPATH, and SOURCE.  These
:: are the environment variables that will be stored in %USERPROFILE% between sessions.

:: Here we can cleanup the %USERPROFILE% if desired after the devenv.exe
:: build process has been completed.  The 'devenv.exe' can also serve as a
:: batch interface for automated solution builds - see documentation of
:: other parameters associated with the 'devenv.exe' program.
:: 
