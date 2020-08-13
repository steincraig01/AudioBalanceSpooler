object Form4: TForm4
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'SoundDriver Settings'
  ClientHeight = 167
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 313
    Height = 57
    Caption = 'Max Volume'
    TabOrder = 0
    object tbMaxPercent: TcxTrackBar
      Left = 0
      Top = 13
      Properties.ShowPositionHint = True
      Properties.OnChange = tbMaxPercentPropertiesChange
      TabOrder = 0
      Height = 44
      Width = 262
    end
    object lblMaxPercent: TcxLabel
      Left = 268
      Top = 21
      Caption = '0 %'
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 71
    Width = 313
    Height = 58
    Caption = 'Adjusted Volume'
    TabOrder = 1
    object tbAdjPercent: TcxTrackBar
      Left = 0
      Top = 16
      Properties.ShowPositionHint = True
      Properties.OnChange = tbAdjPercentPropertiesChange
      TabOrder = 0
      Height = 39
      Width = 262
    end
    object lblAdjPercent: TcxLabel
      Left = 268
      Top = 24
      Caption = '0 %'
    end
  end
  object Button1: TButton
    Left = 126
    Top = 135
    Width = 75
    Height = 25
    Caption = 'Apply'
    TabOrder = 2
    OnClick = Button1Click
  end
end
