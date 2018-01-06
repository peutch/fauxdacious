; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Fauxdacious"
#define MyAppVersion "3.83-beta3"
#define MyAppPublisher "Jim Turner"
#define MyAppURL "https://wildstar84.wordpress.com/fauxdacious"
#define MyAppExeName "fauxdacious.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{736A9232-B76C-423A-9AEB-C443D32FC6CF}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DisableProgramGroupPage=yes
LicenseFile=C:\fauxdacious-3.8\COPYING.txt
InfoAfterFile=C:\fauxdacious-3.8\fauxdacious.txt
OutputBaseFilename=Fauxdacious_install
SetupIconFile=C:\fauxdacious-3.8\images\audacious.ico
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: "C:\faud\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "C:\libs\bin\avcodec-57.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\avdevice-57.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\avfilter-6.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\avformat-57.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\avutil-55.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\GTK\bin\libatk-1.0-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
;Source: "C:\libs\bin\libaudcore.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
;Source: "C:\libs\bin\libaudgui.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
;Source: "C:\libs\bin\libaudtag.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libbs2b-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\GTK\bin\libcairo-2.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\GTK\bin\libcairo-gobject-2.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libcddb-2.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libcdio++-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libcdio-13.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libcdio_cdda-1.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libcdio_paranoia-1.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libfaad-2.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\GTK\bin\libffi-6.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libFLAC++-6.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libFLAC-8.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libfluidsynth-1.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\MinGW\bin\libgcc_s_dw2-1.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\GTK\bin\libgdk_pixbuf-2.0-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\GTK\bin\libgdk-win32-2.0-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\GTK\bin\libgio-2.0-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\GTK\bin\libglib-2.0-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\GTK\bin\libgmodule-2.0-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libgnurx-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\GTK\bin\libgobject-2.0-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\GTK\bin\libgthread-2.0-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\GTK\bin\libgtk-win32-2.0-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\MinGW\bin\libiconv-2.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\MinGW\bin\libintl-8.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libiso9660++-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libiso9660-8.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\GTK\bin\libjpeg-62.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libmms-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libmodplug-1.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libmpg123-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libmp3lame-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libneon-27.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libeay32.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libssl32.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\ssleay32.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libogg-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\GTK\bin\libpango-1.0-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\GTK\bin\libpangocairo-1.0-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\GTK\bin\libpangowin32-1.0-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\GTK\bin\libpixman-1-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\GTK\bin\libpng16-16.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libsamplerate-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libsidplayfp-4.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libsndfile-1.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\MinGW\bin\libstdc++-6.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libstilview-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libudf-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libvorbis-0.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libvorbisenc-2.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libvorbisfile-3.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libwavpack-1.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libxml2-2.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\postproc-54.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\MinGW\bin\pthreadGC2.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\MinGW\bin\pthreadGCE2.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\SDL2.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\swresample-2.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\swscale-4.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libcue.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\MinGW\bin\zlib1.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libdvdread-4.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\libs\bin\libdvdnav-4.dll"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\GTK\lib\gdk-pixbuf-2.0\*"; DestDir: "{app}\lib\gdk-pixbuf-2.0"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "C:\GTK\lib\gtk-2.0\*"; DestDir: "{app}\lib\gtk-2.0"; Flags: ignoreversion recursesubdirs createallsubdirs
;Source: "C:\GTK\etc\gtk-2.0\*"; DestDir: "{app}\etc\gtk-2.0"; Flags: ignoreversion recursesubdirs createallsubdirs
;Source: "C:\pango\modules\basic\.libs\pango-basic-win32.dll"; DestDir: "{app}\lib\pango\1.8.0\modules\pango-basic-win32.dll"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "C:\aud\bin\audacious.exe"; DestDir: "{app}\bin"; DestName: "fauxdacious.exe"; Flags: ignoreversion
Source: "C:\aud\bin\audtool.exe"; DestDir: "{app}\bin"; DestName: "fauxdtool.exe"; Flags: ignoreversion
;Source: "C:\aud\bin\getTuneinStream.exe"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\aud\bin\FauxdaciousUrlHelper.exe"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "C:\aud\*"; DestDir: "{app}"; Excludes: "*.exe"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\bin\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\bin\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\bin\{#MyAppExeName}"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\bin\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
