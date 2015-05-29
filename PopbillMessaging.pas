(*
*=================================================================================
* Unit for base module for Popbill Messaging API SDK. Main functionality is to
* send Short Messaging To Cell phones. Also LMS and MMS.
*
* This module uses synapse library.( http://www.ararat.cz/synapse/doku.php/ )
* It's full open source library, free to use include commercial application.
* If you wish to donate that, visit their site.
* So, before using this module, you need to install synapse by user self.
* You can refer their site or detailed infomation about installation is available
* from below our site. We appreciate your visiting.
*
* For strongly secured communications, this module uses SSL/TLS with OpenSSL.
* So You need two dlls (libeay32.dll and ssleay32.dll) from OpenSSL. You can
* get it from Fulgan. ( http://indy.fulgan.com/SSL/ ) We recommend i386_win32 version.
* And also, dlls must be released with your executions. That's the drawback of this
* module, but we acommplished higher security level against that.
*
* http://www.popbill.com
* Author : Kim Seongjun (pallet027@gmail.com)
* Written : 2014-04-01

* Thanks for your interest. 
*=================================================================================
*)
unit PopbillMessaging;

interface
uses
        TypInfo,SysUtils,Classes,
        Popbill,
        Linkhub;
type
        EnumMessageType = (SMS,LMS,XMS,MMS);

        TSendMessage = class
        public
                sender          : string;
                receiver        : string;
                receiverName    : string;
                content         : string;
                subject         : string;
        end;

        TSendMessageList = Array Of TSendMessage;

        TSentMessage = class
        public
                state           : Integer;
                subject         : string;
                messageType     : EnumMessageType;
                content         : string;
                sendNum         : string;
                receiveNum      : string;
                receiveName     : string;
                reserveDT       : string;
                sendDT          : string;
                resultDT        : string;
                sendResult      : string;
        end;

        TSentMessageList = Array of TSentMessage;

        TMessagingService = class(TPopbillBaseService)
        private
                function SendMessage(MessageType : EnumMessageType; CorpNum : String; sender : string; content : string; subject : string; Messages: TSendMessageList; reserveDT : String; UserID : String) : String;
        public
                constructor Create(LinkID : String; SecretKey : String);

                //회원별 전송 단가 확인.
                function GetUnitCost(CorpNum : String; MsgType:EnumMessageType) : Single;

                //SMS 관련함수.
                function SendSMS(CorpNum : String; sender : string ; receiver : string; receiverName : String; content : String; reserveDT : String; UserID : String) : String; overload;
                function SendSMS(CorpNum : String; Messages : TSendMessageList; reserveDT : String; UserID : String) : String; overload;
                function SendSMS(CorpNum : String; sender : string; content : string; Messages: TSendMessageList; reserveDT : String; UserID : String) : String; overload;

                //LMS 관련함수.
                function SendLMS(CorpNum : String; sender : string ; receiver : string; receiverName : String; subject : String; content : String; reserveDT : String; UserID : String) : String; overload;
                function SendLMS(CorpNum : String; Messages : TSendMessageList; reserveDT : String; UserID : String) : String; overload;
                function SendLMS(CorpNum : String; sender : String; subject : String; content : string; Messages: TSendMessageList; reserveDT : String; UserID : String) : String; overload;

                //XMS 관련함수.
                function SendXMS(CorpNum : String; sender : string ; receiver : string; receiverName : String; subject : String; content : String; reserveDT : String; UserID : String) : String; overload;
                function SendXMS(CorpNum : String; Messages : TSendMessageList; reserveDT : String; UserID : String) : String; overload;
                function SendXMS(CorpNum : String; sender : String; subject : String; content : string; Messages: TSendMessageList; reserveDT : String; UserID : String) : String; overload;

                //MMS 관련함수.
                function SendMMS(CorpNum : String; sender : String; receiver : String; receiverName : String; subject : String; content : String; mmsfilepath : String; reserveDT : String; UserID : String) : String; overload;
                function SendMMS(CorpNum : String; sender : String; subject : String; content : String; Messages : TSendMessageList;  mmsfilepath : String; reserveDT : String; UserID : String) : String; overload;

                //메시지 상세내역 및 전송상태 확인.
                function GetMessages(CorpNum : String; receiptNum : string; UserID : String) :TSentMessageList;
                function CancelReserve(CorpNum : String; receiptNum : string; UserID : String) : TResponse;

                //문자관련 연결 url.
                function GetURL(CorpNum : String; UserID : String; TOGO : String) : String;
        end;
implementation
constructor TMessagingService.Create(LinkID : String; SecretKey : String);
begin
       inherited Create(LinkID,SecretKey);
       AddScope('150');
       AddScope('151');
       AddScope('152');
end;

function TMessagingService.GetUnitCost(CorpNum : String; MsgType:EnumMessageType) : Single;
var
        responseJson : string;
begin
        responseJson := httpget('/Message/UnitCost?Type=' + GetEnumName(TypeInfo(EnumMessageType),integer(MsgType)),CorpNum,'');

        result := strToFloat(getJSonString( responseJson,'unitCost'));

end;

function TMessagingService.SendMessage(MessageType : EnumMessageType; CorpNum : String; sender : string; content : string; subject : string; Messages: TSendMessageList; reserveDT : String; UserID : String) : String;
var
        requestJson, responseJson : string;
        i : Integer;
begin

        if Length(Messages) = 0 then raise EPopbillException.Create(-99999999,'전송할 메시지가 입력되지 않았습니다.');

        requestJson := '{';

        if sender <> ''          then requestJson := requestJson + '"snd":"' + EscapeString(sender) + '",';
        if content <> ''         then requestJson := requestJson + '"content":"' + EscapeString(content) + '",';
        if subject <> ''         then requestJson := requestJson + '"subject":"' + EscapeString(subject) + '",';
        if reserveDT <> ''       then requestJson := requestJson + '"sndDT":"' + EscapeString(reserveDT) + '",';

        requestJson := requestJson + '"msgs":[';
        for i := 0 to Length(Messages) - 1 do begin
                requestJson := requestJson +
                        '{"snd":"'+EscapeString(Messages[i].sender)+'",'+
                        '"rcv":"'+EscapeString(Messages[i].receiver)+'",'+
                        '"rcvnm":"'+EscapeString(Messages[i].receiverName)+'",'+
                        '"msg":"'+EscapeString(Messages[i].content)+'",'+
                        '"sjt":"'+EscapeString(Messages[i].subject)+'"}';

                if i < Length(Messages) - 1 then requestJson := requestJson + ',';
        end;
        requestJson := requestJson + ']';

        requestJson := requestJson + '}';

        responseJson := httppost('/' + GetEnumName(TypeInfo(EnumMessageType),integer(MessageType)) ,CorpNum,UserID,requestJson);

        result := getJsonString(responseJson,'receiptNum');

end;


function TMessagingService.SendMMS(CorpNum : String; sender : String; receiver : String; receiverName : String; subject : String; content : String; mmsfilepath : String; reserveDT : String; UserID : String) : String;
var
        Messages : TSendMessageList;
begin
        SetLength(Messages,1);

        Messages[0] := TSendMessage.Create;

        Messages[0].sender := sender;
        Messages[0].receiver := receiver;
        Messages[0].receiverName := receiverName;
        Messages[0].content := content;
        Messages[0].subject := subject;

        result := SendMMS(CorpNum, sender, subject, content, Messages, mmsfilepath, reserveDT, UserID);
end;

function TMessagingService.SendMMS(CorpNum : String; sender : String; subject : String; content : String; Messages : TSendMessageList;  mmsfilepath : String; reserveDT : String; UserID : String) : String;

var
        requestJson, responseJson : string;
        files : TFileList;
        i : Integer;
begin

        SetLength(files,1);

        files[0] := TFile.Create;
        files[0].FieldName := 'file';
        files[0].FileName := ExtractFileName(mmsfilepath);
        files[0].Data := TFileStream.Create(mmsfilepath,fmOpenRead);
 

        if Length(Messages) = 0 then raise EPopbillException.Create(-99999999,'전송할 메시지가 입력되지 않았습니다.');

        requestJson := '{';

        if sender <> ''          then requestJson := requestJson + '"snd":"' + EscapeString(sender) + '",';
        if content <> ''         then requestJson := requestJson + '"content":"' + EscapeString(content) + '",';
        if subject <> ''         then requestJson := requestJson + '"subject":"' + EscapeString(subject) + '",';
        if reserveDT <> ''       then requestJson := requestJson + '"sndDT":"' + EscapeString(reserveDT) + '",';

        requestJson := requestJson + '"msgs":[';
        for i := 0 to Length(Messages) - 1 do begin
                requestJson := requestJson +
                        '{"snd":"'+EscapeString(Messages[i].sender)+'",'+
                        '"rcv":"'+EscapeString(Messages[i].receiver)+'",'+
                        '"rcvnm":"'+EscapeString(Messages[i].receiverName)+'",'+
                        '"msg":"'+EscapeString(Messages[i].content)+'",'+
                        '"sjt":"'+EscapeString(Messages[i].subject)+'"}';

                if i < Length(Messages) - 1 then requestJson := requestJson + ',';
        end;
        requestJson := requestJson + ']';

        requestJson := requestJson + '}';

       try
                responseJson := httppost('/MMS',CorpNum,UserID,requestJson,files);
       finally
                for i:= 0 to Length(files) -1 do begin
                        files[i].Data.Free;
                end;
       end;

       result := getJSonString(responseJson,'receiptNum');
end;

function TMessagingService.SendSMS(CorpNum : String; sender : string ; receiver : string; receiverName : String; content : String; reserveDT : String; UserID : String) : String;
var
        Messages : TSendMessageList;
begin

        SetLength(Messages,1);

        Messages[0] := TSendMessage.Create;

        Messages[0].sender := sender;
        Messages[0].receiver := receiver;
        Messages[0].receiverName := receiverName;
        Messages[0].content := content;

        result := SendSMS(CorpNum,Messages,reserveDT,UserID);

end;

function TMessagingService.SendSMS(CorpNum : String; Messages : TSendMessageList; reserveDT : String; UserID : String) : String;
begin
        result:= SendSMS(CorpNum,'','',Messages,reserveDT,UserID);

end;

function TMessagingService.SendSMS(CorpNum : String; sender : string; content : string; Messages: TSendMessageList; reserveDT : String; UserID : String) : String;
begin
        result := SendMessage(SMS,CorpNum,sender,content,'',Messages,reserveDT,UserID);
end;

function TMessagingService.SendLMS(CorpNum : String; sender : string ; receiver : string; receiverName : String; subject : String; content : String; reserveDT : String; UserID : String) : String;
var
        Messages : TSendMessageList;
begin

        SetLength(Messages,1);

        Messages[0] := TSendMessage.Create;

        Messages[0].sender := sender;
        Messages[0].receiver := receiver;
        Messages[0].receiverName := receiverName;
        Messages[0].content := content;
        Messages[0].subject := subject;

        result := SendLMS(CorpNum,Messages,reserveDT,UserID);

end;

function TMessagingService.SendLMS(CorpNum : String; Messages : TSendMessageList; reserveDT : String; UserID : String) : String;
begin
        result:= SendLMS(CorpNum,'','','',Messages,reserveDT,UserID);

end;

function TMessagingService.SendLMS(CorpNum : String; sender : string; subject : String; content : string; Messages: TSendMessageList; reserveDT : String; UserID : String) : String;
begin
        result := SendMessage(LMS,CorpNum,sender,content,subject,Messages,reserveDT,UserID);
end;

function TMessagingService.SendXMS(CorpNum : String; sender : string ; receiver : string; receiverName : String; subject : String; content : String; reserveDT : String; UserID : String) : String;
var
        Messages : TSendMessageList;
begin

        SetLength(Messages,1);

        Messages[0] := TSendMessage.Create;

        Messages[0].sender := sender;
        Messages[0].receiver := receiver;
        Messages[0].receiverName := receiverName;
        Messages[0].content := content;
        Messages[0].subject := subject;

        result := SendXMS(CorpNum,Messages,reserveDT,UserID);

end;

function TMessagingService.SendXMS(CorpNum : String; Messages : TSendMessageList; reserveDT : String; UserID : String) : String;
begin
        result:= SendXMS(CorpNum,'','','',Messages,reserveDT,UserID);

end;

function TMessagingService.SendXMS(CorpNum : String; sender : string; subject : String; content : string; Messages: TSendMessageList; reserveDT : String; UserID : String) : String;
begin
        result := SendMessage(XMS,CorpNum,sender,content,subject,Messages,reserveDT,UserID);
end;


function TMessagingService.GetMessages(CorpNum : String; receiptNum : string; UserID : String) :TSentMessageList;
var
        responseJson : String;
        jSons : ArrayOfString;
        i : Integer;
begin
        if receiptNum = '' then raise EPopbillException.Create(-99999999,'No ReceiptNum');

        responseJson := httpget('/Message/' + receiptNum,CorpNum,UserID);

        try
                jSons := ParseJsonList(responseJson);
                SetLength(result,Length(jSons));

                for i := 0 to Length(jSons)-1 do
                begin
                        result[i] := TSentMessage.Create;

                        result[i].state := getJSonInteger(jsons[i],'state');
                        result[i].subject := getJSonString(jsons[i],'subject');
                        result[i].messageType := EnumMessageTYpe(GetEnumValue(TypeInfo(EnumMessageTYpe),getJSonString(jsons[i],'type')));
                        result[i].content := getJSonString(jsons[i],'content');
                        result[i].sendNum := getJSonString(jsons[i],'sendNum');
                        result[i].receiveNum := getJSonString(jsons[i],'receiveNum');
                        result[i].receiveName := getJSonString(jsons[i],'receiveName');
                        result[i].reserveDT := getJSonString(jsons[i],'reserveDT');
                        result[i].sendDT := getJSonString(jsons[i],'sendDT');
                        result[i].resultDT := getJSonString(jsons[i],'resultDT');
                        result[i].sendResult := getJSonString(jsons[i],'sendResult');



                end;

        except on E:Exception do
                raise EPopbillException.Create(-99999999,'결과처리 실패.[Malformed Json]');
        end;

end;

function TMessagingService.CancelReserve(CorpNum : String; receiptNum : string; UserID : String) : TResponse;
var
        responseJson : String;
begin
         if receiptNum = '' then raise EPopbillException.Create(-99999999,'No ReceiptNum');

        responseJson := httpget('/Message/' + receiptNum + '/Cancel',CorpNum,UserID);

        result.code := getJSonInteger(responseJson,'code');
        result.message := getJSonString(responseJson,'message');
end;

function TMessagingService.getURL(CorpNum : String; UserID : String; TOGO : String) : String;
var
        responseJson : String;
begin
        responseJson := httpget('/Message/?TG=' + TOGO ,CorpNum,UserID);
        result := getJSonString(responseJson,'url');
end;
//End of Unit;
end.
