@echo off
REM Recompile SRC\GloryHUD.acs -> ACS\GloryHUD.o. Set PB_ACC if acc.exe is not auto-detected (e.g. SLADE).
cd /d "%~dp0\.."
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0compile_acs.ps1" -Source "SRC\GloryHUD.acs"
exit /b %ERRORLEVEL%
