program TestManu;
uses
  Forms,
  UTestManu in 'UTestManu.pas' {Form1};
  
begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

