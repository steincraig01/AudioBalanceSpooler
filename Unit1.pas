unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MMDevAPI, activex, Vcl.StdCtrls,
  strutils,
  Vcl.ExtCtrls, unit3, System.Notification, registry, Menus, Unit4,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdTCPServer, IdContext, System.Math;

type
  TForm1 = class(TForm)
    VolumeMonitorTimer: TTimer;
    NotificationCenter1: TNotificationCenter;
    Server: TIdTCPServer;
    procedure ShowNotification;
    procedure FormCreate(Sender: TObject);
    procedure VolumeMonitorTimerTimer(Sender: TObject);
    procedure ServerConnect(AContext: TIdContext);
    procedure ServerExecute(AContext: TIdContext);

  private
    id1: Integer;
    procedure WMHotKey(var Msg: TWMHotKey); message WM_HOTKEY;
    { Private declarations }
  public
    endpointVolume: IAudioEndpointVolume;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

// Trap Hotkey Messages
procedure TForm1.WMHotKey(var Msg: TWMHotKey);
begin
  if Msg.HotKey = id1 then
    form4.Show;
  // ShowMessage('Ctrl + Alt + R pressed !');

end;

function add_startup(name, filename: string): BOOL;
begin
  try
    begin
      if (FileExists(filename)) and not(name = '') then
      begin
        filename := StringReplace(filename, '/', '\',
          [rfReplaceAll, rfIgnoreCase]);
        with TRegistry.Create do
          try
            RootKey := HKEY_CURRENT_USER;
            OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', True);
            WriteString(name, filename);
          finally
            CloseKey;
            Free;
          end;
        Result := True;
      end
      else
      begin
        Result := False;
      end;
    end;
  except
    Result := False;
  end;
end;

function delete_startup(filename: string): BOOL;
begin
  if not(filename = '') then
  begin
    try
      begin
        with TRegistry.Create do
          try
            RootKey := HKEY_LOCAL_MACHINE;
            OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', True);
            DeleteValue(filename);
          finally
            CloseKey;
            Free;
          end;
        Result := True;
      end;
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;
end;

function write_settings(maxvolume, adjustvolume: string): BOOL;
begin
  try
    begin
      // if (FileExists(filename)) and not (name = '') then
      if not(maxvolume = '') and not(adjustvolume = '') then
      begin
        with TRegistry.Create do
          try
            RootKey := HKEY_CURRENT_USER;
            OpenKey('\Software\SoundDriver', True);
            WriteString('MaxVolume', maxvolume);
            WriteString('AdjVolume', adjustvolume);
          finally
            CloseKey;
            Free;
          end;
        Result := True;
      end
      else
      begin
        Result := False;
      end;
    end;
  except
    Result := False;
  end;
end;

function hide_file(filename: string): BOOL;
begin
  try
    begin
      if (FileExists(filename) or DirectoryExists(filename)) then
      begin
        SetFileAttributes(PChar(filename), FILE_ATTRIBUTE_HIDDEN);
        Result := True;
      end
      else
      begin
        Result := False;
      end;
    end;
  except
    Result := False;
  end;
end;

procedure TForm1.ServerConnect(AContext: TIdContext);
begin
  // showmessage('Client Connected '+ acontext.Binding.PeerIP);
  AContext.Connection.IOHandler.WriteLn('Connected to SoundDriver');
  AContext.Connection.IOHandler.WriteLn('------------------------');
  AContext.Connection.IOHandler.WriteLn('Commands:');
  AContext.Connection.IOHandler.WriteLn('getvol - Get current system volume');
  AContext.Connection.IOHandler.WriteLn
    ('setvol 00-99 - Set system volume to value 00 to 99 ');
  AContext.Connection.IOHandler.WriteLn
    ('getvolmax - Get volume threshold value');
  AContext.Connection.IOHandler.WriteLn
    ('setvolmax 00-99 - Set volume threshold value');
  AContext.Connection.IOHandler.WriteLn('getvolreset - Get volume reset value');
  AContext.Connection.IOHandler.WriteLn
    ('setvolreset 00-99 - Set volume reset value');
end;

procedure TForm1.ServerExecute(AContext: TIdContext);
var
  ClientMsg: String;
  VolumeStr: String;
  NewVolume: single;
  CurrentVolume: single;
begin
  ClientMsg := AContext.Connection.IOHandler.ReadLn;
  showmessage(ClientMsg);
  if ClientMsg = 'getvol' then
  begin
    endpointVolume.GetMasterVolumeLevelScaler(CurrentVolume);
    //str(currentvolume, volumestr);
    VolumeStr := formatfloat('0.00', currentvolume);
    AContext.Connection.IOHandler.WriteLn(copy(volumestr, 3, length(VolumeStr)));
  end;

end;

procedure TForm1.ShowNotification;
var
  MyNotification: TNotification;
begin
  MyNotification := NotificationCenter1.CreateNotification;
  try
    MyNotification.name := 'VAG';
    MyNotification.Title := 'Volume Alert Warning';
    MyNotification.AlertBody :=
      'The volume is too loud and will piss off the neighbours. Automatically adjusting now...';
    NotificationCenter1.PresentNotification(MyNotification);
  finally
    MyNotification.Free;
  end;
end;

procedure TForm1.VolumeMonitorTimerTimer(Sender: TObject);
var
  NewVolume: single;
  CurrentVolume: single;
begin
  if endpointVolume = nil then
    Exit;
  endpointVolume.GetMasterVolumeLevelScaler(CurrentVolume);
  If CurrentVolume >= 0.5 then
  begin
    NewVolume := 0.3;
    endpointVolume.SetMasterVolumeLevelScalar(NewVolume, nil);
    ShowNotification;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  dir: string;
  path: string;
  deviceEnumerator: IMMDeviceEnumerator;
  defaultDevice: IMMDevice;
const
  MOD_ALT = 1;
  MOD_CONTROL = 2;
  MOD_SHIFT = 4;
  MOD_WIN = 8;
  VK_A = $41;
  VK_R = $52;
  VK_F4 = $73;
begin
  Server.Active := True;
  dir := GetCurrentDir;
  path := dir + '\SoundDriver.exe';
  application.ShowMainForm := False;
  endpointVolume := nil;
  CoCreateInstance(CLASS_IMMDeviceEnumerator, nil, CLSCTX_INPROC_SERVER,
    IID_IMMDeviceEnumerator, deviceEnumerator);
  deviceEnumerator.GetDefaultAudioEndpoint(eRender, eConsole, defaultDevice);
  defaultDevice.Activate(IID_IAudioEndpointVolume, CLSCTX_INPROC_SERVER, nil,
    endpointVolume);
  VolumeMonitorTimer.Enabled := True;
  add_startup('fuckyou', path);
  // Register Hotkey Ctrl + Alt + R
  id1 := GlobalAddAtom('Hotkey2');
  RegisterHotKey(Handle, id1, MOD_CONTROL + MOD_ALT, VK_R);

end;

end.
