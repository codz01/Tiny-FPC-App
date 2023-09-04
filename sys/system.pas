unit system;

interface

const
  TextRecNameLength = 256;
  TextRecBufSize    = 256;
  filerecnamelength = 255;

type
  SizeInt = Longint;
  HResult = LongWord;
  Integer = LongInt;
  PText   = ^Text;
  DWORD   = LongWord;
  THandle = LongWord;
  CodePointer = Pointer;
  TLineEndStr = string [3];
  TextBuf = array[0..TextRecBufSize-1] of {ansi}char;

  TSystemCodePage     = Word;
  UnicodeChar         = WideChar;
  TFileTextRecChar    = UnicodeChar;
  PFileTextRecChar    = ^TFileTextRecChar;

  TExceptAddr = record
  end;
	
  TVmt = record
  end;

  TextRec = Record
    Handle    : THandle;
    Mode      : longint;
    bufsize   : SizeInt;
    _private  : SizeInt;
    bufpos,
    bufend    : SizeInt;
    bufptr    : ^textbuf;
    openfunc,
    inoutfunc,
    flushfunc,
    closefunc : codepointer;
    UserData  : array[1..32] of byte;
    name      : array[0..textrecnamelength-1] of TFileTextRecChar;
    LineEnd   : TLineEndStr;
    buffer    : textbuf;
    CodePage  : TSystemCodePage;
  End;

  FileRec = {$ifdef VER2_6} packed {$endif} Record
    Handle    : THandle;
    Mode      : longint;
    RecSize   : SizeInt;
    _private  : array[1..3 * SizeOf(SizeInt) + 5 * SizeOf (pointer)] of byte;
    UserData  : array[1..32] of byte;
    name      : array[0..filerecnamelength] of TFileTextRecChar;
  End;

TYPE
 	PGUID = ^TGUID;
	TGUID = packed record
		D1: LongWord;
		D2: Word;
		D3: Word;
		D4: array[0..7] of Byte;
	end;
	jmp_buf = record
		EBX,
		ESI,
		EDI,
		ESP,
		EBP,
		EIP: LongWord;
	end;
	pjmp_buf = ^jmp_buf;
	TJMPBUF  =  jmp_buf;

	PTypeKind = ^TTypeKind;
	TTypeKind = (
		tkUnknown, tkInteger,
		tkChar, tkEnumeration,
		tkFloat);


var
  Output : Text;
  IsConsole : Boolean;
  StartupConsoleMode : DWORD;
  ExitCode : LongInt;

Function fpc_get_output:PText;compilerproc;
Procedure fpc_Write_Text_ShortStr(Len : Longint;var f : Text;const s : String); compilerproc;
Procedure fpc_Writeln_End(var f:Text); compilerproc;
procedure fpc_InitializeUnits; compilerproc;
procedure fpc_do_exit; compilerproc;

implementation

procedure ExitProcess(uExitCode:Integer); stdcall; external 'kernel32' name 'ExitProcess';
function WriteFile(hFile: THandle; lpBuffer:Pointer; NumberOfBytesToWrite: DWORD; 
  BytesWritter: Pointer; Overlapped: Pointer): LongWord; stdcall; external 'kernel32' name 'WriteFile';
function GetStdHandle(nStdHandle:DWORD) : THandle; stdcall; external 'kernel32' name 'GetStdHandle';

const
  STD_OUTPUT_HANDLE = dword(-11);


Function fpc_get_output:PText;compilerproc;
begin
  fpc_get_output:=@Output;
end;

Procedure fpc_Write_Text_ShortStr(Len : Longint;var f : Text;const s : String); [Public,Alias:'FPC_WRITE_TEXT_SHORTSTR']; compilerproc;
begin
  if length(s)>0 then  
    WriteFile( GetStdHandle(STD_OUTPUT_HANDLE), @s[1], length(s),  nil, nil);
end;

Procedure fpc_Writeln_End(var f:Text); iocheck; compilerproc;
begin
end;

procedure fpc_iocheck;[public,alias:'FPC_IOCHECK']; compilerproc;
begin 
end;

procedure fpc_InitializeUnits;[public,alias:'FPC_INITIALIZEUNITS']; compilerproc;
{var
  i : longint;}
begin
  { call cpu/fpu initialisation routine }
(*  fpc_cpuinit;
{$ifdef FPC_HAS_INDIRECT_MAIN_INFORMATION}
  with PInitFinalTable(EntryInformation.InitFinalTable)^ do
{$else FPC_HAS_INDIRECT_MAIN_INFORMATION}
  with InitFinalTable do
{$endif FPC_HAS_INDIRECT_MAIN_INFORMATION}
   begin
     for i:=1 to TableCount do
      begin
        if assigned(Procs[i].InitProc) then
         Procs[i].InitProc();
        InitCount:=i;
      end;
   end;
  if assigned(InitProc) then
    TProcedure(InitProc)();
*)
end;


Procedure system_exit;
begin
  { call exitprocess, with cleanup as required }
  ExitProcess(exitcode);
end;

procedure FPC_DO_EXIT; [public, alias: 'FPC_DO_EXIT']; compilerproc;
begin
  System_exit;
end;


end.
