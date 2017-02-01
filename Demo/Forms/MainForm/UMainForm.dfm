object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 75
  ClientWidth = 401
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object edtDemo: TEdit
    Left = 32
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'edtDemo'
  end
  object btnSave: TButton
    Left = 184
    Top = 22
    Width = 75
    Height = 25
    Caption = 'btnSave'
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object btnRead: TButton
    Left = 286
    Top = 22
    Width = 75
    Height = 25
    Caption = 'btnRead'
    TabOrder = 2
    OnClick = btnReadClick
  end
end
