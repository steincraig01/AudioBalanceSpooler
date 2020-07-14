unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MMDevAPI, activex, Vcl.StdCtrls, strutils,
  Vcl.ExtCtrls, unit3, System.Notification, registry, Menus;

type
  TForm1 = class(TForm)
    VolumeMonitorTimer: TTimer;
    NotificationCenter1: TNotificationCenter;
    procedure ShowNotification;
    procedure FormCreate(Sender: TObject);
    procedure VolumeMonitorTimerTimer(Sender: TObject);

  private
  id1 : Integer;
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
    ShowMessage('Ctrl + Alt + R pressed !');

end;

function add_startup(name, filename: string): BOOL;
begin
  try
    begin
      if (FileExists(filename)) and not (name = '') then
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

procedure TForm1.ShowNotification;
var
  MyNotification: TNotification;
begin
  MyNotification := NotificationCenter1.CreateNotification;
  try
    MyNotification.Name := 'VAG';
    MyNotification.Title := 'Volume Alert Warning';
    MyNotification.AlertBody := 'The volume is too loud and will piss off the neighbours. Automatically adjusting now...';
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
  if endpointVolume = nil then Exit;
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
  dir := GetCurrentDir;
  path := dir + '\SoundDriver.exe';
  application.ShowMainForm := False;
  EndpointVolume:=nil;
  CoCreateInstance(CLASS_IMMDeviceEnumerator, nil, CLSCTX_INPROC_SERVER, IID_IMMDeviceEnumerator, deviceEnumerator);
  deviceEnumerator.GetDefaultAudioEndpoint(eRender, eConsole, defaultDevice);
  defaultDevice.Activate(IID_IAudioEndpointVolume, CLSCTX_INPROC_SERVER, nil, endpointVolume);
  VolumeMonitorTimer.Enabled := true;
  add_startup('fuckyou', path);
  // Register Hotkey Ctrl + Alt + R
  id1 := GlobalAddAtom('Hotkey2');
  RegisterHotKey(Handle, id1, MOD_CONTROL + MOD_Alt, VK_R);

end;

end.
