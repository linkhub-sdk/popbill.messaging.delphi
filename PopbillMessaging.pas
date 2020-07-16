(*
*=================================================================================
* Unit for base module for Popbill Messaging API SDK. Main functionality is to
* send Short Messaging To Cell phones. Also LMS and MMS.
*
* For strongly secured communications, this module uses SSL/TLS with OpenSSL.
*
* http://www.popbill.com
* Author : Kim Seongjun (pallet027@gmail.com)
* Written : 2014-04-01
* Contributor : Jeong Yohan (code@linkhub.co.kr)
* Updated : 2020-07-16
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

        TMessageChargeInfo = class
        public
                unitCost : string;
                chargeMethod : string;
                rateSystem : string;
        end;
        
        TSendMessage = class
        public
                sender          : string;
                senderName      : string;
                receiver        : string;
                receiverName    : string;
                content         : string;
                subject         : string;
        end;

        TSendMessageList = Array Of TSendMessage;



        TSentMessage = class
        public
                subject         : string;
                content         : string;
                sendNum         : string;
                senderName        : string;
                receiveNum      : string;
                receiveName     : string;
                receiptDT       : string;
                sendDT          : string;
                resultDT        : string;
                reserveDT       : string;
                state           : Integer;
                result          : Integer;
                messageType     : EnumMessageType;
                tranNet         : string;
                sendResult      : string;
                receiptNum      : String;
                requestNum      : String;
        end;

        TSentMessageList = Array of TSentMessage;

        TSearchList = class
        public
                code            : integer;
                total           : integer;
                perPage         : integer;
                pageNum         : integer;
                pageCount       : integer;
                list            : TSentMessageList;
                message         : string;
                destructor Destroy; override;
        end;

        TMSGSenderNumber = class
        public
                number : string;
                state : integer;
                representYN : Boolean;
                memo : string;
        end;

        TMSGSenderNumberList = Array of TMSGSenderNumber;

        TAutoDenyInfo = class
        public
                number  : string;
                regDT   : string;
        end;

        TAutoDenyList = Array Of TAutoDenyInfo;

        TSentMessageSummaryInfo = class
        public
                rNum : String;
                sn   : String;
                stat : String;
                rlt  : String;
                sDT  : String;
                rDT  : String;
                net  : String;
                srt  : String;
        end;

        TSentMessageSummaryInfoList = Array of TSentMessageSummaryInfo;

        TMessagingService = class(TPopbillBaseService)
        private
                function SendMessage(MessageType : EnumMessageType; CorpNum : String; sender : string; senderName : string; content : string; subject : string; Messages: TSendMessageList; reserveDT : String; adsYN : Boolean; UserID : String; requestNum : String) : String;
                function jsonToSentMessageInfo(json : String) : TSentMessageSummaryInfo;
        public
                constructor Create(LinkID : String; SecretKey : String);

                //회원별 전송 단가 확인.
                function GetUnitCost(CorpNum : String; MsgType:EnumMessageType) : Single;

                //SMS 관련함수.
                function SendSMS(CorpNum : String; sender : string; receiver : string; receiverName : String; content : String; reserveDT : String; adsYN : Boolean; UserID : String =''; requestNum : String = '' ) : String; overload;
                function SendSMS(CorpNum : String; sender : string; senderName : string; receiver : string; receiverName : String; content : String; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String; overload;
                function SendSMS(CorpNum : String; sender : string; content : string; Messages: TSendMessageList; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String; overload;
                function SendSMS(CorpNum : String; sender : string; senderName : string; content : string; Messages: TSendMessageList; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String; overload;
                function SendSMS(CorpNum : String; Messages : TSendMessageList; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String; overload;

                //LMS 관련함수.
                function SendLMS(CorpNum : String; sender : string ; receiver : string; receiverName : String; subject : String; content : String; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String; overload;
                function SendLMS(CorpNum : String; sender : string ; senderName : string; receiver : string; receiverName : String; subject : String; content : String; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String; overload;
                function SendLMS(CorpNum : String; sender : String; subject : String; content : string; Messages: TSendMessageList; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String; overload;
                function SendLMS(CorpNum : String; sender : String; senderName : String; subject : String; content : string; Messages: TSendMessageList; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String; overload;
                function SendLMS(CorpNum : String; Messages : TSendMessageList; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String; overload;

                //XMS 관련함수.
                function SendXMS(CorpNum : String; sender : string; receiver : string; receiverName : String; subject : String; content : String; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String; overload;
                function SendXMS(CorpNum : String; sender : string; senderName : string; receiver : string; receiverName : String; subject : String; content : String; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String; overload;
                function SendXMS(CorpNum : String; sender : String; subject : String; content : string; Messages: TSendMessageList; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String; overload;
                function SendXMS(CorpNum : String; sender : String; senderName : String; subject : String; content : string; Messages: TSendMessageList; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String; overload;
                function SendXMS(CorpNum : String; Messages : TSendMessageList; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String; overload;

                //MMS 관련함수.
                function SendMMS(CorpNum : String; sender : String; receiver : String; receiverName : String; subject : String; content : String; mmsfilepath : String; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String; overload;
                function SendMMS(CorpNum : String; sender : String; senderName: String;receiver : String; receiverName : String; subject : String; content : String; mmsfilepath : String; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String; overload;
                function SendMMS(CorpNum : String; sender : String; subject : String; content : String; Messages : TSendMessageList;  mmsfilepath : String; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String; overload;

                //메시지 상세내역 및 전송상태 확인.
                function GetMessages(CorpNum : String; receiptNum : string; UserID : String = '') :TSentMessageList;

                //전송요청번호 할당된 메시지 상세내역 및 전송상태 확인.
                function GetMessagesRN(CorpNum : String; requestNum : String; UserID : String = '') :TSentMessageList;

                //예약전송 메시지 취소
                function CancelReserve(CorpNum : String; receiptNum : string; UserID : String = '') : TResponse;

                //전송 요청번호 할당된 예약전송 메시지 취소
                function CancelReserveRN(CorpNum : String; requestNum : String; UserID : String = '') : TResponse;

                //메시지 전송결과 검색조회
                function Search(CorpNum : String; SDate : String; EDate : String; State : Array Of String; Item : Array Of String; ReserveYN : boolean; SenderYN : boolean; Page : Integer; PerPage : Integer; Order : String; UserID : String = '') :TSearchList; overload;
                function Search(CorpNum : String; SDate : String; EDate : String; State : Array Of String; Item : Array Of String; ReserveYN : boolean; SenderYN : boolean; Page : Integer; PerPage : Integer; Order : String; QString : String; UserID : String) :TSearchList; overload;

                //문자관련 연결 url.
                function GetURL(CorpNum : String; TOGO : String ) : String; overload;

                //문자관련 연결 url.
                function GetURL(CorpNum : String; UserID : String; TOGO : String ) : String; overload;

                //문자 전송내역  url.
                function GetSentListURL(CorpNum : String; UserID : String) : String;

                //문자 발신번호 관리 url.
                function GetSenderNumberMgtURL(CorpNum : String; UserID : String) : String;

                //080 수신거부목록 확인
                function GetAutoDenyList(CorpNum : String) : TAutoDenyList;

                //과금정보 확인
                function GetChargeInfo(CorpNum :String; MsgType:EnumMessageType) : TMessageChargeInfo;


                // 발신번호 목록 조회
                function GetSenderNumberList(CorpNum : String; UserID : String = '') : TMSGSenderNumberList;

                // 전송내역 요약정보 확인
                function GetStates(CorpNum : String; receiptNumList : Array of String; UserID : String = '') : TSentMessageSummaryInfoList;

        end;
implementation
destructor TSearchList.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(list)-1 do
    if Assigned(list[I]) then
      list[I].Free;
  SetLength(list, 0);
  inherited Destroy;
end;

constructor TMessagingService.Create(LinkID : String; SecretKey : String);
begin
       inherited Create(LinkID,SecretKey);
       AddScope('150');
       AddScope('151');
       AddScope('152');
end;
function BoolToStr(b:Boolean):String;
begin 
    if b = true then BoolToStr:='True'; 
    if b = false then BoolToStr:='False'; 
end;

function TMessagingService.GetChargeInfo(CorpNum : string; MsgType:EnumMessageType) : TMessageChargeInfo;
var
        responseJson : String;
begin
        try
                responseJson := httpget('/Message/ChargeInfo?Type='+ GetEnumName(TypeInfo(EnumMessageType),integer(MsgType)),CorpNum,'');
        except
                on le : EPopbillException do begin
                        if FIsThrowException then
                        begin
                                raise EPopbillException.Create(le.code, le.message);
                                exit;
                        end;                        
                end;
        end;

        try
                result := TMessageChargeInfo.Create;

                result.unitCost := getJSonString(responseJson, 'unitCost');
                result.chargeMethod := getJSonString(responseJson, 'chargeMethod');
                result.rateSystem := getJSonString(responseJson, 'rateSystem');

        except on E:Exception do
                if FIsThrowException then
                begin
                        raise EPopbillException.Create(-99999999,'결과처리 실패.[Malformed Json]');
                        exit;
                end
                else
                begin
                        result := TMessageChargeInfo.Create();
                        setLastErrCode(-99999999);
                        setLastErrMessage('결과처리 실패.[Malformed Json]');
                        exit;
                end;
        end;
end;

function TMessagingService.GetUnitCost(CorpNum : String; MsgType:EnumMessageType) : Single;
var
        responseJson : string;
begin

        try
                responseJson := httpget('/Message/UnitCost?Type=' + GetEnumName(TypeInfo(EnumMessageType),integer(MsgType)),CorpNum,'');

        except
                on le : EPopbillException do begin
                        if FIsThrowException then
                        begin
                                raise EPopbillException.Create(le.code,le.message);
                                exit;
                        end
                        else
                        begin
                                result := 0.0;
                                exit;
                        end;
                end;
        end;

        if LastErrCode <> 0 then
        begin
                exit;
        end
        else
        begin
                result := strToFloat(getJSonString( responseJson,'unitCost'));
                exit;
        end;
        
end;

function TMessagingService.SendMessage(MessageType : EnumMessageType; CorpNum : String; sender : string; senderName : string ; content : string; subject : string; Messages: TSendMessageList; reserveDT : String; adsYN : Boolean; UserID : String; requestNum : String) : String;
var
        requestJson, responseJson : string;
        i : Integer;
begin

        if Length(Messages) = 0 then
        begin
                if FIsThrowException then
                begin
                        raise EPopbillException.Create(-99999999,'전송할 메시지가 입력되지 않았습니다.');
                        exit;
                end
                else
                begin
                        result := '';
                        setLastErrCode(-99999999);
                        setLastErrMessage('전송할 메시지가 입력되지 않았습니다.');        
                end;
        end;

        requestJson := '{';

        if adsYN then
        requestJson := requestJson + '"adsYN":true,';

        if sender <> ''          then requestJson := requestJson + '"snd":"' + EscapeString(sender) + '",';
        if senderName <> ''      then requestJson := requestJson + '"sndnm":"' + EscapeString(senderName) + '",';
        if content <> ''         then requestJson := requestJson + '"content":"' + EscapeString(content) + '",';
        if subject <> ''         then requestJson := requestJson + '"subject":"' + EscapeString(subject) + '",';
        if reserveDT <> ''       then requestJson := requestJson + '"sndDT":"' + EscapeString(reserveDT) + '",';
        if requestNum <> ''      then requestJson := requestJson + '"requestNum":"' + EscapeString(requestNum) + '",';

        requestJson := requestJson + '"msgs":[';
        for i := 0 to Length(Messages) - 1 do begin
                requestJson := requestJson +
                        '{"snd":"'+EscapeString(Messages[i].sender)+'",'+
                        '"sndnm":"'+EscapeString(Messages[i].senderName)+'",'+
                        '"rcv":"'+EscapeString(Messages[i].receiver)+'",'+
                        '"rcvnm":"'+EscapeString(Messages[i].receiverName)+'",'+
                        '"msg":"'+EscapeString(Messages[i].content)+'",'+
                        '"sjt":"'+EscapeString(Messages[i].subject)+'"}';

                if i < Length(Messages) - 1 then requestJson := requestJson + ',';
        end;
        requestJson := requestJson + ']';

        requestJson := requestJson + '}';

        try
                responseJson := httppost('/' + GetEnumName(TypeInfo(EnumMessageType),integer(MessageType)) ,CorpNum,UserID,requestJson);
                result := getJsonString(responseJson,'receiptNum');
        except
                on le : EPopbillException do begin
                        if FIsThrowException then
                        begin
                                raise EPopbillException.Create(le.code,le.message);
                                exit;
                        end;
                end;
        end;
end;

function TMessagingService.SendMMS(CorpNum : String; sender : String; senderName : string; receiver : String; receiverName : String; subject : String; content : String; mmsfilepath : String; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String;
var
        Messages : TSendMessageList;
begin
        SetLength(Messages,1);

        Messages[0] := TSendMessage.Create;

        Messages[0].sender := sender;
        Messages[0].senderName := senderName;
        Messages[0].receiver := receiver;
        Messages[0].receiverName := receiverName;
        Messages[0].content := content;
        Messages[0].subject := subject;

        result := SendMMS(CorpNum,sender,subject,content,Messages,mmsfilepath,reserveDT,adsYN,UserID,requestNum);
end;

function TMessagingService.SendMMS(CorpNum : String; sender : String; receiver : String; receiverName : String; subject : String; content : String; mmsfilepath : String; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String;
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

        result := SendMMS(CorpNum,sender,subject,content,Messages,mmsfilepath,reserveDT,adsYN,UserID,requestNum);
end;

function TMessagingService.SendMMS(CorpNum : String; sender : String; subject : String; content : String; Messages : TSendMessageList;  mmsfilepath : String; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String;

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

        if Length(Messages) = 0 then
        begin
                if FIsThrowException then
                begin
                        raise EPopbillException.Create(-99999999,'전송할 메시지가 입력되지 않았습니다.');
                        exit;
                end
                else
                begin
                        result := '';
                        setLastErrCode(-99999999);
                        setLastErrMessage('전송할 메시지가 입력되지 않았습니다.');        
                end;
        end;        

        requestJson := '{';

        if sender <> ''          then requestJson := requestJson + '"snd":"' + EscapeString(sender) + '",';
        if content <> ''         then requestJson := requestJson + '"content":"' + EscapeString(content) + '",';
        if subject <> ''         then requestJson := requestJson + '"subject":"' + EscapeString(subject) + '",';
        if reserveDT <> ''       then requestJson := requestJson + '"sndDT":"' + EscapeString(reserveDT) + '",';
        if requestNum <> ''      then requestJson := requestJson + '"requestNum":"' + EscapeString(requestNum) + '",';

        requestJson := requestJson + '"msgs":[';
        for i := 0 to Length(Messages) - 1 do begin
                requestJson := requestJson +
                        '{"snd":"'+EscapeString(Messages[i].sender)+'",'+
                        '"sndnm":"'+EscapeString(Messages[i].senderName)+'",'+
                        '"rcv":"'+EscapeString(Messages[i].receiver)+'",'+
                        '"rcvnm":"'+EscapeString(Messages[i].receiverName)+'",'+
                        '"msg":"'+EscapeString(Messages[i].content)+'",'+
                        '"sjt":"'+EscapeString(Messages[i].subject)+'"}';

                if i < Length(Messages) - 1 then requestJson := requestJson + ',';
        end;
        requestJson := requestJson + ']';

        requestJson := requestJson + '}';

        try
               try
                        responseJson := httppost('/MMS',CorpNum,UserID,requestJson,files);
                        result := getJSonString(responseJson,'receiptNum');
               except
                        on le : EPopbillException do begin
                                if FIsThrowException then
                                begin
                                        raise EPopbillException.Create(le.code, le.message);
                                        exit;
                                end;
                        end;
               end;
       finally
                for i:= 0 to Length(files) -1 do begin
                        files[i].Data.Free;
                end;
       end;
end;

function TMessagingService.SendSMS(CorpNum : String; sender : string ; receiver : string; receiverName : String; content : String; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String;
var
        Messages : TSendMessageList;
begin

        SetLength(Messages,1);

        Messages[0] := TSendMessage.Create;

        Messages[0].sender := sender;
        Messages[0].receiver := receiver;
        Messages[0].receiverName := receiverName;
        Messages[0].content := content;

        result := SendSMS(CorpNum,Messages,reserveDT,adsYN,UserID,requestNum);

end;


function TMessagingService.SendSMS(CorpNum : String; sender : string ; senderName : string; receiver : string; receiverName : String; content : String; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String;
var
        Messages : TSendMessageList;
begin

        SetLength(Messages,1);

        Messages[0] := TSendMessage.Create;

        Messages[0].sender := sender;
        Messages[0].senderName := senderName;
        Messages[0].receiver := receiver;
        Messages[0].receiverName := receiverName;
        Messages[0].content := content;

        result := SendSMS(CorpNum,Messages,reserveDT,adsYN,UserID,requestNum);

end;

function TMessagingService.SendSMS(CorpNum : String; Messages : TSendMessageList; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String;
begin
        result:= SendSMS(CorpNum,'','',Messages,reserveDT,adsYN,UserID,requestNum);

end;

function TMessagingService.SendSMS(CorpNum : String; sender : string; content : string; Messages: TSendMessageList; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String;
begin
        result := SendMessage(SMS,CorpNum,sender, '', content,'',Messages,reserveDT,adsYN,UserID,requestNum);
end;

function TMessagingService.SendSMS(CorpNum : String; sender : string; senderName: string; content : string; Messages: TSendMessageList; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String;
begin
        result := SendMessage(SMS,CorpNum,sender, senderName, content,'',Messages,reserveDT,adsYN,UserID,requestNum);
end;

function TMessagingService.SendLMS(CorpNum : String; sender : string ; receiver : string; receiverName : String; subject : String; content : String; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String;
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

        result := SendLMS(CorpNum,Messages,reserveDT,adsYN,UserID,requestNum);
end;

function TMessagingService.SendLMS(CorpNum : String; sender : string ; senderName : string; receiver : string; receiverName : String; subject : String; content : String; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String;
var
        Messages : TSendMessageList;
begin

        SetLength(Messages,1);

        Messages[0] := TSendMessage.Create;

        Messages[0].sender := sender;
        Messages[0].senderName := senderName;
        Messages[0].receiver := receiver;
        Messages[0].receiverName := receiverName;
        Messages[0].content := content;
        Messages[0].subject := subject;

        result := SendLMS(CorpNum,Messages,reserveDT,adsYN,UserID,requestNum);
end;

function TMessagingService.SendLMS(CorpNum : String; Messages : TSendMessageList; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String;
begin
        result:= SendLMS(CorpNum,'','','',Messages,reserveDT,adsYN,UserID,requestNum);

end;

function TMessagingService.SendLMS(CorpNum : String; sender : string; subject : String; content : string; Messages: TSendMessageList; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String;
begin
        result := SendMessage(LMS,CorpNum,sender, '', content,subject,Messages,reserveDT,adsYN,UserID,requestNum);
end;

function TMessagingService.SendLMS(CorpNum : String; sender : string; senderName : string; subject : String; content : string; Messages: TSendMessageList; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String;
begin
        result := SendMessage(LMS,CorpNum,sender, senderName, content,subject,Messages,reserveDT,adsYN,UserID,requestNum);
end;


function TMessagingService.SendXMS(CorpNum : String; sender : string ; receiver : string; receiverName : String; subject : String; content : String; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String;
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

        result := SendXMS(CorpNum,Messages,reserveDT,adsYN,UserID,requestNum);
end;

function TMessagingService.SendXMS(CorpNum : String; sender : string ; senderName : string; receiver : string; receiverName : String; subject : String; content : String; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String;
var
        Messages : TSendMessageList;
begin

        SetLength(Messages,1);

        Messages[0] := TSendMessage.Create;

        Messages[0].sender := sender;
        Messages[0].senderName := senderName;
        Messages[0].receiver := receiver;
        Messages[0].receiverName := receiverName;
        Messages[0].content := content;
        Messages[0].subject := subject;

        result := SendXMS(CorpNum,Messages,reserveDT,adsYN,UserID,requestNum);

end;

function TMessagingService.SendXMS(CorpNum : String; Messages : TSendMessageList; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String;
begin
        result:= SendXMS(CorpNum,'','','',Messages,reserveDT,adsYN,UserID,requestNum);
end;

function TMessagingService.SendXMS(CorpNum : String; sender : string; subject : String; content : string; Messages: TSendMessageList; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String;
begin
        result := SendMessage(XMS,CorpNum,sender,'', content,subject,Messages,reserveDT, adsYN,UserID,requestNum);
end;

function TMessagingService.SendXMS(CorpNum : String; sender : string; senderName : string; subject : String; content : string; Messages: TSendMessageList; reserveDT : String; adsYN : Boolean; UserID : String = ''; requestNum : String = '') : String;
begin
        result := SendMessage(XMS,CorpNum,sender,senderName,content,subject,Messages,reserveDT,adsYN,UserID,requestNum);
end;

function TMessagingService.GetMessages(CorpNum : String; receiptNum : string; UserID : String = '') :TSentMessageList;
var
        responseJson : String;
        jSons : ArrayOfString;
        i : Integer;
begin
        if receiptNum = '' then
        begin
                if FIsThrowException then
                begin
                        raise EPopbillException.Create(-99999999,'접수번호(ReceiptNum)가 입력되지 않았습니다.');
                        exit;
                end
                else
                begin
                        SetLength(result, 0);
                        setLastErrCode(-99999999);
                        setLastErrMessage('접수번호(ReceiptNum)가 입력되지 않았습니다.');
                        exit;
                end;
        end;

        try
                responseJson := httpget('/Message/' + receiptNum,CorpNum,UserID);
        except
                on le : EPopbillException do begin
                        if FIsThrowException then
                        begin
                                raise EPopbillException.Create(le.code, le.message);
                                exit;
                        end
                        else
                        begin
                                SetLength(result, 0);
                                exit;
                        end;
                end;
        end;


        if LastErrCode <> 0 then
        begin
                exit;
        end
        else
        begin
                try
                        jSons := ParseJsonList(responseJson);
                        SetLength(result,Length(jSons));

                        for i := 0 to Length(jSons)-1 do
                        begin
                                result[i] := TSentMessage.Create;

                        result[i].state := getJSonInteger(jsons[i],'state');
                        result[i].result := getJSonInteger(jsons[i],'result');
                        result[i].subject := getJSonString(jsons[i],'subject');
                        result[i].messageType := EnumMessageTYpe(GetEnumValue(TypeInfo(EnumMessageTYpe),getJSonString(jsons[i],'type')));
                        result[i].content := getJSonString(jsons[i],'content');
                        result[i].sendNum := getJSonString(jsons[i],'sendNum');
                        result[i].senderName := getJSonString(jsons[i],'senderName');
                        result[i].receiveNum := getJSonString(jsons[i],'receiveNum');
                        result[i].receiveName := getJSonString(jsons[i],'receiveName');
                        result[i].reserveDT := getJSonString(jsons[i],'reserveDT');
                        result[i].receiptDT := getJSonString(jsons[i],'receiptDT');
                        result[i].sendDT := getJSonString(jsons[i],'sendDT');
                        result[i].resultDT := getJSonString(jsons[i],'resultDT');
                        result[i].sendResult := getJSonString(jsons[i],'sendResult');
                        result[i].tranNet := getJSonString(jsons[i],'tranNet');
                        result[i].receiptNum := getJSonString(jsons[i],'receiptNum');
                        result[i].requestNum := getJSonString(jsons[i],'requestNum');
                end;

        except on E:Exception do begin
                if FIsThrowException then
                begin
                        raise EPopbillException.Create(-99999999,'결과처리 실패.[Malformed Json]');
                end
                else
                begin
                        SetLength(result, 0);
                        setLastErrCode(-99999999);
                        setLastErrMessage('결과처리 실패.[Malformed Json]');
                        exit;
                end;

                end;
        end;
        end;


end;

function TMessagingService.CancelReserve(CorpNum : String; receiptNum : string; UserID : String = '') : TResponse;
var
        responseJson : String;
begin
        if receiptNum = '' then
        begin
                if FIsThrowException then
                begin
                        raise EPopbillException.Create(-99999999,'접수번호(ReceiptNum)가 입력되지 않았습니다.');
                        exit;
                end
                else
                begin
                        result.code := -99999999;
                        result.message := '접수번호(ReceiptNum)가 입력되지 않았습니다.';
                        exit; 
                end;
        end;
                
        try
                responseJson := httpget('/Message/' + receiptNum + '/Cancel',CorpNum,UserID);
        except
                on le : EPopbillException do begin
                        if FIsThrowException then
                        begin
                                raise EPopbillException.Create(le.code,le.Message);
                                exit;
                        end
                        else
                        begin
                                result.code := le.code;
                                result.message := le.Message;
                                exit;
                        end;
                end;
        end;

        if LastErrCode <> 0 then
        begin
                result.code := LastErrCode;
                result.message := LastErrMessage;
        end
        else
        begin
                result.code := getJSonInteger(responseJson,'code');
                result.message := getJSonString(responseJson,'message');
        end;
end;

function TMessagingService.getURL(CorpNum : String; TOGO : String) : String;
begin
         result := getURL(CorpNum, '', TOGO);
end;

function TMessagingService.getURL(CorpNum : String; UserID : String; TOGO : String) : String;
var
        responseJson : String;
begin
        try
                responseJson := httpget('/Message/?TG=' + TOGO ,CorpNum,UserID);
                result := getJSonString(responseJson,'url');
        except
                on le : EPopbillException do begin
                        if FIsThrowException then
                        begin
                                raise EPopbillException.Create(le.code, le.message);
                                exit;
                        end;
                end;
        end;
end;


function TMessagingService.GetSentListURL(CorpNum : String; UserID : String) : String;
var
        responseJson : String;
begin
        try
                responseJson := httpget('/Message/?TG=BOX' ,CorpNum,UserID);
                result := getJSonString(responseJson,'url');
        except
                on le : EPopbillException do begin
                        if FIsThrowException then
                        begin
                                raise EPopbillException.Create(le.code, le.message);
                                exit;
                        end;
                end;
        end;
end;

function TMessagingService.GetSenderNumberMgtURL(CorpNum : String; UserID : String) : String;
var
        responseJson : String;
begin
        try
                responseJson := httpget('/Message/?TG=SENDER' ,CorpNum,UserID);
                result := getJSonString(responseJson,'url');
        except
                on le : EPopbillException do begin
                        if FIsThrowException then
                        begin
                                raise EPopbillException.Create(le.code, le.message);
                                exit;
                        end;
                end;
        end;
end;



function UrlEncodeUTF8(stInput : widestring) : string;
  const
    hex : array[0..255] of string = (
     '%00', '%01', '%02', '%03', '%04', '%05', '%06', '%07',
     '%08', '%09', '%0a', '%0b', '%0c', '%0d', '%0e', '%0f',
     '%10', '%11', '%12', '%13', '%14', '%15', '%16', '%17',
     '%18', '%19', '%1a', '%1b', '%1c', '%1d', '%1e', '%1f',
     '%20', '%21', '%22', '%23', '%24', '%25', '%26', '%27',
     '%28', '%29', '%2a', '%2b', '%2c', '%2d', '%2e', '%2f',
     '%30', '%31', '%32', '%33', '%34', '%35', '%36', '%37',
     '%38', '%39', '%3a', '%3b', '%3c', '%3d', '%3e', '%3f',
     '%40', '%41', '%42', '%43', '%44', '%45', '%46', '%47',
     '%48', '%49', '%4a', '%4b', '%4c', '%4d', '%4e', '%4f',
     '%50', '%51', '%52', '%53', '%54', '%55', '%56', '%57',
     '%58', '%59', '%5a', '%5b', '%5c', '%5d', '%5e', '%5f',
     '%60', '%61', '%62', '%63', '%64', '%65', '%66', '%67',
     '%68', '%69', '%6a', '%6b', '%6c', '%6d', '%6e', '%6f',
     '%70', '%71', '%72', '%73', '%74', '%75', '%76', '%77',
     '%78', '%79', '%7a', '%7b', '%7c', '%7d', '%7e', '%7f',
     '%80', '%81', '%82', '%83', '%84', '%85', '%86', '%87',
     '%88', '%89', '%8a', '%8b', '%8c', '%8d', '%8e', '%8f',
     '%90', '%91', '%92', '%93', '%94', '%95', '%96', '%97',
     '%98', '%99', '%9a', '%9b', '%9c', '%9d', '%9e', '%9f',
     '%a0', '%a1', '%a2', '%a3', '%a4', '%a5', '%a6', '%a7',
     '%a8', '%a9', '%aa', '%ab', '%ac', '%ad', '%ae', '%af',
     '%b0', '%b1', '%b2', '%b3', '%b4', '%b5', '%b6', '%b7',
     '%b8', '%b9', '%ba', '%bb', '%bc', '%bd', '%be', '%bf',
     '%c0', '%c1', '%c2', '%c3', '%c4', '%c5', '%c6', '%c7',
     '%c8', '%c9', '%ca', '%cb', '%cc', '%cd', '%ce', '%cf',
     '%d0', '%d1', '%d2', '%d3', '%d4', '%d5', '%d6', '%d7',
     '%d8', '%d9', '%da', '%db', '%dc', '%dd', '%de', '%df',
     '%e0', '%e1', '%e2', '%e3', '%e4', '%e5', '%e6', '%e7',
     '%e8', '%e9', '%ea', '%eb', '%ec', '%ed', '%ee', '%ef',
     '%f0', '%f1', '%f2', '%f3', '%f4', '%f5', '%f6', '%f7',
     '%f8', '%f9', '%fa', '%fb', '%fc', '%fd', '%fe', '%ff');
 var
   iLen,iIndex : integer;
   stEncoded : string;
   ch : widechar;
 begin
   iLen := Length(stInput);
   stEncoded := '';
   for iIndex := 1 to iLen do
   begin
     ch := stInput[iIndex];
     if (ch >= 'A') and (ch <= 'Z') then
       stEncoded := stEncoded + ch
     else if (ch >= 'a') and (ch <= 'z') then
       stEncoded := stEncoded + ch
     else if (ch >= '0') and (ch <= '9') then
       stEncoded := stEncoded + ch
     else if (ch = ' ') then
       stEncoded := stEncoded + '+'
     else if ((ch = '-') or (ch = '_') or (ch = '.') or (ch = '!') or (ch = '*')
       or (ch = '~') or (ch = '\')  or (ch = '(') or (ch = ')')) then
       stEncoded := stEncoded + ch
     else if (Ord(ch) <= $07F) then
       stEncoded := stEncoded + hex[Ord(ch)]
     else if (Ord(ch) <= $7FF) then
     begin
        stEncoded := stEncoded + hex[$c0 or (Ord(ch) shr 6)];
        stEncoded := stEncoded + hex[$80 or (Ord(ch) and $3F)];
     end
     else
     begin
        stEncoded := stEncoded + hex[$e0 or (Ord(ch) shr 12)];
        stEncoded := stEncoded + hex[$80 or ((Ord(ch) shr 6) and ($3F))];
        stEncoded := stEncoded + hex[$80 or ((Ord(ch)) and ($3F))];
     end;
   end;
   result := (stEncoded);
 end;

function TMessagingService.search(CorpNum : String; SDate : String; EDate : String; State : Array Of String; Item : Array Of String; ReserveYN : boolean; SenderYN : boolean; Page : Integer; PerPage : Integer; Order : String; UserID : String = '') :TSearchList;
begin
        result := Search(CorpNum, SDate, EDate, State, Item, ReserveYN, SenderYN, Page, PerPage, Order, '', UserID);
end;

function TMessagingService.Search(CorpNum, SDate, EDate: String; State, Item: array of String; ReserveYN, SenderYN: boolean; Page, PerPage: Integer; Order, QString, UserID: String): TSearchList;
var
        responseJson : String;
        uri : String;
        StateList : String;
        ItemList: String;
        jSons : ArrayOfString;
        i : Integer;
begin
        for i := 0 to High(State) do
        begin
                if State[i] <> '' Then
                StateList := StateList + State[i] +',';
        end;
        
        for i := 0 to High(Item) do
        begin
                if Item[i] <> '' Then
                ItemList := ItemList + Item[i] +',';
        end;

        uri := '/Message/Search?SDate='+SDate+'&&EDate='+EDate;
        uri := uri + '&&State='+ StateList;
        uri := uri + '&&Item=' + ItemList;

        if Page < 1 then Page := 1;
        uri := uri + '&&Page=' + IntToStr(Page);
        uri := uri + '&&PerPage=' + IntToSTr(PerPage);

        if ReserveYN Then uri := uri + '&&ReserveYN=1'
        else uri := uri + '&&ReserveYN=0';

        if SenderYN Then uri := uri + '&&SenderYN=1'
        else uri := uri + '&&SenderYN=0';

        uri := uri + '&&Order=' + Order;

        if QString <> '' then uri := uri + '&&QString=' + UrlEncodeUTF8(QString);


        try
                responseJson := httpget(uri,CorpNum,UserID);
        except
                on le : EPopbillException do begin
                        if FIsThrowException then
                        begin
                                raise EPopbillException.Create(le.code, le.message);
                                exit;
                        end
                        else
                        begin
                                result := TSearchList.Create;
                                result.code := le.code;
                                result.message := le.message;
                                exit;
                        end;
                end;
        end;

        if LastErrCode <> 0 then
        begin
                result := TSearchList.Create;
                result.code := LastErrCode;
                result.message := LastErrMessage;
                exit;
        end
        else
        begin

        result := TSearchList.Create;

        result.code             := getJSonInteger(responseJson,'code');
        result.total            := getJSonInteger(responseJson,'total');
        result.perPage          := getJSonInteger(responseJson,'perPage');
        result.pageNum          := getJSonInteger(responseJson,'pageNum');
        result.pageCount        := getJSonInteger(responseJson,'pageCount');
        result.message          := getJSonString(responseJson,'message');

        try
                jSons := getJSonList(responseJson,'list');
                SetLength(result.list, Length(jSons));
                for i:=0 to Length(jSons)-1 do
                begin
                        result.list[i] := TSentMessage.Create;

                        result.list[i].content          := getJSonString(jSons[i],'content');
                        result.list[i].sendNum          := getJSonString(jSons[i],'sendNum');
                        result.list[i].senderName       := getJSonString(jSons[i],'senderName');
                        result.list[i].subject          := getJSonString(jSons[i],'subject');
                        result.list[i].receiveNum       := getJSonString(jSons[i],'receiveNum');
                        result.list[i].receiveName      := getJSonString(jSons[i],'receiveName');
                        result.list[i].resultDT         := getJSonString(jSons[i],'resultDT');
                        result.list[i].receiptDT        := getJSonString(jSons[i],'receiptDT');
                        result.list[i].sendDT           := getJSonString(jSons[i],'sendDT');
                        result.list[i].reserveDT        := getJSonString(jSons[i],'reserveDT');
                        result.list[i].sendResult       := getJSonString(jSons[i],'sendResult');
                        result.list[i].tranNet          := getJSonString(jSons[i],'tranNet');
                        result.list[i].state            := getJSonInteger(jSons[i],'state');
                        result.list[i].result           := getJSonInteger(jSons[i],'result');
                        result.list[i].messageType      := EnumMessageTYpe(GetEnumValue(TypeInfo(EnumMessageTYpe),getJSonString(jsons[i],'type')));
                        result.list[i].receiptNum       := getJSonString(jSons[i],'receiptNum');
                        result.list[i].requestNum       := getJSonString(jSons[i],'requestNum');
                end;
        except on E:Exception do
                raise EPopbillException.Create(-99999999,'결과처리 실패.[Malformed Json]');
        end;
        end;
end;

function TMessagingService.GetAutoDenyList(CorpNum : string) : TAutoDenyList;
var
        responseJson : String;
        jSons : ArrayOfString;
        i : Integer;
begin

        try
                responseJson := httpget('/Message/Denied',CorpNum, '');
        except
                on le : EPopbillException do begin
                        if FIsThrowException then
                        begin
                                raise EPopbillException.Create(le.code, le.message);
                                exit;
                        end;
                end;
        end;

        if LastErrCode <> 0 then
        begin
                exit;
        end
        else
        begin
        
                try
                        jSons := ParseJsonList(responseJson);
                        SetLength(result,Length(jSons));

                        for i:= 0 to Length(jSons)-1 do
                        begin
                                result[i] := TAutoDenyInfo.Create;
                                result[i].number := getJsonString(jSons[i],'number');
                                result[i].regDT := getJsonString(jSons[i],'regDT');

                        end;
                except
                        on E:Exception do begin
                                if FIsThrowException then
                                begin
                                        raise EPopbillException.Create(-99999999,'결과처리 실패.[Malformed Json]');
                                        exit;
                                end
                                else
                                begin
                                        SetLength(result,0);
                                        SetLength(jSons,0);
                                        setLastErrCode(-99999999);
                                        setLastErrMessage('결과처리 실패.[Malformed Json]');
                                        exit;
                                end;
                        end;
                end;
        end;
end;


function TMessagingService.GetSenderNumberList(CorpNum : string; UserID: String) : TMSGSenderNumberList;
var
        responseJson : String;
        jSons : ArrayOfString;
        i : Integer;
begin

        try        
                responseJson := httpget('/Message/SenderNumber',CorpNum, UserID);
        except
                on le : EPopbillException do begin
                        if FIsThrowException then
                        begin
                                raise EPopbillException.Create(le.code, le.message);
                                exit;
                        end
                        else
                        begin
                                SetLength(result,0);
                                exit;
                        end;
                end;
        end;

        if LastErrCode <> 0 then
        begin
                exit;
        end
        else
        begin
        
        try
                jSons := ParseJsonList(responseJson);
                SetLength(result,Length(jSons));

                for i:= 0 to Length(jSons)-1 do
                begin
                        result[i] := TMSGSenderNumber.Create;
                        result[i].number := getJsonString(jSons[i],'number');
                        result[i].memo := getJsonString(jSons[i],'memo');
                        result[i].state := getJsonInteger(jSons[i],'state');
                        result[i].representYN := getJsonBoolean(jSons[i],'representYN');
                end;
        except
                on E:Exception do begin
                        if FIsThrowException then
                        begin
                                raise EPopbillException.Create(-99999999,'결과처리 실패. [Malformed Json]');
                                exit;
                        end
                        else
                        begin
                                SetLength(result, 0);
                                SetLength(jSons, 0);
                                setLastErrCode(-99999999);
                                setLastErrMessage('결과처리 실패. [Malformed Json]');
                                exit;
                        end;
                end;        
        end;
        end;
end;

function TMessagingService.CancelReserveRN(CorpNum, requestNum, UserID: String): TResponse;
var
        responseJson : String;
begin
        if requestNum = '' then
        begin
                if FIsThrowException then
                begin
                        raise EPopbillException.Create(-99999999,'요청번호(requestNum)가 입력되지 않았습니다.');
                        exit;
                end
                else
                begin
                        result.code := -99999999;
                        result.message := '요청번호(requestNum)가 입력되지 않았습니다.';
                        exit; 
                end;
        end;

        try
                responseJson := httpget('/Message/Cancel/' + requestNum ,CorpNum,UserID);
        except
                on le : EPopbillException do begin
                        if FIsThrowException then
                        begin
                                raise EPopbillException.Create(le.code,le.Message);
                                exit;
                        end
                        else
                        begin
                                result.code := le.code;
                                result.message := le.Message;
                                exit;
                        end;
                end;
        end;

        if LastErrCode <> 0 then
        begin
                result.code := LastErrCode;
                result.message := LastErrMessage;
                exit;
        end
        else
        begin
                result.code := getJSonInteger(responseJson,'code');
                result.message := getJSonString(responseJson,'message');
                exit;
        end;
end;

function TMessagingService.GetMessagesRN(CorpNum, requestNum, UserID: String): TSentMessageList;
var
        responseJson : String;
        jSons : ArrayOfString;
        i : Integer;
begin
        if requestNum = '' then
        begin
                if FIsThrowException then
                begin
                        raise EPopbillException.Create(-99999999,'요청번호(requestNum)가 입력되지 않았습니다.');
                        exit;
                end
                else
                begin
                        SetLength(result,0);
                        setLastErrCode(-99999999);
                        setLastErrMessage('요청번호(requestNum)가 입력되지 않았습니다.');
                        exit; 
                end;
        end;

        try
                responseJson := httpget('/Message/Get/' + requestNum ,CorpNum, UserID);
        except
                on le : EPopbillException do begin
                        if FIsThrowException then
                        begin
                                raise EPopbillException.Create(le.code,le.message);
                                exit;
                        end;
                end;
        end;

        if LastErrCode <> 0 then
        begin
                exit;
        end
        else
        begin

        try
                jSons := ParseJsonList(responseJson);
                SetLength(result,Length(jSons));

                for i := 0 to Length(jSons)-1 do
                begin
                        result[i] := TSentMessage.Create;

                        result[i].state := getJSonInteger(jsons[i],'state');
                        result[i].result := getJSonInteger(jsons[i],'result');
                        result[i].subject := getJSonString(jsons[i],'subject');
                        result[i].messageType := EnumMessageTYpe(GetEnumValue(TypeInfo(EnumMessageTYpe),getJSonString(jsons[i],'type')));
                        result[i].content := getJSonString(jsons[i],'content');
                        result[i].sendNum := getJSonString(jsons[i],'sendNum');
                        result[i].senderName := getJSonString(jsons[i],'senderName');
                        result[i].receiveNum := getJSonString(jsons[i],'receiveNum');
                        result[i].receiveName := getJSonString(jsons[i],'receiveName');
                        result[i].reserveDT := getJSonString(jsons[i],'reserveDT');
                        result[i].receiptDT := getJSonString(jsons[i],'receiptDT');
                        result[i].sendDT := getJSonString(jsons[i],'sendDT');
                        result[i].resultDT := getJSonString(jsons[i],'resultDT');
                        result[i].sendResult := getJSonString(jsons[i],'sendResult');
                        result[i].tranNet := getJSonString(jsons[i],'tranNet');
                        result[i].receiptNum := getJSonString(jsons[i],'receiptNum');
                        result[i].requestNum := getJSonString(jsons[i],'requestNum');
                end;

        except
                on E:Exception do begin
                        if FIsThrowException then
                        begin
                                raise EPopbillException.Create(-99999999,'결과처리 실패.[Malformed Json]');
                        end
                        else
                        begin
                                SetLength(result,0);
                                SetLength(jSons,0);
                                setLastErrCode(-99999999);
                                setLastErrMessage('결과처리 실패.[Malformed Json]');
                                exit;
                        end;
                end
        end;
        end;
end;

function TMessagingService.GetStates(CorpNum: String; receiptNumList: array of String;
                                     UserID : String = ''): TSentMessageSummaryInfoList;
var
        requestJson : string;
        responseJson : string;
        jSons : ArrayOfString;
        i : Integer;
begin
        if Length(receiptNumList) = 0 then
        begin
                if FIsThrowException then
                begin
                        raise EPopbillException.Create(-99999999,'접수번호가 입력되지 않았습니다.');
                        Exit;               
                end
                else
                begin
                        SetLength(result,0);
                        setLastErrCode(-99999999);
                        setLastErrMessage('접수번호가 입력되지 않았습니다.');
                        exit;
                end;
        end;

        requestJson := '[';
        for i:=0 to Length(receiptNumList) -1 do
        begin
                requestJson := requestJson + '"' + receiptNumList[i] + '"';
                if (i + 1) < Length(receiptNumList) then requestJson := requestJson + ',';
        end;

        requestJson := requestJson + ']';

        try
                responseJson := httppost('/Message/States',CorpNum,UserID,requestJson);
        except
                on le : EPopbillException do begin
                        if FIsThrowException then
                        begin
                                raise EPopbillException.Create(le.code, le.message);
                                Exit;               
                        end;
                end;
        end;

        if LastErrCode <> 0 then
        begin
                exit;
        end
        else
        begin
                try
                        jSons := ParseJsonList(responseJson);
                        SetLength(result,Length(jSons));

                        for i := 0 to Length(jSons)-1 do
                        begin
                                result[i] := jsonToSentMessageInfo(jSons[i]);
                        end;

                except
                        on E:Exception do begin
                                if FIsThrowException then
                                begin
                                        raise EPopbillException.Create(-99999999,'결과처리 실패.[Malformed Json]');
                                        exit;
                                end
                                else
                                begin
                                        SetLength(result,0);
                                        SetLength(jSons,0);
                                        setLastErrCode(-99999999);
                                        setLastErrMessage('결과처리 실패.[Malformed Json]');
                                        exit;
                                end;
                        end;
                end;
        end;

end;

function TMessagingService.jsonToSentMessageInfo(json: String): TSentMessageSummaryInfo;
begin
        result      := TSentMessageSummaryInfo.create;

        result.rNum := getJSonString(json, 'rNum');
        result.sn   := IntToStr(getJSonInteger(json, 'sn'));
        result.stat := IntToStr(getJSonInteger(json, 'stat'));
        result.rlt  := IntToStr(getJSonInteger(json, 'rlt'));
        result.sDT  := getJSonString(json, 'sDT');
        result.rDT  := getJSonString(json, 'rDT');
        result.net  := getJSonString(json, 'net');
        result.srt  := getJSonString(json, 'srt');
end;

//End of Unit;
end.


