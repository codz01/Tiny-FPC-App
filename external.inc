
const WM_PAINT = $000F;
const WM_CLOSE = $0010;
const WS_SYSMENU = $00080000;
const WS_CAPTION = $00C00000;
const WM_QUITE = $0012;
const WS_EX_TOOLWINDOW = $00000080;
const GWLP_WNDPROC = -4; 
const SW_SHOWDEFAULT = 10;
const PM_REMOVE = 1;
const WM_QUIT = 18;

const   kernel32            = 'kernel32.dll';
const   user32              = 'user32.dll';
const   gdi32               = 'gdi32.dll';

type Int32 = longint;

type TRect = record
  Left: Int32;
  Top: Int32;
  Right: Int32;
  Bottom: Int32;
end;

type THandle = longword;
type HWND = THandle;
type HDC = THandle;
type HBRUSH = THandle;

type TPoint = record
  x,y : Int32;
end;
type PRect = ^TRect;

type Pchar = ^char;

type 
  TMsg = record
  hwnd: THandle;
  message: longword;
  wParam: longword;
  lParam: longword;
  time: longword;
  pt: TPoint;
end;
type 
  PMsg = ^TMsg;
  
function CreateWindowExA(dwExStyle: LongWord; lpClassName: pchar; lpWindowName: pchar; dwStyle: LongWord; X, Y, nWidth, nHeight: LongInt; hWndParent, hMenum, hInstance: LongWord; lpParam: Pointer): LongWord; stdcall; external user32;
function DestroyWindow(hWnd: LongWord): Boolean; stdcall; external user32;
function ShowWindow(hWnd: LongWord; nCmdShow: LongInt): Boolean; stdcall; external user32;
function SetWindowLongA(hWnd: LongWord; nIndex, dwNewLong: LongInt): LongInt; stdcall; external user32;
function DefWindowProcA(hWnd, Msg: LongWord; wParam, lParam: LongInt): LongInt; stdcall; external user32;
function PeekMessageA(lpMsg: PMsg; hWnd, Min, Max, Remove: LongWord): Boolean; stdcall; external user32;
function TranslateMessage(const lpMsg: TMsg): Boolean; stdcall; external user32;
function DispatchMessageA(const lpMsg: TMsg): LongInt; stdcall; external user32;
procedure Sleep(dwMilliseconds: LongWord); stdcall; external kernel32;
function FillRect(hDC:HDC; const lprc:TRECT; hbr:HBRUSH):longint; stdcall external user32;
function CreateSolidBrush(_para1:longword):HBRUSH; stdcall external gdi32;
function GetDC(hWnd: LongWord): LongWord; stdcall; external user32;
function GetClientRect(hWnd: HWND; lpRect: PRect): boolean; external user32;
procedure PostQuitMessage(nExitCode:longint); stdcall external user32;

