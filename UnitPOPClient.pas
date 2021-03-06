unit UnitPOPClient;


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, mClient;

type
   TConnectionStatus = (Disconnect, NeedUsername, NeedPassword, Authentificated, Update);
   TPopClient = class(TClient)
       private
         answer: string;
         NewAnswer: boolean;
         procedure processMessage(pMessage :string); override;
       public
         constructor create(pServerIP:string; pServerPort:integer);
         function authenticate(username, password :string): string;
         function getConnectionStatus: TConnectionStatus;

end;


var
   ConnectionStatus: TConnectionStatus;

implementation

constructor TPopClient.create(pServerIP:string; pServerPort:integer);
begin
     inherited create(pServerIP, pServerPort);
     ConnectionStatus := NeedUsername;
     NewAnswer := false;
end;


procedure TPopClient.processMessage (pMessage:string);
begin
     NewAnswer := true;
     answer := pMessage;
end;

function TPopClient.authenticate(username, password :string):String;
var
   LogString: String;
begin
        logString := '';
          if NewAnswer = true then
          begin
               NewAnswer := false;
               case ConnectionStatus of
                    NeedUsername:
                    begin
                         if copy(answer,0,3) = '+OK' then
                         begin
                              self.send('USER '+username);
                              ConnectionStatus := NeedPassword;
                              logString := answer;
                         end;
                    end;
                    NeedPassword:
                    begin
                         if copy(answer,0,3) = '+OK' then
                         begin
                              self.send('PASS '+password);
                              ConnectionStatus := authentificated;
                              logString := answer;
                         end;
                    end;
                    authentificated:
                    begin
                         if copy(answer,0,3) = '+OK' then
                         begin
                              logString := logString + #13 + #10 + answer;
                              logString := answer;
                         end;
                    end;
               end;
          end;
          result := logString;
end;

function TPopClient.getConnectionStatus: TConnectionStatus;
begin
        result := ConnectionStatus;
end;

end.
 