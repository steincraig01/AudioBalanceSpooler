object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 120
  ClientWidth = 148
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object VolumeMonitorTimer: TTimer
    Enabled = False
    Interval = 30000
    OnTimer = VolumeMonitorTimerTimer
    Left = 56
    Top = 72
  end
  object NotificationCenter1: TNotificationCenter
    Left = 56
    Top = 8
  end
end