program tiny_window;
{$i external.inc}

var
  win : HWND;
  msg: TMSG;
  rc: trect = (left:0;top:0;Right:900;Bottom:620);

function WindowProc(Wnd: HWND; Msg: longword; WParam: longint; LParam: longint): longint; stdcall;
begin
  case msg of
    WM_CLOSE:
    begin
      PostQuitMessage(0);
      Exit;
    end;
    WM_PAINT: begin
        GetClientRect(Wnd,@rc);
		FillRect(getdc(Wnd),rc,CreateSolidBrush($908080));
    end;
  end;
  WindowProc := DefWindowProcA(Wnd, Msg, WParam, LParam);
end;

begin
  win := CreateWindowExA(WS_EX_TOOLWINDOW,'static', 'MiniWin', WS_SYSMENU or WS_CAPTION, 100, 100, 900, 620, 0, 0, 0, nil);

  SetWindowLongA(win, GWLP_WNDPROC, longword(@WindowProc));
  ShowWindow(win, SW_SHOWDEFAULT);
  repeat
    if PeekMessageA(@msg, 0, 0, 0, PM_REMOVE)  then
    begin
        TranslateMessage(msg);
        DispatchMessageA(msg);
    end else begin
     sleep(16);
    end;
  until (msg.message = WM_QUIT);
  DestroyWindow(win);
end.

