unit UMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  UQyPersistent, Rtti, Vcl.StdCtrls, TypInfo;

type
  TMainForm = class(TForm, IWriter, IReader)
    [Persistent] // ** //
    edtDemo: TEdit;
    btnSave: TButton;
    btnRead: TButton;
    procedure btnSaveClick(Sender: TObject);
    procedure btnReadClick(Sender: TObject);
  private
    FDemoValue: string;
    FDemoValueInt: Integer;
    { Private declarations }
    procedure WriteValue(Sender: TObject; Obj: TObject;
      const Key: string; const Value: TValue);
    procedure ReadValue(Sender: TObject; Obj: TObject;
      const Key: string; var Value: TValue);
  public
    { Public declarations }
    [Persistent] // ** //
    property DemoValue: string read FDemoValue write FDemoValue;
    [Persistent] // ** //
    property DemoValueInt: Integer read FDemoValueInt write FDemoValueInt;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  IniFiles;

{ TMainForm }

procedure TMainForm.btnReadClick(Sender: TObject);
begin
  PersistentService.Read(Self, Self);
  ShowMessageFmt('DemoValue: %s, DemoValueInt: %d', [DemoValue, DemoValueInt]);
end;

procedure TMainForm.btnSaveClick(Sender: TObject);
begin
  DemoValue := 'test';
  DemoValueInt := 1234;
  PersistentService.Save(Self, Self);
end;

procedure TMainForm.ReadValue(Sender, Obj: TObject; const Key: string;
  var Value: TValue);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini');
  try
    case Value.Kind of
      tkInteger:
        Value := ini.ReadInteger('Default', Obj.ClassName + '.' + Key, Value.AsInteger);
      tkInt64:
        Value := ini.ReadInteger('Default', Obj.ClassName + '.' + Key, Value.AsInt64);
      tkChar, tkString, tkWChar, tkLString, tkWString, tkUString:
        Value := ini.ReadString('Default', Obj.ClassName + '.' + Key, Value.ToString);
    end;
  finally
    ini.Free;
  end;
end;

procedure TMainForm.WriteValue(Sender, Obj: TObject; const Key: string;
  const Value: TValue);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini');
  try
    ini.WriteString('Default', Obj.ClassName + '.' + Key, Value.ToString);
  finally
    ini.Free;
  end;
end;

end.
