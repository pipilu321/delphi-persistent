unit UQyPersistent;

interface

uses
  Classes, System.Rtti, System.TypInfo, System.Types, StdCtrls, SysUtils;

type
  Persistent = class(TCustomAttribute)
  end;

  IWriter = interface
    procedure WriteValue(Sender: TObject; Obj: TObject;
      const Key: string; const Value: TValue);
  end;

  IReader = interface
    procedure ReadValue(Sender: TObject; Obj: TObject;
      const Key: string; var Value: TValue);
  end;

  TPersistentService = class
  public
    procedure Save(obj: TObject; Writer: IWriter);
    procedure Read(obj: TObject; Reader: IReader);
  end;

  function PersistentService: TPersistentService;

implementation

var
  PersistentServiceInstance: TPersistentService;

function PersistentService: TPersistentService;
begin
  if not Assigned(PersistentServiceInstance) then
    PersistentServiceInstance := TPersistentService.Create;
  Result := PersistentServiceInstance;
end;

{ TPersistentService }

procedure TPersistentService.Read(obj: TObject; Reader: IReader);
var
  LRttiContext: TRttiContext;
  LRttiType: TRttiType;
  LRttiProperty: TRttiProperty;
  LAttr: TCustomAttribute;
  LRttiField: TRttiField;
  LComponent: TComponent;

  LValue: TValue;
begin
  LRttiContext := TRttiContext.Create;
  try
    LRttiType := LRttiContext.GetType(obj.ClassType);
    for LRttiProperty in LRttiType.GetProperties do
    begin
      for LAttr in LRttiProperty.GetAttributes do
      begin
        if LAttr is Persistent then
        begin
          LValue := LRttiProperty.GetValue(obj);
          Reader.ReadValue(Self, obj, LRttiProperty.Name, LValue);
          LRttiProperty.SetValue(obj, LValue);
        end;
      end;
    end;
    for LRttiField in LRttiType.GetDeclaredFields do
    begin
      for LAttr in LRttiField.GetAttributes do
      begin
        if LAttr is Persistent then
        begin
          if obj is TComponent then
          begin
            LComponent := TComponent(obj).FindComponent(LRttiField.Name);
            if Assigned(LComponent) then
            begin
              if LComponent is TEdit then
              begin
                LValue := TEdit(LComponent).Text;
                Reader.ReadValue(Self, obj, LRttiField.Name, LValue);
                TEdit(LComponent).Text := LValue.ToString;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    LRttiContext.Free;
  end;
end;

procedure TPersistentService.Save(obj: TObject; Writer: IWriter);
var
  LRttiContext: TRttiContext;
  LRttiType: TRttiType;
  LAttr: TCustomAttribute;
  LRttiField: TRttiField;
  LRttiProperty: TRttiProperty;
  LComponent: TComponent;
begin
  LRttiContext := TRttiContext.Create;
  try
    LRttiType := LRttiContext.GetType(obj.ClassType);
    for LRttiProperty in LRttiType.GetProperties do
    begin
      for LAttr in LRttiProperty.GetAttributes do
      begin
        if LAttr is Persistent then
        begin
          Writer.WriteValue(Self, obj, LRttiProperty.Name, LRttiProperty.GetValue(obj));
        end;
      end;
    end;
    for LRttiField in LRttiType.GetDeclaredFields do
    begin
      for LAttr in LRttiField.GetAttributes do
      begin
        if LAttr is Persistent then
        begin
          if obj is TComponent then
          begin
            LComponent := TComponent(obj).FindComponent(LRttiField.Name);
            if Assigned(LComponent) then
            begin
              if LComponent is TEdit then
                Writer.WriteValue(Self, obj, LRttiField.Name, TEdit(LComponent).Text);
            end;
          end
          else begin
            Writer.WriteValue(Self, obj, LRttiField.Name, LRttiField.GetValue(obj));
          end;
        end;
      end;
    end;
  finally
    LRttiContext.Free;
  end;
end;

initialization
finalization
  if Assigned(PersistentServiceInstance) then
    FreeAndNil(PersistentServiceInstance);

end.
