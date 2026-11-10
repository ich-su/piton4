program RegOCX;
uses VCLUtils;
begin
  WriteLn('RegOCX v0.1. For registration of the OCX-files in Windows');
  try
    if ParamCount = 1 then RegisterServer(ParamStr(1))
    else WriteLn('run: RegOCX <filename.ocx>');
  except
    WriteLn('Error of registration')
  end
end.

