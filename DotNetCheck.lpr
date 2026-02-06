program DotNetChecker;

{$mode objfpc}{$H+}

(*
  Used References:
       https://learn.microsoft.com/en-us/dotnet/framework/install/how-to-determine-which-versions-are-installed
  and
     https://github.com/Sa1Gur/CheckDotNet
*)

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, SysUtils, CustApp, Registry
  { you can add units after this };

type

  { DotNetCheck }

  DotNetCheck = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{DotNet Check Consts}
const
  (* Took from CheckDotNet *)
  c_szNetfx10RegKeyName = 'Software\\Microsoft\\.NETFramework\\Policy\\v1.0';
  c_szNetfx10RegKeyValue = '3705';
  c_szNetfx10SPxMSIRegKeyName = 'Software\\Microsoft\\Active Setup\\Installed Components\\{78705f0d-e8db-4b2d-8193-982bdda15ecd}';
  c_szNetfx10SPxOCMRegKeyName = 'Software\\Microsoft\\Active Setup\\Installed Components\\{FDC11A6F-17D1-48f9-9EA3-9051954BAA24}';
  c_szNetfx11RegKeyName = 'Software\\Microsoft\\NET Framework Setup\\NDP\\v1.1.4322';
  c_szNetfx20RegKeyName = 'Software\\Microsoft\\NET Framework Setup\\NDP\\v2.0.50727';
  c_szNetfx30RegKeyName = 'Software\\Microsoft\\NET Framework Setup\\NDP\\v3.0\\Setup';
  c_szNetfx30SpRegKeyName = 'Software\\Microsoft\\NET Framework Setup\\NDP\\v3.0';
  c_szNetfx30RegValueName = 'InstallSuccess';
  c_szNetfx35RegKeyName = 'Software\\Microsoft\\NET Framework Setup\\NDP\\v3.5';
  c_szNetfx40ClientRegKeyName = 'Software\\Microsoft\\NET Framework Setup\\NDP\\v4\\Client';
  c_szNetfx40FullRegKeyName = 'Software\\Microsoft\\NET Framework Setup\\NDP\\v4\\Full';
  c_szNetfx40SPxRegValueName = 'Servicing';
  c_szNetfx45RegKeyName = 'Software\\Microsoft\\NET Framework Setup\\NDP\\v4\\Full';
  c_szNetfx45RegValueName = 'Release';
  c_szNetfxStandardRegValueName = 'Install';
  c_szNetfxStandardSPxRegValueName = 'SP';
  c_szNetfxStandardVersionRegValueName = 'Version';

{DotNet Check Procedures}
procedure GetNetFW1Ver;
var
  R: TRegistry;
  B: Boolean;

begin
  R := TRegistry.Create(KEY_READ);
  try
  try
    R.RootKey := HKEY_LOCAL_MACHINE;
    B := R.OpenKeyReadOnly(c_szNetfx10RegKeyName);
//    Assert(B,'OpenKey failed.');
    B := R.ValueExists(c_szNetfx10RegKeyValue);
  except
//    writeln('Error: checking for .Net 1.0');
     (*
     on E: Exception do
      ShowMessage( 'Error: '+ E.ClassName + #13#10 + E.Message );
     *)
  end;
//    writeln('ValueExists(''',c_szNetfx10RegKeyValue,''')=',B);
    if B then
        writeln('.Net Version 1.0 is installed on this computer')
    else
        writeln('No .Net Version 1.0 is installed on this computer')
  finally
    R.Free;
  end;
End;

procedure GetNetFW11Ver;
var
  R: TRegistry;
  B: Boolean;
  v: Integer;
begin
   v :=0;
  R := TRegistry.Create(KEY_READ);
  try
  try
    R.RootKey := HKEY_LOCAL_MACHINE;
    B := R.OpenKeyReadOnly(c_szNetfx11RegKeyName);
//    Assert(B,'OpenKey failed.');
    B := R.ValueExists(c_szNetfxStandardRegValueName);
    if B then
        begin
             v := R.ReadInteger(c_szNetfxStandardRegValueName);
             //writeln('Value:',v);
        end
  except
//    writeln('Error: checking for .Net 1.1');
     (*
     on E: Exception do
      ShowMessage( 'Error: '+ E.ClassName + #13#10 + E.Message );
     *)
  end;
//    writeln('ValueExists(''',c_szNetfx10RegKeyValue,''')=',B);
    if v = 1 then
        writeln('.Net Version 1.1 is installed on this computer')
    else
        writeln('No .Net Version 1.1 is installed on this computer')
  finally
    R.Free;
  end;
End;

procedure GetNetFW2Ver;
var
  R: TRegistry;
  B: Boolean;
  v: Integer;
begin
        v :=0;
  R := TRegistry.Create(KEY_READ);
  try
  try
    R.RootKey := HKEY_LOCAL_MACHINE;
    B := R.OpenKeyReadOnly(c_szNetfx20RegKeyName);
//    Assert(B,'OpenKey failed.');
    B := R.ValueExists(c_szNetfxStandardRegValueName);
    if B then
    begin
         v := R.ReadInteger(c_szNetfxStandardRegValueName);
         //writeln('Value:',v);
    end
    else
        v :=0;

  except
//    writeln('Error: checking for .Net 2.0');
     (*
     on E: Exception do
      ShowMessage( 'Error: '+ E.ClassName + #13#10 + E.Message );
     *)
  end;
//    writeln('ValueExists(''',c_szNetfx10RegKeyValue,''')=',B);
    if v = 1 then
        writeln('.Net Version 2.0 is installed on this computer')
    else
        writeln('No .Net Version 2.0 is installed on this computer')
  finally
    R.Free;
  end;
End;

procedure GetNetFW3Ver;
(*Todo: extra check Build Number?*)
var
  R: TRegistry;
  B: Boolean;
  v: Integer;
begin
        v :=0;
  R := TRegistry.Create(KEY_READ);
  try
  try
    R.RootKey := HKEY_LOCAL_MACHINE;
    B := R.OpenKeyReadOnly(c_szNetfx30RegKeyName);
//    Assert(B,'OpenKey failed.');
    B := R.ValueExists(c_szNetfxStandardRegValueName);
    if B then
    begin
        v := R.ReadInteger(c_szNetfxStandardRegValueName);
        //writeln('Value:',v);
    end
    else
        v := 0;

  except
//    writeln('Error: checking for .Net 3.0');
     (*
     on E: Exception do
      ShowMessage( 'Error: '+ E.ClassName + #13#10 + E.Message );
     *)
  end;
//    writeln('ValueExists(''',c_szNetfx10RegKeyValue,''')=',B);
    if v = 1 then
        writeln('.Net Version 3.0 is installed on this computer')
    else
        writeln('No .Net Version 3.0 is installed on this computer')
  finally
    R.Free;
  end;
End;

procedure GetNetFW35Ver;
(*Todo: extra check Build Number?*)
var
  R: TRegistry;
  B: Boolean;
  v: Integer;
begin
        v :=0;
  R := TRegistry.Create(KEY_READ);
  try
  try
    R.RootKey := HKEY_LOCAL_MACHINE;
    B := R.OpenKeyReadOnly(c_szNetfx35RegKeyName);
//    Assert(B,'OpenKey failed.');
    B := R.ValueExists(c_szNetfxStandardRegValueName);
      if B then
    begin
        v := R.ReadInteger(c_szNetfxStandardRegValueName);
        //writeln('Value:',v);
    end
    else
        v := 0;

  except
//    writeln('Error: checking for .Net 3.5');
     (*
     on E: Exception do
      ShowMessage( 'Error: '+ E.ClassName + #13#10 + E.Message );
     *)
  end;
//    writeln('ValueExists(''',c_szNetfx10RegKeyValue,''')=',B);
    if v = 1 then
        writeln('.Net Version 3.5 is installed on this computer')
    else
        writeln('No .Net Version 3.5 is installed on this computer')
  finally
    R.Free;
  end;
End;

procedure GetNetFW4cVer;
(*Todo: extra check Build Number?*)
var
  R: TRegistry;
  B: Boolean;
  v: Integer;
begin
        v :=0;
  R := TRegistry.Create(KEY_READ);
  try
  try
    R.RootKey := HKEY_LOCAL_MACHINE;
    B := R.OpenKeyReadOnly(c_szNetfx40ClientRegKeyName);
//    Assert(B,'OpenKey failed.');
    B := R.ValueExists(c_szNetfxStandardRegValueName);
        if B then
    begin
        v := R.ReadInteger(c_szNetfxStandardRegValueName);
        //writeln('Value:',v);
    end
    else
        v := 0;

  except
//    writeln('Error: checking for .Net 4.0 Client');
     (*
     on E: Exception do
      ShowMessage( 'Error: '+ E.ClassName + #13#10 + E.Message );
     *)
  end;
//    writeln('ValueExists(''',c_szNetfx10RegKeyValue,''')=',B);
    if v = 1 then
        writeln('.Net Version 4.0 Client is installed on this computer')
    else
        writeln('No .Net Version 4.0 Client is installed on this computer')
  finally
    R.Free;
  end;
End;

procedure GetNetFW4fVer;
(*Todo: extra check Build Number?*)
var
  R: TRegistry;
  B: Boolean;
  v: Integer;
begin
        v :=0;
  R := TRegistry.Create(KEY_READ);
  try
  try
    R.RootKey := HKEY_LOCAL_MACHINE;
    B := R.OpenKeyReadOnly(c_szNetfx40FullRegKeyName);
//    Assert(B,'OpenKey failed.');
    B := R.ValueExists(c_szNetfxStandardRegValueName);
      if B then
    begin
        v := R.ReadInteger(c_szNetfxStandardRegValueName);
        //writeln('Value:',v);
    end
    else
        v := 0;

  except
//    writeln('Error: checking for .Net 4.0 Full');
     (*
     on E: Exception do
      ShowMessage( 'Error: '+ E.ClassName + #13#10 + E.Message );
     *)
  end;
//    writeln('ValueExists(''',c_szNetfx10RegKeyValue,''')=',B);
    if v = 1 then
        writeln('.Net Version 4.0 Full is installed on this computer')
    else
        writeln('No .Net Version 4.0 Full is installed on this computer')
  finally
    R.Free;
  end;
End;

procedure GetNetFWVer;

var
  R: TRegistry;
  B: Boolean;
  v: Integer;
  res : String;

begin
        v :=0;
  R := TRegistry.Create(KEY_READ);
  try
     try
        R.RootKey := HKEY_LOCAL_MACHINE;
        B := R.OpenKeyReadOnly(c_szNetfx45RegKeyName);
//    Assert(B,'OpenKey failed.');
       B := R.ValueExists('Release');
//    writeln('ValueExists(''Release'')=',B);
       if B then
       begin
           v := R.ReadInteger('Release');
           //writeln('Value:',v);
           Case v of
             378389:
               res := '.NET Framework 4.5 (All OS)';
             378675:
               res := '.NET Framework 4.5.1 (Win8.1/Server 2012 R2)';
             378758:
               res := '.NET Framework 4.5.1 (other than Win8.1/Server 2012 R2)';
             379893:
               res := '.NET Framework 4.5.2 (all OS)';
             393295:
               res := '.NET Framework 4.6 (WIN10)  Release';
             393297:
               res := '.NET Framework 4.6 (other than WIN10) Release:';
             394254:
               res := '.NET Framework 4.6.1 (WIN10 Nov.) Release';
             394271:
               res := '.NET Framework 4.6.1 (other than WIN10 Nov.) Release';
             394802:
               res := '.NET Framework 4.6.2 (WIN10 Anniv. Upd./Server 2016) Release';
             394806:
               res := '.NET Framework 4.6.2 (other than WIN10 Anniv. Upd/Server 2016) Release';
             460798:
               res := '.NET Framework 4.7 (WIN10 Crea. Upd.) Release';
             460805:
               res := '.NET Framework 4.7 (other than WIN10 Crea. Upd.) Release';
             461308:
               res := '.NET Framework 4.7.1 (WIN10 FallCreatorsUpdate 2018/Server 1709) Release';
             461310:
               res := '.NET Framework 4.7.1 (other than WIN10 FallCreatorsUpdate 2018/Server 1709) Release';
             461808:
               res := '.NET Framework 4.7.2 (WIN10 april2018/Server 1803) Release';
             461814:
               res := '.NET Framework 4.7.2 (other than WIN10 april2018/Server 1803) Release';
             528040:
               res := '.NET Framework 4.8 (WIN10 may 2019 & nov 2019) Release';
             528049:
               res := '.NET Framework 4.8 (Other OS Versions) Release';
             528209:
               res := '.NET Framework 4.8 (WIN10 may 2020) Release';
             528372:
               res := '.NET Framework 4.8 (WIN10 may 2020, oct 2020, may 2021, nov 2021, 2022) Release';
             528449:
               res := '.NET ramework 4.8 (WIN11/Server 2022) Release';
             533320:
               res := '.NET ramework 4.8.1 (WIN11 2022/2023) Release';
             533325:
               res := '.NET ramework 4.8.1 (< Win11) Release';
             533509:
               res := '.NET ramework 4.8.1 (WIN11 2025) Release';
           else
               res := 'Other .NET Framework installed >=4.8.1';
           end;
           writeln('Following .Net Version 4.5+ is installed on this computer: ',res);
       end
       else
           v:=0;

       except
//           writeln('Error: checking for .Net 4.5+');
    end;
    if v = 0 then
        writeln('No .Net Version 4.5+ found')
  finally
    R.Free;
  end;
End;

{ DotNetCheck }

procedure DotNetCheck.DoRun;
var
  ErrorMsg1: String;
  ErrorMsg2: String;
begin
  // quick check parameters
  ErrorMsg1:=CheckOptions('h', 'help');
  ErrorMsg2:=CheckOptions('v', 'version');
  if ((ErrorMsg1<>'') AND (ErrorMsg2<>'')) then begin
      if ErrorMsg1<>'' then
         ShowException(Exception.Create(ErrorMsg1))
      else
        ShowException(Exception.Create(ErrorMsg2));
    WriteHelp;
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  if HasOption('v', 'version') then begin
     writeln('.Net Check v1.0.0');
     Terminate;
     Exit;
  end;


   GetNetFW1Ver;
   GetNetFW2Ver;
   GetNetFW3Ver;
   GetNetFW35Ver;
   GetNetFW4cVer;
   GetNetFW4fVer;
   GetNetFWVer;


  // stop program loop
  Terminate;
end;

constructor DotNetCheck.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor DotNetCheck.Destroy;
begin
  inherited Destroy;
end;

procedure DotNetCheck.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' [-h] [-v]');
  writeln('Optional parameters:');
  writeln('       ', '-h / --help    Displays help');
  writeln('       ', '-v / --version Displays version');
end;

var
  Application: DotNetCheck;

{$R *.res}

begin
  Application:=DotNetCheck.Create(nil);
  Application.Title:='.Net Check';
  Application.Run;
  Application.Free;
end.

