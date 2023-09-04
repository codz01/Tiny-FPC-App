unit sysinitpas;

interface

implementation


    procedure PascalMain;stdcall;external name 'PASCALMAIN';

    function GetStdHandle(nStdHandle:DWORD) : THandle; stdcall; external 'kernel32' name 'GetStdHandle';
    function GetConsoleMode(hConsoleHandle: THandle; var lpMode: DWORD): Boolean; stdcall; external 'kernel32' name 'GetConsoleMode';
   function WriteFile(hFile: THandle; lpBuffer:Pointer; NumberOfBytesToWrite: DWORD; 
     BytesWritter: Pointer; Overlapped: Pointer): LongWord; stdcall; external 'kernel32' name 'WriteFile';

    const
      STD_INPUT_HANDLE = dword(-10);
      STD_OUTPUT_HANDLE = dword(-11);


    procedure _FPC_mainCRTStartup;stdcall;public name '_mainCRTStartup';
    begin
      IsConsole:=true;
      { do it like it is necessary for the startup code linking against cygwin }
      GetConsoleMode(GetStdHandle((Std_Input_Handle)),StartupConsoleMode);

//{$ifdef FPC_USE_TLS_DIRECTORY}
//      LinkIn(@tlsdir,@tls_callback_end,@tls_callback);
//{$endif}
//      SetupEntryInformation;
//      Exe_entry(EntryInformation);
      PascalMain();
    end;
   
   procedure _FPC_WinMainCRTStartup;stdcall;public name '_WinMainCRTStartup';
    begin
      IsConsole:=false;
//{$ifdef FPC_USE_TLS_DIRECTORY}
//      LinkIn(@tlsdir,@tls_callback_end,@tls_callback);
//{$endif}
//      SetupEntryInformation;
//      Exe_entry(SysInitEntryInformation);
    end;


end.