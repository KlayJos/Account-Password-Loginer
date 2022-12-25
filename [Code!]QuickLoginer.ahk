#NoEnv ;新脚本必备
#Persistent ;持续运行
#NoTrayIcon ;不显示托盘图标。
#SingleInstance FORCE ;禁止多开，替换旧版
#InstallKeybdHook ;强制无条件安装键盘钩子。
SetBatchLines -1 ;脚本全速运行
StringCaseSense, On ;字符比较区分大小写
SetStoreCapslockMode, Off ;搭配Send{CapsLock}，CapsLock键则不受*影响，可正常切换
CoordMode, Mouse, Screen ;鼠标活动坐标相对于屏幕
SetDefaultMouseSpeed, 0 ;鼠标活动没有指定移动速度时的默认速度
SetTitleMatchMode, Fast ;窗口/控件名称快速匹配
;Suspend, On

if not A_IsAdmin{  ;以管理员权限运行
	Run *RunAs "%A_ScriptFullPath%"
	ExitApp
}

Gui, +OwnDialogs
Gui, Color, cF0F0F0 NA
Global Version:=1.0
Global theBB:="Alpha" Version
Global newBB:="定制版"


;ini数据文件操作设置-开始1
Global FileName:=A_ScriptDir "\APLoginer.ini"  ;文件名称
  Global 1帐号:=0
  Global 1密码:=0
  Global 2帐号:=0
  Global 2密码:=0
  Global 3帐号:=0
  Global 3密码:=0
  Global 自动回车:=0
;ini数据文件操作设置-结束1

;gosub, ini_DataRead
gosub, 生成Renew
gosub, 生成About
gosub, 生成主窗口

;生成菜单窗口-开始
生成Renew:
	Gui, Menu_Renew:Default
	Gui, +HwndMenu_Renew_ID
	Gui, Menu_Renew:Add, Text,cADADAD x5 y5 Left +BackgroundTrans, 版本：%theBB%
	Gui, Menu_Renew:Add, Text, cBlue x10 y20 +BackgroundTrans,〖更新详情〗
	Gui, Menu_Renew:Add, Edit, ReadOnly cBlue x10 y35 w180 h300 Left,无更多内容。
	Gui, Menu_Renew:Add, Text, cRed x200 y20 +BackgroundTrans,〖感谢名单〗
	Gui, Menu_Renew:Add, Edit, ReadOnly cRed x200 y35 w180 h300 Left,无更多内容。
	Gui, Menu_Renew:Add, Link, vjiaqun cBlue x10 y340, ·最后更新时间：无更多内容。    ·客服：<a href="Mailto:KlayJos3@gmail.com">KlayJos3@gmail.com</a>
	GuiControl, Menu_Renew:Focus, jiaqun
	Gui, Menu_Renew:Show, Hide w390 h360, 更新日志
return

生成About:
	Gui, Menu_About:Default
	Gui, +HwndMenu_About_ID
	Gui, Menu_About:Add, Text,cADADAD x5 y5 Left +BackgroundTrans, 版本：%theBB%
	Gui, Menu_About:Add, Text,cADADAD x20 y25 Center +BackgroundTrans, Jos 版权所有
	Gui, Menu_About:Show, Hide w300 h50, 关于
return

Menu_Instruc:  ;公告
  MsgBox, % 0+262144,客服：KlayJos3@gmail.com,% "[最新公告] `n   无更多内容。"
  /*
	Gui, Main:+OwnDialogs
	MsgBox, % 4+64+262144,客服：KlayJos3@gmail.com,说明不存在。`n`n是否通过E-mail联络客服？
	IfMsgBox Yes
	run, http://Mailto:KlayJos3@gmail.com
  */
return

Menu_Renew:  ;更新日志

	;WinSet, Disable , ahk_id %MAIN_ID%
	Gui, Menu_Renew:Show, Restore NA
	;WinSet AlwaysOnTop, On, ahk_id %Menu_Renew_ID%
	;Gui, Main:Show, Hide NA
	WinWaitClose, ahk_id %Menu_Renew_ID%
		;WinSet AlwaysOnTop, Off, ahk_id %Menu_Renew_ID%
		;WinSet, Enable, ahk_id %Menu_Renew_ID%
		Gui, Main:Show, Restore NA
		;Gui, Menu_Renew:Show, Hide
return

Menu_About:  ;关于

	;WinSet, Disable, ahk_id %MAIN_ID%
	Gui, Menu_About:Show, Restore NA
	;WinSet AlwaysOnTop, On, ahk_id %Menu_About_ID%
	;Gui, Main:Show, Hide
	WinWaitClose, ahk_id %Menu_About_ID%
		;WinSet AlwaysOnTop, Off, ahk_id %Menu_About_ID%
		;WinSet, Enable, ahk_id %MAIN_ID%
		Gui, Main:Show, Restore NA
		;Gui, Menu_About:Show, Hide
return
;生成菜单窗口-结束


/*
CheckUpdate:  ;检查更新
CheckUpdate:=WinHttp.Download("https://raw.githubusercontent.com/KlayJos/R6Tooler/main/CheckUpdate", "Timeout:30")
StringReplace, CheckUpdate, CheckUpdate, %A_SPACE%,, ALL ;替换
StringReplace, CheckUpdate, CheckUpdate, `n,, ALL ;替换
StringSplit, CheckUpdate_Array, CheckUpdate,|
Hint:=WinHttp.Download("https://raw.githubusercontent.com/KlayJos/R6Tooler/main/Hint", "Timeout:30")
New_Version:=CheckUpdate_Array2
New_Download:=CheckUpdate_Array3
if(New_Version=="404:NotFound")
  New_Version:="ERROR"
if(New_Download=="404:NotFound")
  New_Download:="ERROR"
if(Hint=="404:NotFound")
  Hint:="ERROR"
  if(WinHttp.StatusCode!=200 and (StrLen(New_Version)==0 or New_Version=="ERROR" or New_Version=="404:NotFound") and Version!="-1"){
    MsgBox,% 0+16+262144,% "客服：KlayJos3@gmail.com",% "检查更新时出错，请检查网络后重试，或联络客服。`n最新版本: " New_Version "`n当前版本: " Version "`n`n[最新公告] `n" Hint "`n[更新方式] `n" New_Download
    ExitApp
  }else if(not(Version >= New_Version) and Version!="-1"){  ;-1管理模式(无视更新)
      MsgBox,% 4+48+262144,% "客服：KlayJos3@gmail.com",% CheckUpdate "已发现新版本[" New_Version "]，是否立即更新？`n最新版本: " New_Version "`n当前版本: " Version "`n`n[最新公告] `n" Hint "`n[更新方式] `n" New_Download
    IfMsgBox Yes
      run, %New_Download%
    else
      ExitApp
  }
return
*/



;ini数据文件操作-开始2
/*判断文件是否存在：
if ! FileExist(FileName){  ;文件不存在，创建文件。
	MsgBox, DataFile不存在，将创建并写入测试文本。
	DataFile:=FileOpen(FileName, "rw")  ;开启指定文件，如不存在将创建文件。
	TestString := "This is a test string.`r`n"  ; 通过这种方式写入内容到文件时, 要使用 `r`n 而不是 `n 来开始新行.
	DataFile.Write(TestString)
	DataFile.Close()
}
*/
ini_DefaultWrite:  ;写入默认数据
Gui, Main:Submit, NoHide ;刷新Gui
	;OutputDebug, `nNowMode=%NowMode%
	IniDelete, %FileName%, Data-%NowMode%
	IniWrite, 1, %FileName%, Data-%NowMode%, DefualtData
	IniWrite, % "<Data" NowMode ">", %FileName%, Data-%NowMode%, ModeName
	;※默认数据：
	IniWrite, %1帐号%, %FileName%, Data-%NowMode%, Account1
	IniWrite, %2帐号%, %FileName%, Data-%NowMode%, Account2
	IniWrite, %1密码%, %FileName%, Data-%NowMode%, Password1
	IniWrite, %2密码%, %FileName%, Data-%NowMode%, Password2
  IniWrite, %自动回车%, %FileName%, Data-%NowMode%, AutoEnter
	IniWrite,·, %FileName%, Data-%NowMode%,·  ;分割行
	IniRead, ModeRange, %FileName%, Set, ModeRange  ;重新读取
	IniRead, NowMode, %FileName%, Set, NowMode  ;重新读取
	IniRead, DefualtData, %FileName%, Data-%NowMode%, DefualtData  ;重新读取
return

ini_DataRead:  ;判断是否为首次执行,并读取指定NowMode的数据
Gui, Main:Submit, NoHide ;刷新Gui
	IniRead, ModeRange, %FileName%, Set, ModeRange  ;Mode的快捷键的范围。1:1~10, 2:11~20, 3:21~30, 4:31~40, 5:41~50, ...
	IniRead, NowMode, %FileName%, Set, NowMode  ;NowMode_Len=0:首次运行；NowMode=1~10:数据
	IniRead, DefualtData, %FileName%, Data-%NowMode%, DefualtData  ;DefualtData_Len=0:首次运行；DefualtMode=1:默认数据，=0:自订数据
	;OutputDebug, `nNowMode=%NowMode%
	;ModeSetv_Len:=StrLen(ModeSetv)
	;OutputDebug, `nModeSetv=%ModeSetv%(Len:%ModeSetv_Len%)`nNowMode=%NowMode%(Len:%NowMode_Len%)`nDefualtData=%DefualtData%(Len:%DefualtData_Len%)
	if((StrLen(ModeSetv)!=0 and StrLen(ModeSetv)!=5) and (StrLen(DefualtData)==0 or StrLen(DefualtData)==5)){  ;手动选择模式首次，写入默认数据。
			;OutputDebug, `n<手动选择模式首次>
				;OutputDebug, `n<首次手动选择模式,写入默认数据>
				;MsgBox % "1:  "ModeSetv "(" StrLen(ModeSetv) ")" DefualtData "(" StrLen(DefualtData) ")"
				gosub, ini_DefaultWrite
	}else if(StrLen(NowMode)==0 or StrLen(NowMode)==5 or StrLen(ModeRange)==0 or StrLen(ModeRange)==5){  ;首次运行程序或该模式，写入默认数据。
		;OutputDebug, `n<首次运行程序或该模式>
		;MsgBox % "2:  "NowMode "(" StrLen(NowMode) ")" ModeRange "(" StrLen(ModeRange) ")"
		Global NowMode:=1
		Global ModeRange:=1
		IniWrite, %ModeRange%, %FileName%, Set, ModeRange
		IniWrite, %NowMode%, %FileName%, Set, NowMode
		IniWrite,·, %FileName%, Set,·  ;分割行
		gosub, ini_DefaultWrite
	}

	;OutputDebug, `n<非首次运行>
	IniRead, ModeName, %FileName%, Data-%NowMode%, ModeName
	IniRead, Account1, %FileName%, Data-%NowMode%, Account1
	IniRead, Account2, %FileName%, Data-%NowMode%, Account2
	IniRead, Password1, %FileName%, Data-%NowMode%, Password1
	IniRead, Password2, %FileName%, Data-%NowMode%, Password2
  IniRead, AutoEnter, %FileName%, Data-%NowMode%, AutoEnter

	;如果读取为空，则替换为0：
	if(StrLen(Account1)==0 or Account1=="ERROR"){
    IniWrite, 0, %FileName%, Data-%NowMode%, Account1
		Global Account1:=0
  }
	if(StrLen(Account2)==0 or Account2=="ERROR"){
    IniWrite, 0, %FileName%, Data-%NowMode%, Account2
		Global Account2:=0
  }
	if(StrLen(Password1)==0 or Password1=="ERROR"){
    IniWrite, 0, %FileName%, Data-%NowMode%, Password1
		Global Password1:=0
  }
	if(StrLen(Password2)==0 or Password2=="ERROR"){
    IniWrite, 0, %FileName%, Data-%NowMode%, Password2
		Global Password2:=0
  }
  if(StrLen(AutoEnter)==0 or AutoEnter=="ERROR"){
    IniWrite, 0, %FileName%, Data-%NowMode%, AutoEnter
		Global AutoEnter:=0
  }
  

	;GuiControl, Main:Disable,vSaveSet
	;OutputDebug, `nNowMode=%NowMode%
	Global HumanTouch:=0
	GuiControl, Main:Choose, KeyRangev,%ModeRange%
	GuiControl, Main:Choose, ModeSetv,%NowMode%
	GuiControl, Main:, ModeNamev,%ModeName%
	GuiControl, Main:, ED1,%Account1%
	GuiControl, Main:, ED2,%Account2%
	GuiControl, Main:, ED3,%Password1%
	GuiControl, Main:, ED4,%Password2%
  GuiControl, Main:, EnterIO,%AutoEnter%
	WinSleep(500) ;Windows系统自带Delay
	Global HumanTouch:=1

	if(StrLen(NowMode)==0 and StrLen(NowMode)==5){
		Global NowHit:="[Data读取错误]"
	}else{
		Global NowHit:= "[" NowMode "]"
	}
	;DefualtData_Len:=StrLen(DefualtData)
	;OutputDebug, `nDefualtData=%DefualtData%(Len:%DefualtData_Len%)
	ifName:= "<Data" NowMode ">"
	if(Account1!=1帐号 or Account2!=2帐号 or Password1!=1密码 or Password2!=2密码 or EnterIO==AutoEnter or ModeNamev!=ifName){ ;与默认数据不相同，非默认数据。
		Global NowHit:= "Custom" NowHit
		GuiControl, Main:Enable,vCancelSet
	}else if(StrLen(DefualtData)==0 or StrLen(DefualtData)==5){
		Global NowHit:= "×Error" NowHit
		GuiControl, Main:Disable,vCancelSet
	}else{
		Global NowHit:= "※Default" NowHit
		GuiControl, Main:Disable,vCancelSet
	}
	Gui, Main:Font, cBlack
	GuiControl, Main:Font, DataHit
	GuiControl, Main:, DataHit,%NowHit%
  
	GuiControl, Main:Disable,vSaveSet
  GuiControl, Main:Disable,vCancelSet
return


CopyData:  ;复制按钮被按下
	Gui, Main:Submit, NoHide ;刷新Gui
	ClipBoard:="【帐密登录器】｀" NowMode "｀" ModeNamev "｀" ED1 "｀" ED2 "｀" ED3 "｀" ED4 "｀" EnterIO
	Gui, Main:Font, cGreen
	GuiControl, Main:Font, DataHit
	GuiControl, Main:, DataHit,% "[" NowMode "]复制成功!"
	GuiControl, Main:Focus, ModeSetv
	WinSleep(1000) ;Windows系统自带Delay
	Gui, Main:Font, cBlack
	GuiControl, Main:Font, DataHit
	GuiControl, Main:, DataHit,%NowHit%
return

PasteData:  ;粘贴按钮被按下
	Gui, Main:Submit, NoHide ;刷新Gui
	StringSplit, Paste_Array, ClipBoard,｀  ;以｀为分隔符，分割读取剪辑板中的文字。
	if(Paste_Array1=="【帐密登录器】"){
		Global HumanTouch:=0
		GuiControl, Main:, ModeNamev,%Paste_Array3%
		GuiControl, Main:, ED1,%Paste_Array4%
		GuiControl, Main:, ED2,%Paste_Array5%
		GuiControl, Main:, ED3,%Paste_Array6%
		GuiControl, Main:, ED4,%Paste_Array7%
    GuiControl, Main:, EnterIO,%Paste_Array8%
		WinSleep(500) ;Windows系统自带Delay
		Global HumanTouch:=1
		Gui, Main:Font, cGreen
		GuiControl, Main:Font, DataHit
		GuiControl, Main:, DataHit,% "[" NowMode "]粘贴成功!"
		GuiControl, Main:Focus, ModeSetv
		WinSleep(1000) ;Windows系统自带Delay
		Gui, Main:Font, cBlack
		GuiControl, Main:Font, DataHit
		GuiControl, Main:, DataHit,%NowHit%变更
    GuiControl, Main:Enable,vSaveSet
    GuiControl, Main:Enable,vCancelSet
	}else{
		Gui, Main:Font, cRed
		GuiControl, Main:Font, DataHit
		GuiControl, Main:, DataHit,% "[" NowMode "]粘贴失败!"
		GuiControl, Main:Focus, ModeSetv
		WinSleep(1000) ;Windows系统自带Delay
		Gui, Main:Font, cBlack
		GuiControl, Main:Font, DataHit
		GuiControl, Main:, DataHit,%NowHit%
	}
return

SaveSet:  ;保存按钮被按下
GuiControl, Main:Disable,ModeSetv
GuiControl, Main:Disable,ModeNamev
GuiControl, Main:Disable,KeyRangev
GuiControl, Main:Disable,ED1
GuiControl, Main:Disable,ED2
GuiControl, Main:Disable,ED3
GuiControl, Main:Disable,ED4
GuiControl, Main:Disable,EnterIO
Gui, Main:Submit, NoHide ;刷新Gui
	Gui, Main:Font, cGray
	GuiControl, Main:Font, DataHit
	GuiControl, Main:, DataHit,% "[" NowMode "]保存中···"
	;如果写入为空，则替换为0。
  StringReplace, ModeNamev, ModeNamev,|,/, ALL ;替换全部|为空
	if(StrLen(ED1)==0)
		Global ED1:=0
	if(StrLen(ED3)==0)
		Global ED3:=0
	if(StrLen(ED2)==0)
		Global ED2:=0
	if(StrLen(ED4)==0)
		Global ED4:=0
  if(StrLen(EnterIO)==0)
		Global EnterIO:=0

	;写入数据：
	ifName:= "<Data" NowMode ">"
	if(ED1==1帐号 and ED2==2帐号 and ED3==1密码 and ED4==2密码 and EnterIO==AutoEnter and ModeNamev==ifName){ ;与默认数据相同，直接还原。
		gosub, ini_DefaultWrite
		gosub,List_Refresh
		gosub, ini_DataRead
	}else{
		IniWrite, 0, %FileName%, Data-%NowMode%, DefualtData
		IniWrite, %ModeNamev%, %FileName%, Data-%NowMode%, ModeName
		IniWrite, %ED1%, %FileName%, Data-%NowMode%, Account1
		IniWrite, %ED2%, %FileName%, Data-%NowMode%, Account2
		IniWrite, %ED3%, %FileName%, Data-%NowMode%, Password1
		IniWrite, %ED4%, %FileName%, Data-%NowMode%, Password2
    IniWrite, %EnterIO%, %FileName%, Data-%NowMode%, AutoEnter
		gosub,List_Refresh
		gosub, ini_DataRead
	}
	GuiControl, Main:Disable,vSaveSet
  GuiControl, Main:Disable,vCancelSet
	Gui, Main:Font, cGreen
	GuiControl, Main:Font, DataHit
	GuiControl, Main:, DataHit,% "[" NowMode "]保存成功!"
	;SoundBeep, 2000, 200
	WinSleep(1000) ;Windows系统自带Delay
	Gui, Main:Font, cBlack
	GuiControl, Main:Font, DataHit
	GuiControl, Main:, DataHit,%NowHit%
GuiControl, Main:Enable,ED1
GuiControl, Main:Enable,ED2
GuiControl, Main:Enable,ED3
GuiControl, Main:Enable,ED4
GuiControl, Main:Enable,EnterIO
GuiControl, Main:Enable,ModeNamev
GuiControl, Main:Enable,KeyRangev
GuiControl, Main:Enable,ModeSetv
GuiControl, Focus,ModeSetv
return

CancelSet:  ;取消按钮被按下
GuiControl, Main:Disable,ModeSetv
GuiControl, Main:Disable,vSaveSet
GuiControl, Main:Disable,vCancelSet
Gui, Main:Submit, NoHide ;刷新Gui
	Gui, Main:Font, cGray
	GuiControl, Main:Font, DataHit
	GuiControl, Main:, DataHit,% "[" NowMode "]取消中···"
	GuiControl, Main:, ModeNamev,% "<Data" NowMode ">"
  
  gosub, ini_DataRead

	Gui, Main:Font, cGray
	GuiControl, Main:Font, DataHit
	GuiControl, Main:, DataHit,% "[" NowMode "]取消完成!"
	WinSleep(500) ;Windows系统自带Delay
	Gui, Main:Font, cBlack
	GuiControl, Main:Font, DataHit
	GuiControl, Main:, DataHit,%NowHit%
GuiControl, Main:Enable,ModeSetv
GuiControl, Focus,ModeSetv
return

ModeNameg:  ;名称被修改
Gui, Main:Submit, NoHide ;刷新Gui
	GuiControlGet,ModeNameg
	if(HumanTouch!=0){
		Gui, Main:Font, cGray
		GuiControl, Main:Font, DataHit
		GuiControl, Main:, DataHit,%NowHit%变更
		GuiControl, Main:Enable,vSaveSet
    GuiControl, Main:Enable,vCancelSet
	}
return

ModeSetg:  ;NowMode被重新选择
GuiControl, Main:Disable,ModeSetv
Gui, Main:Submit, NoHide ;刷新Gui
	;OutputDebug,`nModeSetv=%ModeSetv%
	IniWrite, %ModeSetv%, %FileName%, Set, NowMode
	;GuiControl, Main:Enable,vSaveSet

	ModeSet_To_KeyRange:=Ceil(ModeSetv/10)
	;MsgBox %ModeSet_To_KeyRange%
	GuiControl, Main:Choose, KeyRangev,%ModeSet_To_KeyRange%
	IniWrite, %ModeSet_To_KeyRange%, %FileName%, Set, ModeRange

	gosub, ini_DataRead
  ;SoundBeep, 2000, 100
GuiControl, Main:Enable,ModeSetv
GuiControl, Focus,ModeSetv
return

KeyRangeg:  ;ModeRange被重新选择
GuiControl, Main:Disable,KeyRangev
Gui, Main:Submit, NoHide ;刷新Gui
	;OutputDebug,`nKeyRangev=%KeyRangev%
	IniWrite, %KeyRangev%, %FileName%, Set, ModeRange
	;GuiControl, Main:Enable,vSaveSet

	if(SubStr(NowMode,0,1)==0)
		S_NowMode:=10
		else
		S_NowMode:=SubStr(NowMode,0,1)
	Local_KeyRangev:=(KeyRangev-1)*10+S_NowMode  ;从"右边"(0)开始取个字符开始，往后取"1"个字符。
	GuiControl, Main:Choose, ModeSetv,%Local_KeyRangev%
	IniWrite, %Local_KeyRangev%, %FileName%, Set, NowMode
  
	gosub, ini_DataRead
	;Switch_Mode((ModeRange-1)*10+1)
  ;SoundBeep, 2000, 100
GuiControl, Main:Enable,KeyRangev
GuiControl, Focus,KeyRangev
return

ED_all:
Gui, Main:Submit, NoHide ;刷新Gui
	GuiControlGet,ED1
  GuiControlGet,ED3
  GuiControlGet,ED2
  GuiControlGet,ED4
  GuiControlGet,EnterIO
	if(HumanTouch!=0){
		Gui, Main:Font, cGray
		GuiControl, Main:Font, DataHit
		GuiControl, Main:, DataHit,%NowHit%变更
		GuiControl, Main:Enable,vSaveSet
    GuiControl, Main:Enable,vCancelSet
	}
return

是否置顶:
	Gui, Main:Submit, NoHide ;刷新Gui
	GuiControlGet, SFZD
	If(SFZD==1){
		WinSet AlwaysOnTop, On, ahk_id %MAIN_ID%
	}else
		WinSet AlwaysOnTop, Off, ahk_id %MAIN_ID%
return

DeleteInputEdit:  ;清空按钮被按下
  GuiControl, Main:,ED1,
  GuiControl, Main:,ED2,
  GuiControl, Main:,ED3,
  GuiControl, Main:,ED4,
  GuiControl, Main:,EnterIO,0
	GuiControl, Main:Focus,ED1
return


CloseScreen:
	SendMessage, 0x112, 0xF170, 2,, Program Manager  ;息屏指令
return


*Numpad1::
  SetCapsLockState, Off
  StringReplace, theText, ED1, `n,, ALL ;替换全部换行为
  Input80bit(theText)
  Send {Tab Down}{Tab Up}
  StringReplace, theText, ED3, `n,, ALL ;替换全部换行为
  Input80bit(theText)
  if(EnterIO==1){
  Send {Enter Down}{Enter Up}
  }
  SoundBeep, 2000, 200
return

*Numpad2::
  SetCapsLockState, Off
  StringReplace, theText, ED2, `n,, ALL ;替换全部换行为
  Input80bit(theText)
  Send {Tab Down}{Tab Up}
  StringReplace, theText, ED4, `n,, ALL ;替换全部换行为
  Input80bit(theText)
  if(EnterIO==1){
  Send {Enter Down}{Enter Up}
  }
  SoundBeep, 2000, 200
return

*Numpad4::
  SetCapsLockState, Off
  StringReplace, theText, ED3, `n,, ALL ;替换全部换行为
  Input80bit(theText)
  if(EnterIO==1){
  Send {Enter Down}{Enter Up}
  }
  SoundBeep, 2000, 200
return

*Numpad5::
  SetCapsLockState, Off
  StringReplace, theText, ED4, `n,, ALL ;替换全部换行为
  Input80bit(theText)
  if(EnterIO==1){
  Send {Enter Down}{Enter Up}
  }
  SoundBeep, 2000, 200
return

*Numpad0::
  SoundBeep, 500, 200
  ExitApp
return

生成主窗口:
	Gui, Main:Default
	Gui, +HwndMAIN_ID
	;Gui, Main:Font,, Microsoft YaHei UI ;设置字体
	Gui, Main:Add, Text,cADADAD x5 y5 Left +BackgroundTrans, 版本：%theBB%
	Gui, Main:Add, CheckBox, cGreen vSFZD g是否置顶 x250 y5, 置顶
  Gui, Main:Add, button, x250 y30 w38 gDeleteInputEdit,清空
  Gui, Main:Add, button, x250 y80 w38 gCloseScreen,息屏
	Gui, Main:Add, Text, c0080FF x16 y28 Right +BackgroundTrans, 1帐号：
	Gui, Main:Add, Edit, cBlack vED1 gED_all x62 y24 w180 Disabled,
	GuiControlGet, ED1
	Gui, Main:Add, Text, c0080FF x16 y48 Right +BackgroundTrans, 1密码：
	Gui, Main:Add, Edit, cBlack vED3 gED_all x62 y49 w180 Disabled,
	GuiControlGet, ED3
  
  Gui, Main:Add, Text, c0080FF x16 y80 Right +BackgroundTrans, 2帐号：
	Gui, Main:Add, Edit, cBlack vED2 gED_all x62 y81 w180 Disabled,
	GuiControlGet, ED2
	Gui, Main:Add, Text, c0080FF x16 y105 Right +BackgroundTrans, 2密码：
	Gui, Main:Add, Edit, cBlack vED4 gED_all x62 y106 w180 Disabled,
	GuiControlGet, ED4
  Gui, Main:Add, CheckBox, cBlack vEnterIO gED_all x80 y135,自动Enter
	Gui, Main:Add, Text,cBlue x0 y165 Left +BackgroundTrans, ·[帐密登录器]Num 1:1帐密|2:2帐密|4:1密|5:2密|0:关闭

	Gui, Main:Add, Text, cBlack Right x165 y190 +BackgroundTrans, Key Range：
	Gui, Main:Add, DropDownList,cBlack vKeyRangev gKeyRangeg x230 y187 w70 Left AltSubmit Choose0 Disabled,1~10|11~20|21~30|31~40|41~50|51~60|61~70|71~80|81~90|91~100
  ;|151~160|161~170|171~180|181~190|191~200
	Gui, Main:Add, DropDownList,cBlack vModeSetv gModeSetg x160 y207 w140 Left AltSubmit Choose0 Disabled,1|2|3|4|5|6|7|8|9|0|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59|60|61|62|63|64|65|66|67|68|69|70|71|72|73|74|75|76|77|78|79|80|81|82|83|84|85|86|87|88|89|90|91|92|93|94|95|96|97|98|99|00
	;Gui, Main:Add, ComboBox, vNameSetv x215 y105 w45 Left Choose1, Red|Green
	Gui, Main:Add, Edit, cBlack vModeNamev gModeNameg x160 y227 w140 Disabled,
	Gui, Main:Add, Text, cBlack Center x130 y252 w200 vDataHit +BackgroundTrans,
	Gui, Main:Add, button, x192 y265 w38 w38 gCopyData,复制
	Gui, Main:Add, button, x230 y265 gPasteData,粘贴
	Gui, Main:Add, button, x170 y287 w60 vvSaveSet gSaveSet Disabled,保存修改
	Gui, Main:Add, button, x230 y287 w60 vvCancelSet gCancelSet Disabled,取消修改

	;Gui, Add, button, x85 y158 g开启, 返回游戏
	;`n·QQ：<a href="tencent://AddContact/?fromId=45&fromSubId=1&subcmd=all&uin=970610722">970610722</a>
	Gui, Main:Add, Link, cBlue x125 y319 Left,　[作者]　　　　`n·WeChat：<a href="微信ID：KlayJos">KlayJos</a>`n·Instagram：<a href="http://instagram.com/thej3">thej3</a>`n·E-mail：<a href="http://Mailto:KlayJos3@gmail.com">KlayJos3@gmail.com</a>
	Menu, TheMenu, Add, &×公告, Menu_Instruc
	Menu, TheMenu, Add, &☆更新日志, Menu_Renew
	Menu, TheMenu, Add, &$关于, Menu_About
	Gui, Main:Menu, TheMenu
  Random, RandomStart, 0.0-10241024.1024, 0.0+10241024.1024
	Gui, Main:Show, Restore w300 h375 x135 yCenter,帐密登录器 v%theBB% {%RandomStart%}
  WinSet, AlwaysOnTop, On, ahk_id %MAIN_ID% ;当前窗口置顶
  GuiControl,Main:, SFZD, 1
	Global GoListRefresh:=1
	gosub, List_Refresh
	Global GoListRefresh:=0
	gosub, ini_DataRead
	WinWaitClose, ahk_id %MAIN_ID%
		ExitApp
return



;Functions、Sub：

List_Refresh:  ;刷新列表
	if(ModeNamev!=ModeName or GoListRefresh!=0){
	GuiControl, Main:Disable,ModeSetv
	GuiControl, Main:Disable,ModeNamev
	GuiControl, Main:Disable,KeyRangev
	GuiControl, Main:Disable,ED1
	GuiControl, Main:Disable,ED3
	GuiControl, Main:Disable,ED2
	GuiControl, Main:Disable,ED4
  GuiControl, Main:Disable,EnterIO
	Gui, Main:Submit, NoHide ;刷新Gui
		List_i:=1
		While (List_i<=100){  ;刷新列表：1~100
			Control, Delete, 1, ComboBox2, ahk_id %MAIN_ID%
			IniRead, List_DefualtData, %FileName%, Data-%List_i%, DefualtData  ;DefualtData_Len=0:首次运行；DefualtMode=1:默认数据，=0:自订数据
			IniRead, List_ModeName, %FileName%, Data-%List_i%, ModeName
			if(StrLen(List_DefualtData)==0 or StrLen(List_DefualtData)==5 or List_DefualtData==1){
				List_DataHit:="※"
			}else{
				List_DataHit:=""
			}

			;if(List_i>=100)
				;MsgBox %List_i%
			if(StrLen(List_ModeName)==0 or List_ModeName=="ERROR"){
				GuiControl, Main:Text, ModeSetv,% List_DataHit "[" List_i "]<Data" List_i ">"
			}else{
				GuiControl, Main:Text, ModeSetv,% List_DataHit "[" List_i "]<" List_ModeName ">"
			}
			;GuiControl, Main:Choose, ModeSetv,1
      List_i+=1
		}
	GuiControl, Main:Enable,ED1
	GuiControl, Main:Enable,ED3
	GuiControl, Main:Enable,ED2
	GuiControl, Main:Enable,ED4
  GuiControl, Main:Enable,EnterIO
	GuiControl, Main:Enable,ModeNamev
	GuiControl, Main:Enable,KeyRangev
	GuiControl, Main:Enable,ModeSetv
	GuiControl, Focus,ModeSetv
	}
return

Switch_ModeRang(Local_ModeRange:=1){  ;Function: M键+1~0或数字键1~0切换范围：
Gui, Submit, NoHide ;刷新Gui
	GuiControl, Main:Choose, KeyRangev,%Local_ModeRange%
	gosub, KeyRangeg
	return
}

Switch_Mode(Local_Mode:=1){  ;Function: N键+1~0切换数据：
	;MsgBox % Local_Mode
Gui, Submit, NoHide ;刷新Gui
	;OutputDebug,Local_Mode=%Local_Mode%
	GuiControl, Main:Choose, ModeSetv,%Local_Mode%
	gosub, ModeSetg
	return
}

;中文输入-开始
Input80bit(theText){
  Gui, Main:Submit, NoHide ;刷新Gui

  StringReplace, theText, theText, %A_SPACE%, ｀, ALL ;替换全部空格
  StringReplace, theText, theText, ｀｀, ｀, ALL ;替换全部空格
  StringReplace, theText, theText, ｀｀, ｀, ALL ;替换全部空格
  StringReplace, theText, theText, ｀｀, ｀, ALL ;替换全部空格
  sleep, 10
  
  Loop_i:=1
  While (Loop_i<=100){ ;单次最多输入100个字符。
    StringMid, newText, theText, Loop_i, 1
    if(StrLen(newText)==0 or newText=="")  ;如果为空，则停止执行。
      break
    SpaceReplace(newText)
    sleep, 10
    Loop_i+=1
  }
}
SpaceReplace(newText){
  SwitchIME(0x04090409) ;调用英语(美国)-美式键盘
  if(newText="｀"){
    Send {Space Down}{Space Up}
  }else{
    SendInput {%newText%}
  }
}
;中文输入-结束

WinMouseMove_Absolute(x, y) {  ;Win绝对鼠标移动事件，比一般Move更稳定。
;---------------------------------------------------------------------------
; Absolute coords go from 0..65535 so we have to change to pixel coords
;-----------------------------------------------------------------------
  static SysX, SysY
  If (SysX = "")
    SysX := 65535//A_ScreenWidth, SysY := 65535//A_ScreenHeight
  DllCall("mouse_event", "UInt", 0x8001, "UInt", x*SysX, "UInt", y*SysY)
}

  ;========== 后台输入函数-开始 ==========
Class 后台{
  ;-- 类开始，使用类的命名空间可防止变量名、函数名污染
  获取控件句柄(WinTitle, Control="") {
    tmm:=A_TitleMatchMode, dhw:=A_DetectHiddenWindows
    SetTitleMatchMode, 2
    DetectHiddenWindows, On
    ControlGet, hwnd, Hwnd,, %Control%, %WinTitle%
    DetectHiddenWindows, %dhw%
    SetTitleMatchMode, %tmm%
    return, hwnd
  }
  点击左键(hwnd, x, y){  ;后台.点击左键(hwnd, x, y)
    return, this.Click_PostMessage(hwnd, x, y, "L")
  }
  点击右键(hwnd, x, y) {  ;后台.点击右键(hwnd, x, y)
    return, this.Click_PostMessage(hwnd, x, y, "R")
  }
  移动鼠标(hwnd, x, y) {  ;后台.移动鼠标(hwnd, x, y)
    return, this.Click_PostMessage(hwnd, x, y, 0)
  }
  Click_PostMessage(hwnd, x, y, flag="L") {
    static WM_MOUSEMOVE:=0x200
      , WM_LBUTTONDOWN:=0x201, WM_LBUTTONUP:=0x202
      , WM_RBUTTONDOWN:=0x204, WM_RBUTTONUP:=0x205
    ;---------------------
    VarSetCapacity(pt,16,0), DllCall("GetWindowRect", "ptr",hwnd, "ptr",&pt)
    , ScreenX:=x+NumGet(pt,"int"), ScreenY:=y+NumGet(pt,4,"int")
    Loop {
      NumPut(ScreenX,pt,"int"), NumPut(ScreenY,pt,4,"int")
      , DllCall("ScreenToClient", "ptr",hwnd, "ptr",&pt)
      , x:=NumGet(pt,"int"), y:=NumGet(pt,4,"int")
      , id:=DllCall("ChildWindowFromPoint", "ptr",hwnd, "int64",y<<32|x, "ptr")
      if (id=hwnd or !id)
        Break
      else hwnd:=id
    }
    ;---------------------
    if (flag=0)
      PostMessage, WM_MOUSEMOVE, 0, (y<<16)|x,, ahk_id %hwnd%
    else if InStr(flag,"L")=1
    {
      PostMessage, WM_LBUTTONDOWN, 0, (y<<16)|x,, ahk_id %hwnd%
      PostMessage, WM_LBUTTONUP, 0, (y<<16)|x,, ahk_id %hwnd%
    }
    else if InStr(flag,"R")=1
    {
      PostMessage, WM_RBUTTONDOWN, 0, (y<<16)|x,, ahk_id %hwnd%
      PostMessage, WM_RBUTTONUP, 0, (y<<16)|x,, ahk_id %hwnd%
    }
  }
  发送按键(hwnd, key) {  ;后台.发送按键(hwnd, key)
    static WM_KEYDOWN:=0x100, WM_KEYUP:=0x101
      , WM_SYSKEYDOWN:=0x104, WM_SYSKEYUP:=0x105, KEYEVENTF_KEYUP:=0x2
    Alt:=Ctrl:=Shift:=0
    if InStr(key,"!")
      Alt:=1, key:=StrReplace(key,"!")
    if InStr(key,"^")
    {
      Ctrl:=1, key:=StrReplace(key,"^")
      this.Send_keybd_event("Ctrl")
      Sleep, 100
    }
    if InStr(key,"+")
    {
      Shift:=1, key:=StrReplace(key,"+")
      this.Send_keybd_event("Shift")
      Sleep, 100
    }
    this.Send_PostMessage(hwnd, Alt=1 ? WM_SYSKEYDOWN : WM_KEYDOWN, key)
    Sleep, 100
    this.Send_PostMessage(hwnd, Alt=1 ? WM_SYSKEYUP : WM_KEYUP, key)
    if (Shift=1)
      this.Send_keybd_event("Shift", KEYEVENTF_KEYUP)
    if (Ctrl=1)
      this.Send_keybd_event("Ctrl", KEYEVENTF_KEYUP)
  }
  Send_PostMessage(hwnd, msg, key) {
    static WM_KEYDOWN:=0x100, WM_KEYUP:=0x101
      , WM_SYSKEYDOWN:=0x104, WM_SYSKEYUP:=0x105
    VK:=GetKeyVK(Key), SC:=GetKeySC(Key)
    flag:=msg=WM_KEYDOWN ? 0
      : msg=WM_KEYUP ? 0xC0
      : msg=WM_SYSKEYDOWN ? 0x20
      : msg=WM_SYSKEYUP ? 0xE0 : 0
    PostMessage, msg, VK, (count:=1)|(SC<<16)|(flag<<24),, ahk_id %hwnd%
  }
  Send_keybd_event(key, msg=0) {
    static KEYEVENTF_KEYUP:=0x2
    VK:=GetKeyVK(Key), SC:=GetKeySC(Key)
    DllCall("keybd_event", "int",VK, "int",SC, "int",msg, "int",0)
  }
}
  ;========== 后台输入函数-结束 ==========

WinSleep(value){ ;利用Winodws系统Delay的Sleep。
	t_start := SystemTime()
	t_elapsed := 0
	t_accuracy := value > 4 ? 0.742 : 0.2    ;Explained below
	if (value == 0) {    ;Sleep 0 can sometimes be useful
		Sleep 0
		Return 0
	}
	Loop {
		if (value - t_elapsed < t_accuracy)
			Return t_elapsed - value
		DllCall("Sleep", "UInt", 1)
		t_elapsed := SystemTime() - t_start
	}
}
SystemTime() {
	static freq
	if (!freq)    ;I haven't tested if this should be checked more frequently than just once
		DllCall("QueryPerformanceFrequency", "Int64*", freq)
	DllCall("QueryPerformanceCounter", "Int64*", tick)
	Return tick / freq * 1000
}

SwitchIME(dwLayout){  ;中英输入法切换调用
	HKL:=DllCall("LoadKeyboardLayout", Str, dwLayout, UInt, 1)
	ControlGetFocus,ctl,A
	SendMessage,0x50,0,HKL,%ctl%,A
}  ;SwitchIME(0x04090409) ;调用英语(美国)-美式键盘    ;SwitchIME(00000804) ;调用中文(中国)-简体中文
~Shift::  ;Shift键快速切换中文输入法
	SwitchIME(00000804) ;调用中文(中国)-简体中文
return


;--------------------------------
;  FindText - 屏幕找字函数
;--------------------------------
;  返回变量 := FindText(
;      OutputX --> 保存返回的X坐标的变量名称
;    , OutputY --> 保存返回的Y坐标的变量名称
;    , X1 --> 查找范围的左上角X坐标
;    , Y1 --> 查找范围的左上角Y坐标
;    , X2 --> 查找范围的右下角X坐标
;    , Y2 --> 查找范围的右下角Y坐标
;    , err1 --> 文字的黑点容错百分率（0.1=10%）
;    , err0 --> 背景的白点容错百分率（0.1=10%）
;    , Text --> 由工具生成的查找图像的数据，可以一次查找多个，用“|”分隔
;    , ScreenShot --> 是否截屏，为0则使用上一次的截屏数据
;    , FindAll --> 是否搜索所有位置，为0则找到一个位置就返回
;    , JoinText --> 如果想组合查找，可以为1，或者是要查找单词的数组
;    , offsetX --> 组合图像的每个字和前一个字的最大横向间隔
;    , offsetY --> 组合图像的每个字和前一个字的最大高低间隔
;    , dir --> 查找的方向，有上、下、左、右、中心9种
;    , zoomW --> 图像宽度的缩放百分率（1.0=100%）
;    , zoomH --> 图像高度的缩放百分率（1.0=100%）
;  )
;
;  返回变量 --> 如果没找到结果会返回0。否则返回一个二级数组，
;      第一级是每个结果对象，第二级是结果对象的具体信息数组:
;      { 1:左上角X, 2:左上角Y, 3:图像宽度W, 4:图像高度H
;        , x:中心点X, y:中心点Y, id:图像识别文本 }
;  坐标都是相对于屏幕，颜色使用RGB格式
;
;  如果 OutputX 等于 "wait" 或 "wait1" 意味着等待图像出现，
;  如果 OutputX 等于 "wait0" 意味着等待图像消失
;  此时 OutputY 设置等待时间的秒数，如果小于0则无限等待
;  如果超时则返回0，意味着失败，如果等待图像出现成功，则返回位置数组
;  如果等待图像消失成功，则返回 1
;  例1: FindText(X:="wait", Y:=3, 0,0,0,0,0,0,Text)   ; 等待3秒等图像出现
;  例2: FindText(X:="wait0", Y:=-1, 0,0,0,0,0,0,Text) ; 无限等待等图像消失
;--------------------------------
FindText(ByRef x:="FindTextClass", ByRef y:="", args*)
{
  global FindTextClass
  if (x=="FindTextClass")
    return FindTextClass
  else
    return FindTextClass.FindText(x, y, args*)
}

Class FindTextClass
{  ;// Class Begin
static bind:=[], bits:=[], Lib:=[], Cursor:=0
__New()
{
  this.bind:=[], this.bits:=[], this.Lib:=[], this.Cursor:=0
}
__Delete()
{
  if (this.bits.hBM)
    DllCall("DeleteObject", "Ptr",this.bits.hBM)
}
FindText(ByRef OutputX:="", ByRef OutputY:=""
  , x1:="", y1:="", x2:="", y2:="", err1:="", err0:=""
  , text:="", ScreenShot:="", FindAll:=""
  , JoinText:="", offsetX:="", offsetY:="", dir:=""
  , zoomW:=1, zoomH:=1)
{
  local
  if RegExMatch(OutputX, "i)^\s*wait[10]?\s*$")
  {
    found:=!InStr(OutputX,"0"), time:=OutputY
    , timeout:=A_TickCount+Round(time*1000)
    , OutputX:=OutputY:=""
    Loop
    {
      ; Wait for the image to remain stable
      While (ok:=this.FindText(OutputX, OutputY
        , x1, y1, x2, y2, err1, err0, text, ScreenShot, FindAll
        , JoinText, offsetX, offsetY, dir, zoomW, zoomH))
        and (found)
      {
        v:=ok[1], x:=v[1], y:=v[2], w:=v[3], h:=v[4]
        Sleep, 10
        if this.FindText(0, 0, x, y, x+w-1, y+h-1
        , err1, err0, text, ScreenShot, FindAll
        , JoinText, offsetX, offsetY, dir, zoomW, zoomH)
          return (this.ok:=ok)
      }
      if (!found and !ok)
        return 1
      if (time>=0 and A_TickCount>=timeout)
        Break
      Sleep, 50
    }
    return 0
  }
  SetBatchLines, % (bch:=A_BatchLines)?"-1":"-1"
  if InStr(err1,"$") and !InStr(text,"$")
  {
    dir:=offsetX, offsetY:=JoinText, offsetX:=FindAll
    , JoinText:=ScreenShot, FindAll:=text, ScreenShot:=err0
    , text:=err1, err0:=y2, err1:=x2
    , y2:=y1, x2:=x1, y1:=OutputY, x1:=OutputX
  }
  (err1="" && err1:=0), (err0="" && err0:=0)
  , (ScreenShot="" && ScreenShot:=1)
  , (FindAll="" && FindAll:=1)
  , (JoinText="" && JoinText:=0)
  , (offsetX="" && offsetX:=20)
  , (offsetY="" && offsetY:=10)
  , (dir="" && dir:=1)
  if (x1*x1+y1*y1+x2*x2+y2*y2<=0)
    n:=150000, x:=y:=-n, w:=h:=2*n
  else
    x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
  bits:=this.GetBitsFromScreen(x,y,w,h,ScreenShot,zx,zy,zw,zh)
  , x-=zx, y-=zy, info:=[], this.ok:=0
  Loop Parse, text, |
    if IsObject(j:=this.PicInfo(A_LoopField))
      info.Push(j)
  if (w<1 or h<1 or !(num:=info.Length()) or !bits.Scan0)
  {
    SetBatchLines, %bch%
    return 0
  }
  arr:=[], info2:=[], k:=0, s:=""
  , mode:=(IsObject(JoinText) ? 2 : JoinText ? 1 : 0)
  For i,j in info
  {
    k:=Max(k, j[2]*j[3]), v:=(mode=1 ? i : j[11])
    if (mode and v!="")
      s.="|" v, (!info2[v] && info2[v]:=[]), info2[v].Push(j)
  }
  JoinText:=(mode=1 ? [s] : JoinText)
  , VarSetCapacity(s1, k*4), VarSetCapacity(s0, k*4)
  , VarSetCapacity(ss, 2*(w+2)*(h+2))
  , FindAll:=(dir=9 ? 1 : FindAll)
  , allpos_max:=(FindAll or JoinText ? 10240 : 1)
  , ini:={sx:x, sy:y, sw:w, sh:h, zx:zx, zy:zy, zw:zw, zh:zh
  , mode:mode, bits:bits, ss:&ss, s1:&s1, s0:&s0
  , allpos_max:allpos_max, zoomW:zoomW, zoomH:zoomH}
  Loop 2
  {
    if (err1=0 and err0=0) and (num>1 or A_Index>1)
      err1:=0.05, err0:=0.05
    ini.err1:=err1, ini.err0:=err0
    if (!JoinText)
    {
      VarSetCapacity(allpos, allpos_max*8)
      For i,j in info
      Loop % this.PicFind(ini, j, dir, allpos
      , ini.sx, ini.sy, ini.sw, ini.sh)
      {
        x:=NumGet(allpos, 8*A_Index-8, "uint") + zx
        , y:=NumGet(allpos, 8*A_Index-4, "uint") + zy
        , w:=j[2], h:=j[3], comment:=j[11]
        , arr.Push({1:x, 2:y, 3:w, 4:h, x:x+w//2, y:y+h//2, id:comment})
        if (!FindAll)
          Break, 3
      }
    }
    else
    For k,v in JoinText
    {
      v:=RegExReplace(v, "\s*\|[|\s]*", "|")
      , v:=StrSplit(Trim(v,"|"), (InStr(v,"|")?"|":""), " `t")
      , this.JoinText(ini, arr, info2, v, offsetX, offsetY, FindAll
      , 1, v.Length(), dir, 0, 0, ini.sx, ini.sy, ini.sw, ini.sh)
      if (!FindAll and arr.Length())
        Break, 2
    }
    if (err1!=0 or err0!=0 or arr.Length()
    or info[1][8]=5 or info[1][12])
      Break
  }
  if (dir=9)
    arr:=this.Sort2(arr, Round(x1+x2)//2, Round(y1+y2)//2)
  SetBatchLines, %bch%
  if (arr.Length())
  {
    OutputX:=arr[1].x, OutputY:=arr[1].y, this.ok:=arr
    return arr
  }
  return 0
}
; the join text object <==> [ "abc", "xyz", "a1|a2|a3" ]
JoinText(ini, arr, info2, text, offsetX, offsetY, FindAll
  , index:="", Len:="", dir:="", minY:="", maxY:=""
  , sx:="", sy:="", sw:="", sh:="")
{
  local
  VarSetCapacity(allpos, ini.allpos_max*8)
  For i,j in info2[text[index]]
  if (ini.mode=1 or text[index]==j[11])
  Loop % this.PicFind(ini, j, dir, allpos, sx, sy
    , (index=1 ? sw : Min(sx+offsetX+j[2],ini.sx+ini.sw)-sx), sh)
  {
    x:=NumGet(allpos, 8*A_Index-8, "uint")
    , y:=NumGet(allpos, 8*A_Index-4, "uint"), w:=j[2], h:=j[3]
    , (index=1) && (ini.x:=x, minY:=y, maxY:=y+h)
    if (index<Len)
    {
      if this.JoinText(ini, arr, info2, text, offsetX, offsetY, FindAll
      , index+1, Len, 5, (y1:=Min(y,minY)), (y2:=Max(y+h,maxY)), x+w
      , (y:=Max(y1-offsetY,ini.sy)), 0, Min(y2+offsetY,ini.sy+ini.sh)-y)
      and (index>1 or !FindAll)
        return 1
    }
    else
    {
      comment:=""
      For k,v in text
        comment.=(ini.mode=1 ? info2[v][1][11] : v)
      w:=x+w-ini.x, x:=ini.x+ini.zx
      , h:=Max(y+h,maxY)-Min(y,minY), y:=Min(y,minY)+ini.zy
      , arr.Push({1:x, 2:y, 3:w, 4:h, x:x+w//2, y:y+h//2, id:comment})
      if (index>1 or !FindAll)
        return 1
    }
  }
}
PicFind(ini, j, dir, ByRef allpos, sx, sy, sw, sh)
{
  local
  static MyFunc:=""
  if (!MyFunc)
  {
    x32:=""
    . "5557565383EC6C83BC2480000000058BBC24C00000000F84E60800008BAC24C4"
    . "00000085ED0F8ECE0D0000C744240400000000C74424140000000031EDC74424"
    . "0800000000C7442418000000008D76008B8424BC0000008B4C241831F631DB01"
    . "C885FF894424107F3DE99100000066900FAF8424A800000089C189F099F7FF01"
    . "C18B442410803C1831744D8B8424B800000083C30103B424D8000000890CA883"
    . "C50139DF74558B44240499F7BC24C400000083BC24800000000375B40FAF8424"
    . "9400000089C189F099F7FF8D0C818B442410803C183175B38B4424088B9424B4"
    . "00000083C30103B424D8000000890C8283C00139DF8944240875AB017C241883"
    . "442414018B9C24DC0000008B442414015C2404398424C40000000F8530FFFFFF"
    . "896C241031C08B74240839B424C80000008B5C24100F4DF0399C24CC00000089"
    . "7424080F4CC339C6894424100F4DC683BC248000000003894424040F846C0800"
    . "008BAC24940000008B8424A00000000FAFAC24A40000008BB42494000000C1E0"
    . "028944243801C58B8424A8000000896C2434F7D88D0486894424248B84248000"
    . "000085C00F858A0300008B842484000000C744242000000000C7442428000000"
    . "00C1E8100FB6E88B8424840000000FB6C4894424140FB6842484000000894424"
    . "188B8424A8000000C1E002894424308B8424AC00000085C00F8EC60000008B7C"
    . "240C8B442434896C241C8BAC24A800000085ED0F8E8D0000008BB42490000000"
    . "8B6C242803AC24B000000001C6034424308944242C038424900000008944240C"
    . "0FB67E028B4C241C0FB6160FB646012B5424182B44241489FB01CF29CB8D8F00"
    . "0400000FAFC00FAFCBC1E00B0FAFCBBBFE05000029FB0FAFDA01C10FAFD301CA"
    . "399424880000000F93450083C60483C5013B74240C75A98B9C24A8000000015C"
    . "24288B44242C8344242001034424248B74242039B424AC0000000F854AFFFFFF"
    . "897C240C8B8424A80000002B8424D8000000C644244F00C644244E00C7442454"
    . "00000000C744246000000000894424588B8424AC0000002B8424DC0000008944"
    . "243C8B84248C00000083E80183F8070F87D005000083F803894424440F8ECB05"
    . "00008B4424608B74245489442454897424608B742458397424540F8FCE0A0000"
    . "8B4424588B742408C7442430000000008944245C8B8424B40000008D04B08B74"
    . "24448944245089F083E0018944244889F08BB4249000000083E003894424648B"
    . "4424608B7C243C39F80F8F7F010000837C2464018B5C24540F4F5C245C897C24"
    . "2C89442420895C24408DB426000000008B7C24488B44242C85FF0F4444242083"
    . "7C244403894424240F8FD5020000807C244E008B442440894424288B4424280F"
    . "85DD020000807C244F000F85800300000FAF8424A80000008B5424048B5C2424"
    . "85D28D2C180F8E840000008BBC24CC0000008B9424B000000031C08B9C24C800"
    . "0000896C24348B4C24088974241C01EA897C24188B6C24048B7C2410895C2414"
    . "39C17E1C8B9C24B40000008B348301D6803E00750B836C2414010F8860040000"
    . "39C77E1C8B9C24B80000008B348301D6803E00740B836C2418010F8840040000"
    . "83C00139E875B98B6C24348B74241C8B44240885C074278BBC24B00000008B84"
    . "24B40000008B5C24508D0C2F8D7426008B1083C00401CA39D8C6020075F28B44"
    . "2424038424A00000008B5C24308BBC24D00000008904DF8B442428038424A400"
    . "00008944DF0483C3013B9C24D4000000895C24307D308344242001836C242C01"
    . "8B4424203944243C0F8DA2FEFFFF8344245401836C245C018B44245439442458"
    . "0F8D59FEFFFF8B44243083C46C5B5E5F5DC2600083BC2480000000010F84E007"
    . "000083BC2480000000020F843B0500008B8424840000000FB6BC2484000000C7"
    . "44242C00000000C744243000000000C1E8100FB6D08B84248400000089D50FB6"
    . "DC8B842488000000C1E8100FB6C88B84248800000029CD01D1896C243C89DD89"
    . "4C24140FB6F40FB684248800000029F501DE896C241889FD8974241C29C501F8"
    . "894424288B8424A8000000896C2420C1E002894424388B8424AC00000085C00F"
    . "8EDFFCFFFF8B4C24348B6C243C8B8424A800000085C00F8E880000008B842490"
    . "0000008B542430039424B000000001C8034C243889CF894C243403BC24900000"
    . "00EB34395C24147C3D394C24187F37394C241C7C3189F30FB6F3397424200F9E"
    . "C3397424280F9DC183C00483C20121D9884AFF39C7741E0FB658020FB648010F"
    . "B63039DD7EBD31C983C00483C201884AFF39C775E28BB424A800000001742430"
    . "8B4C24348344242C01034C24248B44242C398424AC0000000F854FFFFFFFE921"
    . "FCFFFF8B442424807C244E00894424288B442440894424248B4424280F8423FD"
    . "FFFF0FAF8424940000008B5C24248D2C988B5C240485DB0F8EE1FDFFFF8BBC24"
    . "C800000031C9896C24148DB6000000008B8424B40000008B5C2414031C888B84"
    . "24B80000008B2C880FB6441E0289EAC1EA100FB6D229D00FB6541E010FB61C1E"
    . "0FAFC03B44240C7F2789E80FB6C429C20FAFD23B54240C7F1789E80FB6C029C3"
    . "0FAFDB3B5C240C7E108DB4260000000083EF010F887701000083C1013B4C2404"
    . "758E89AC2484000000E950FDFFFF66900FAF8424940000008B7C24248B4C2404"
    . "8D04B8894424140384248400000085C90FB65C06010FB67C06020FB60406895C"
    . "24188944241C0F8E12FDFFFF8B8424CC00000031DB894424388B8424C8000000"
    . "894424348B44240C897C240C8D742600395C24087E658B8424B40000008B4C24"
    . "148B7C240C030C980FB6440E020FB6540E010FB60C0E2B5424182B4C241C89C5"
    . "01F829FD8DB8000400000FAFD20FAFFDC1E20B0FAFFDBDFE05000029C50FAFE9"
    . "01FA0FAFCD01D1398C2488000000730B836C2434010F88A1000000395C24107E"
    . "618B8424B80000008B4C24148B7C240C030C980FB6440E020FB6540E010FB60C"
    . "0E2B5424182B4C241C89C501F829FD8DB8000400000FAFD20FAFFDC1E20B0FAF"
    . "FDBDFE05000029C50FAFE901FA0FAFCD01D1398C24880000007207836C243801"
    . "783A83C3013B5C24040F8521FFFFFF8944240CE906FCFFFF908DB42600000000"
    . "8B74241CE92DFCFFFF8DB4260000000089AC2484000000E91AFCFFFF8944240C"
    . "E911FCFFFFC7442444000000008B44243C8B742458894424588974243CE930FA"
    . "FFFF8B8424880000008BB424BC00000031C931DB31ED89BC24C0000000894424"
    . "048B8424840000000FAFC08944240CEB1AB80A0000006BDB0AF7E189F901DA89"
    . "FBC1FB1F01C111D383C6010FBE0685C00F84B80000008D78D083FF0976D383F8"
    . "2F75E58D04AD000000008944241489C80FACD8100FB7C00FAF8424DC00000099"
    . "F7BC24C40000000FAF84249400000089C70FB7C131C90FAF8424D800000099F7"
    . "BC24C00000008B9424B40000008D04878B7C24148904AA89D88B9C24B8000000"
    . "83C50189043B31DBE97BFFFFFF8B842484000000C1E8100FAF8424DC00000099"
    . "F7BC24C40000000FAF84249400000089C10FB78424840000000FAF8424D80000"
    . "0099F7FF8D04818984248400000083BC2480000000058B8424A80000000F9444"
    . "244E83BC2480000000030F9444244F038424A00000002B8424D8000000894424"
    . "588B8424A4000000038424AC0000002B8424DC0000008944243C8B8424A40000"
    . "00C78424A400000000000000894424548B8424A0000000C78424A00000000000"
    . "000089442460E977F8FFFF8B8424A8000000038424A00000008BAC24A8000000"
    . "8BB424A40000000FAFAC24AC000000894424208B8424A400000083EE01038424"
    . "AC00000003AC24B00000008974241439F0896C241C0F8C0E0100008BB424A000"
    . "000083C001C7442428000000008944242C8B8424800000002B8424A000000083"
    . "EE01897424308B7424140FAFB4249400000089C7897424248B74242001F78D6E"
    . "01897C24348B442430394424200F8C980000008B7C24148B5C24248B74242803"
    . "5C24382BB424A0000000039C2490000000C1EF1F0374241C897C2418EB4D6690"
    . "398424980000007E4B807C24180075448B7C241439BC249C0000007E370FB64B"
    . "FE0FB653FD83C3040FB67BF86BD24B6BC92601D189FAC1E20429FA01CAC1FA07"
    . "8854060183C00139E8741889C2C1EA1F84D274ACC64406010083C00183C30439"
    . "E875E88B7424340174242883442414018BBC24940000008B442414017C242439"
    . "44242C0F853CFFFFFF8B8424A80000008B8C24AC00000083C00285C989442420"
    . "0F8EBEF6FFFF8B8424AC0000008B6C241C036C2420C744241C01000000C74424"
    . "240000000083C001894424288B8424A8000000896C241883C0048944242C8B84"
    . "24880000008B9424A800000085D20F8EA70000008B4424188B5C24248B74242C"
    . "039C24B000000089C12B8C24A800000089C201C6894C2414908DB42600000000"
    . "0FB642010FB62ABF010000000384248400000039E8723D0FB66A0239E872358B"
    . "4C24140FB669FF39E872290FB66EFF39E872210FB669FE39E872190FB62939E8"
    . "72120FB66EFE39E8720A0FB63E39F80F92C189CF89F9834424140183C201880B"
    . "83C60183C3018B7C2414397C241875908BBC24A8000000017C24248344241C01"
    . "8B5C24208B74241C015C2418397424280F852FFFFFFF89842488000000E9A2F5"
    . "FFFF8B8424840000008BB424AC000000C744241400000000C744241800000000"
    . "83C001C1E007898424840000008B8424A8000000C1E00285F68944241C0F8E61"
    . "F5FFFF8B4424348BAC24840000008B9C24A800000085DB7E618B8C2490000000"
    . "8B5C2418039C24B000000001C10344241C894424200384249000000089C76690"
    . "0FB651020FB641010FB6316BC04B6BD22601C289F0C1E00429F001D039C50F97"
    . "0383C10483C30139F975D58BBC24A8000000017C24188B442420834424140103"
    . "4424248B74241439B424AC0000000F857AFFFFFFE9CBF4FFFFC7442410000000"
    . "00C744240800000000E916F3FFFFC744243000000000E90BF7FFFF9090909090"
    x64:=""
    . "4157415641554154555756534881EC88000000488BBC24F0000000488BB42430"
    . "01000083F905898C24D000000089542468448944240444898C24E80000004C8B"
    . "AC2438010000488B9C2440010000448B942450010000448B9C24580100000F84"
    . "5909000031ED4531E44585DB0F8E1901000044897424104C89AC243801000031"
    . "C0448BBC2420010000448BAC24D000000031ED448BB424800100004889B42430"
    . "0100004531E4C744240800000000C74424380000000089C64889BC24F0000000"
    . "48637C24384531C94531C04803BC24480100004585D27F33EB7B660F1F440000"
    . "410FAFC789C14489C89941F7FA01C142803C0731743C4983C0014863C54501F1"
    . "83C5014539C2890C837E4589F09941F7FB4183FD0375C90FAF8424F800000089"
    . "C14489C89941F7FA42803C07318D0C8175C4488B9424380100004983C0014963"
    . "C44501F14183C4014539C2890C827FBB4401542438834424080103B424880100"
    . "008B4424084139C30F8552FFFFFF448B742410488BBC24F0000000488BB42430"
    . "0100004C8BAC243801000031C04439A42460010000440F4DE039AC2468010000"
    . "0F4DE84139EC4189EF450F4DFC83BC24D0000000030F849A0800008B8424F800"
    . "00008B8C24100100000FAF8424180100008D04888B8C24F8000000894424208B"
    . "842420010000F7D88D0481894424088B8424D000000085C00F859E0300008B4C"
    . "24684889C84189CB0FB6C441C1EB1089C20FB6C1450FB6DB4189C28B84242801"
    . "000085C00F8E300100008B842420010000448964242831C94889B42430010000"
    . "4C89AC2438010000448B6424048BB42420010000448B6C2420C1E00244897C24"
    . "18896C24304889BC24F00000004489D5C744243800000000894424104189CF89"
    . "D748899C244001000085F60F8E84000000488B9C24F00000004963C54531D24C"
    . "8D4C030248635C243848039C2430010000450FB631410FB651FE410FB641FF29"
    . "EA4489F14501DE4189D0418D96000400004429D929F80FAFD10FAFC00FAFD1C1"
    . "E00B8D0402BAFE0500004429F2410FAFD0410FAFD001D04139C4420F93041349"
    . "83C2014983C1044439D67FA544036C2410017424384183C70144036C24084439"
    . "BC24280100000F855DFFFFFF448B7C2418448B6424288B6C2430488BBC24F000"
    . "0000488BB424300100004C8BAC2438010000488B9C24400100008B8424200100"
    . "002B842480010000C644245700C644245600C744246C00000000C74424780000"
    . "0000894424708B8424280100002B842488010000894424448B8424E800000083"
    . "E80183F8070F87F505000083F8038944244C0F8EF00500008B4424788B4C246C"
    . "8944246C894C24788B4C2470394C246C0F8F600B00008B4424708B4C244C4889"
    . "9C24400100004889F34C89EEC74424300000000089442474418D4424FF498D44"
    . "85044589E54C8BA42440010000488944246089C883E0018944245089C883E003"
    . "8944247C8B4424788B4C244439C80F8F38010000837C247C018B54246C0F4F54"
    . "2474894C2428894424088954244866908B44245085C08B4424280F4444240883"
    . "7C244C03894424380F8FD2020000807C2456008B442448894424100F85DA0200"
    . "00807C2457000F85740300008B4C24100FAF8C2420010000034C24384585FF7E"
    . "50448B942468010000448B8C246001000031C04139C589C27E184189C8440304"
    . "8642803C0300750A4183E9010F888200000039D57E1289CA41031484803C1300"
    . "74064183EA01786C4883C0014139C77FC24585ED741B4C8B4424604889F06690"
    . "89CA03104883C0044C39C0C604130075EF8B4C24308B54243803942410010000"
    . "4C8B94247001000089C801C04898418914828B54241003942418010000418954"
    . "820489C883C0013B842478010000894424307D308344240801836C2428018B44"
    . "2408394424440F8DE4FEFFFF8344246C01836C2474018B44246C394424700F8D"
    . "A0FEFFFF8B4424304881C4880000005B5E5F5D415C415D415E415FC383BC24D0"
    . "000000010F84AC08000083BC24D0000000020F84520500008B542468448B5424"
    . "04C744241000000000C74424180000000089D0440FB6C2C1E810440FB6C84889"
    . "D00FB6CC4489D04589CBC1E810894C24380FB6D04C89D00FB6C44129D34401CA"
    . "89C18B44243829C8034C243889442430410FB6C24589C24129C24401C0448B84"
    . "2428010000894424388B842420010000C1E0024585C0894424280F8E1AFDFFFF"
    . "448974243C896C24484C89AC2438010000448B7424208BAC2420010000448B6C"
    . "243044897C244044896424444189CF48899C24400100004189D44489D385ED7E"
    . "724C635424184963C631D2488D4407024901F2EB314539C47C3E4139CD7F3941"
    . "39CF7C344439CB410F9EC044394C24380F9DC14883C0044421C141880C124883"
    . "C20139D57E24440FB6000FB648FF440FB648FE4539C37EBD31C94883C0044188"
    . "0C124883C20139D57FDC4403742428016C2418834424100144037424088B4424"
    . "10398424280100000F856FFFFFFF448B74243C448B7C2440448B6424448B6C24"
    . "484C8BAC2438010000488B9C2440010000E924FCFFFF662E0F1F840000000000"
    . "8B442438807C245600894424108B442448894424380F8426FDFFFF8B4424108B"
    . "4C24380FAF8424F80000004585FF448D14880F8E99FDFFFF448B8C2460010000"
    . "4531C04989DB662E0F1F840000000000428B1486438B1C844401D289D98D4202"
    . "C1E9100FB6C948980FB6040729C88D4A014863D20FAFC00FB614174863C90FB6"
    . "0C0F4439F07F1A0FB6C729C10FAFC94439F17F0D0FB6C329C20FAFD24439F27E"
    . "0A4183E9010F88950100004983C0014539C77F9C895C24684C89DBE911FDFFFF"
    . "8B4424108B4C24380FAF8424F80000008D048889C1034424684585FF8D500248"
    . "63D2440FB614178D500148980FB604074863D20FB614170F8ED4FCFFFF448B9C"
    . "246801000048895C24584531C948897424184C8964242089CB89C64189D44489"
    . "5C2440448B9C246001000044895C243C4539CD4589C87E6E488B442418428B14"
    . "8801DA8D42024898440FB634078D42014863D20FB6141748980FB604074589F3"
    . "4501D6418D8E000400004529D329F2410FAFCB4429E00FAFC0410FAFCB41BBFE"
    . "050000C1E00B4529F3440FAFDA01C8410FAFD301C239542404730B836C243C01"
    . "0F88A60000004439C57E6A488B442420428B148801DA8D42024898440FB63407"
    . "8D42014863D20FB6141748980FB604074589F04501D6418D8E000400004529D0"
    . "29F2410FAFC84429E00FAFC0410FAFC841B8FE050000C1E00B4529F0440FAFC2"
    . "01C8410FAFD001C2395424047207836C24400178374983C1014539CF0F8F0EFF"
    . "FFFF488B5C2458488B7424184C8B642420E99BFBFFFF662E0F1F840000000000"
    . "895C24684C89DBE9C8FBFFFF488B5C2458488B7424184C8B642420E9B4FBFFFF"
    . "C744244C000000008B4424448B4C247089442470894C2444E90BFAFFFF8B4424"
    . "68448B7C24044531C04C8B8C244801000031C94189C6440FAFF0EB0F4B8D0480"
    . "4863D24C8D04424983C101410FBE0185C00F84960000008D50D083FA0976DD83"
    . "F82F75E34C89C048C1E8100FB7C00FAF8424880100009941F7FB0FAF8424F800"
    . "000089442408410FB7C049C1E8200FAF8424800100009941F7FA8B5424088D04"
    . "824863D183C1014189449500448904934531C0EB92448B4C24684489C8C1E810"
    . "0FAF8424880100009941F7FB0FAF8424F800000089C1410FB7C10FAF84248001"
    . "00009941F7FA8D04818944246883BC24D0000000058B8424200100000F944424"
    . "5683BC24D0000000030F94442457038424100100002B84248001000089442470"
    . "8B842418010000038424280100002B842488010000894424448B842418010000"
    . "C7842418010000000000008944246C8B842410010000C7842410010000000000"
    . "0089442478E98EF8FFFF8B8424200100008B8C24180100000FAF842428010000"
    . "83E90189CA48984801F048894424088B84242001000003842410010000894424"
    . "388B8424180100000384242801000039C80F8C750100008B8C241001000083C0"
    . "0148899C244001000089442420C74424180000000089D3448974244444897C24"
    . "4883E901448964244C4889B424300100004189CA894C243C8B8C24F800000042"
    . "8D0495000000000FAFCA89442430489848894424288B8424D00000002B842410"
    . "010000894C24108B4C24384189C3448D51014101CB44895C2440448B9C240001"
    . "00008B44243C394424380F8CA50000008B4C24108B5424304189DE488B742428"
    . "4C6344241841C1EE1F4C0344240801CA4C63F94863D24C8D0C174829D6EB5190"
    . "4139C37E544584F6754F399C24080100007E46410FB64902410FB6510183C001"
    . "4983C0016BD24B6BC92601D14A8D140E4983C104460FB6243A4489E2C1E20444"
    . "29E201D1C1F907418848FF4139C2741D89C2C1EA1F84D274A783C00141C60000"
    . "4983C1044983C0014139C275E38B7424400174241883C3018BB424F800000001"
    . "742410395C24200F8535FFFFFF448B742444448B7C2448448B64244C488BB424"
    . "30010000488B9C24400100008B842420010000448B94242801000083C0024585"
    . "D20F8E73F6FFFF488B4C2408489844897C24404889442410448B7C246848899C"
    . "2440010000C744240801000000488D440101C744243800000000448974243C48"
    . "89C18B8424280100004889CB83C001894424184863842420010000488D500348"
    . "F7D048894424288B84242001000048895424208B54240483E8014883C0014889"
    . "442430448B8C24200100004585C90F8EAF000000488B44242048634C24384C8D"
    . "0C18488B4424284801F14C8D0418488B4424304C8D34184889D8660F1F440000"
    . "0FB610440FB650FF41BB010000004401FA4439D2724A440FB650014439D27240"
    . "450FB650FF4439D27236450FB651FF4439D2722C450FB650FE4439D27222450F"
    . "B6104439D27219450FB651FE4439D2720F450FB6114439D2410F92C30F1F4000"
    . "4883C0014488194983C1014883C1014983C0014C39F075888B8C242001000001"
    . "4C2438834424080148035C24108B442408394424180F8528FFFFFF448B74243C"
    . "448B7C244089542404488B9C2440010000E904F5FFFF8B4424684531DBC74424"
    . "380000000083C001C1E007894424688B842420010000C1E002894424108B8424"
    . "2801000085C00F8ECEF4FFFF44897C242848899C2440010000448B7C2468448B"
    . "9424200100008B5C242044897424184585D27E594C637424384863C34531C048"
    . "8D4C07024901F6660F1F8400000000000FB6110FB641FF440FB649FE6BC04B6B"
    . "D22601C24489C8C1E0044429C801D04139C7430F9704064983C0014883C10445"
    . "39C27FCC035C241044015424384183C301035C240844399C2428010000759044"
    . "8B742418448B7C2428488B9C2440010000E924F4FFFFC744243000000000E941"
    . "F6FFFF90909090909090909090909090"
    this.MCode(MyFunc, A_PtrSize=8 ? x64:x32)
  }
  text:=j[1], w:=j[2], h:=j[3]
  , e1:=(j[12] ? j[6] : Floor(j[4] * ini.err1))
  , e0:=(j[12] ? j[7] : Floor(j[5] * ini.err0))
  , mode:=j[8], color:=j[9], n:=j[10]
  return (!ini.bits.Scan0) ? 0 : DllCall(&MyFunc
    , "int",mode, "uint",color, "uint",n, "int",dir
    , "Ptr",ini.bits.Scan0, "int",ini.bits.Stride
    , "int",ini.zw, "int",ini.zh
    , "int",sx, "int",sy, "int",sw, "int",sh
    , "Ptr",ini.ss, "Ptr",ini.s1, "Ptr",ini.s0
    , "AStr",text, "int",w, "int",h, "int",e1, "int",e0
    , "Ptr",&allpos, "int",ini.allpos_max
    , "int",w*ini.zoomW, "int",h*ini.zoomH)
}
GetBitsFromScreen(ByRef x:=0, ByRef y:=0, ByRef w:=0, ByRef h:=0
  , ScreenShot:=1, ByRef zx:="", ByRef zy:="", ByRef zw:="", ByRef zh:="")
{
  local
  static CAPTUREBLT:=""
  (!IsObject(this.bits) && this.bits:=[]), bits:=this.bits
  if (!ScreenShot and bits.Scan0)
  {
    zx:=bits.zx, zy:=bits.zy, zw:=bits.zw, zh:=bits.zh
    if IsByRef(x)
      w:=Min(x+w,zx+zw), x:=Max(x,zx), w-=x
      , h:=Min(y+h,zy+zh), y:=Max(y,zy), h-=y
    return bits
  }
  bch:=A_BatchLines, cri:=A_IsCritical
  Critical
  if (id:=this.BindWindow(0,0,1))
  {
    WinGet, id, ID, ahk_id %id%
    WinGetPos, zx, zy, zw, zh, ahk_id %id%
  }
  if (!id)
  {
    SysGet, zx, 76
    SysGet, zy, 77
    SysGet, zw, 78
    SysGet, zh, 79
  }
  bits.zx:=zx, bits.zy:=zy, bits.zw:=zw, bits.zh:=zh
  , w:=Min(x+w,zx+zw), x:=Max(x,zx), w-=x
  , h:=Min(y+h,zy+zh), y:=Max(y,zy), h-=y
  if (zw>bits.oldzw or zh>bits.oldzh or !bits.hBM)
  {
    DllCall("DeleteObject", "Ptr",bits.hBM)
    , bits.hBM:=this.CreateDIBSection(zw, zh, bpp:=32, ppvBits)
    , bits.Scan0:=(!bits.hBM ? 0:ppvBits)
    , bits.Stride:=((zw*bpp+31)//32)*4
    , bits.oldzw:=zw, bits.oldzh:=zh
  }
  if (!ScreenShot or w<1 or h<1 or !bits.hBM)
  {
    Critical, %cri%
    SetBatchLines, %bch%
    return bits
  }
  if IsFunc(k:="GetBitsFromScreen2")
    and %k%(bits, x-zx, y-zy, w, h)
  {
    zx:=bits.zx, zy:=bits.zy, zw:=bits.zw, zh:=bits.zh
    Critical, %cri%
    SetBatchLines, %bch%
    return bits
  }
  if (CAPTUREBLT="")  ; thanks Descolada
  {
    DllCall("Dwmapi\DwmIsCompositionEnabled", "Int*",compositionEnabled:=0)
    CAPTUREBLT:=compositionEnabled ? 0 : 0x40000000
  }
  mDC:=DllCall("CreateCompatibleDC", "Ptr",0, "Ptr")
  oBM:=DllCall("SelectObject", "Ptr",mDC, "Ptr",bits.hBM, "Ptr")
  if (id)
  {
    if (mode:=this.BindWindow(0,0,0,1))<2
    {
      hDC2:=DllCall("GetDCEx", "Ptr",id, "Ptr",0, "int",3, "Ptr")
      DllCall("BitBlt","Ptr",mDC,"int",x-zx,"int",y-zy,"int",w,"int",h
        , "Ptr",hDC2, "int",x-zx, "int",y-zy, "uint",0xCC0020|CAPTUREBLT)
      DllCall("ReleaseDC", "Ptr",id, "Ptr",hDC2)
    }
    else
    {
      hBM2:=this.CreateDIBSection(zw, zh)
      mDC2:=DllCall("CreateCompatibleDC", "Ptr",0, "Ptr")
      oBM2:=DllCall("SelectObject", "Ptr",mDC2, "Ptr",hBM2, "Ptr")
      DllCall("PrintWindow", "Ptr",id, "Ptr",mDC2, "uint",(mode>3)*3)
      DllCall("BitBlt","Ptr",mDC,"int",x-zx,"int",y-zy,"int",w,"int",h
        , "Ptr",mDC2, "int",x-zx, "int",y-zy, "uint",0xCC0020)
      DllCall("SelectObject", "Ptr",mDC2, "Ptr",oBM2)
      DllCall("DeleteDC", "Ptr",mDC2)
      DllCall("DeleteObject", "Ptr",hBM2)
    }
  }
  else
  {
    win:=DllCall("GetDesktopWindow", "Ptr")
    hDC:=DllCall("GetWindowDC", "Ptr",win, "Ptr")
    DllCall("BitBlt","Ptr",mDC,"int",x-zx,"int",y-zy,"int",w,"int",h
      , "Ptr",hDC, "int",x, "int",y, "uint",0xCC0020|CAPTUREBLT)
    DllCall("ReleaseDC", "Ptr",win, "Ptr",hDC)
  }
  if this.CaptureCursor(0,0,0,0,0,1)
    this.CaptureCursor(mDC, zx, zy, zw, zh)
  DllCall("SelectObject", "Ptr",mDC, "Ptr",oBM)
  DllCall("DeleteDC", "Ptr",mDC)
  Critical, %cri%
  SetBatchLines, %bch%
  return bits
}
CreateDIBSection(w, h, bpp:=32, ByRef ppvBits:=0, ByRef bi:="")
{
  VarSetCapacity(bi, 40, 0), NumPut(40, bi, 0, "int")
  , NumPut(w, bi, 4, "int"), NumPut(-h, bi, 8, "int")
  , NumPut(1, bi, 12, "short"), NumPut(bpp, bi, 14, "short")
  return DllCall("CreateDIBSection", "Ptr",0, "Ptr",&bi
    , "int",0, "Ptr*",ppvBits:=0, "Ptr",0, "int",0, "Ptr")
}
PicInfo(text)
{
  local
  static info:=[]
  if !InStr(text,"$")
    return
  key:=(r:=StrLen(text))<10000 ? text
    : DllCall("ntdll\RtlComputeCrc32", "uint",0
    , "Ptr",&text, "uint",r*(1+!!A_IsUnicode), "uint")
  if (info[key])
    return info[key]
  v:=text, comment:="", seterr:=e1:=e0:=0
  ; You Can Add Comment Text within The <>
  if RegExMatch(v,"<([^>\n]*)>",r)
    v:=StrReplace(v,r), comment:=Trim(r1)
  ; You can Add two fault-tolerant in the [], separated by commas
  if RegExMatch(v,"\[([^\]\n]*)]",r)
  {
    v:=StrReplace(v,r), r:=StrSplit(r1, ",")
    , seterr:=1, e1:=r[1], e0:=r[2]
  }
  color:=StrSplit(v,"$")[1], v:=Trim(SubStr(v,InStr(v,"$")+1))
  mode:=InStr(color,"##") ? 5
    : InStr(color,"-") ? 4 : InStr(color,"#") ? 3
    : InStr(color,"**") ? 2 : InStr(color,"*") ? 1 : 0
  color:=RegExReplace(color, "[*#\s]")
  if (mode=5)
  {
    if (v~="[^\s\w/]") and FileExist(v)  ; ImageSearch
    {
      if !(hBM:=LoadPicture(v))
        return
      this.GetBitmapWH(hBM, w, h)
      if (w<1 or h<1)
        return
      hBM2:=this.CreateDIBSection(w, h, 32, Scan0)
      this.CopyHBM(hBM2, 0, 0, hBM, 0, 0, w, h)
      DllCall("DeleteObject", "Ptr",hBM)
      if (!Scan0)
        return
      c1:=NumGet(Scan0+0,"uint")&0xFFFFFF
      c2:=NumGet(Scan0+(w-1)*4,"uint")&0xFFFFFF
      c3:=NumGet(Scan0+(w*h-w)*4,"uint")&0xFFFFFF
      c4:=NumGet(Scan0+(w*h-1)*4,"uint")&0xFFFFFF
      if (c1!=c2 or c1!=c3 or c1!=c4)
        c1:=-1
      VarSetCapacity(v, w*h*18*(1+!!A_IsUnicode)), i:=-4, y:=-1
      SetFormat, IntegerFast, d
      Loop % h
        Loop % w+0*(++y)
          if (c:=NumGet(Scan0+(i+=4),"uint")&0xFFFFFF)!=c1
            v.=(A_Index-1)|y<<16|c<<32 . "/"
      StrReplace(v, "/", "", n)
      DllCall("DeleteObject", "Ptr",hBM2)
    }
    else
    {
      v:=Trim(StrReplace(RegExReplace(v,"\s"),",","/"),"/")
      r:=StrSplit(v,"/"), n:=r.Length()//3
      if (!n)
        return
      VarSetCapacity(v, n*18*(1+!!A_IsUnicode))
      x1:=x2:=r[1], y1:=y2:=r[2]
      SetFormat, IntegerFast, d
      Loop % n + (i:=-2)*0
        x:=r[i+=3], y:=r[i+1]
        , (x<x1 && x1:=x), (x>x2 && x2:=x)
        , (y<y1 && y1:=y), (y>y2 && y2:=y)
      Loop % n + (i:=-2)*0
        v.=(r[i+=3]-x1)|(r[i+1]-y1)<<16|(Floor("0x"
        . StrReplace(r[i+2],"0x"))&0xFFFFFF)<<32 . "/"
      w:=x2-x1+1, h:=y2-y1+1
    }
    len1:=n, len0:=0
  }
  else
  {
    r:=StrSplit(v,"."), w:=r[1]
    , v:=this.base64tobit(r[2]), h:=StrLen(v)//w
    if (w<1 or h<1 or StrLen(v)!=w*h)
      return
    if (mode=4)
    {
      r:=StrSplit(StrReplace(color,"0x"),"-")
      , color:=Floor("0x" r[1]), n:=Floor("0x" r[2])
    }
    else
    {
      r:=StrSplit(color,"@")
      , color:=r[1], n:=Round(r[2],2)+(!r[2])
      , n:=Floor(512*9*255*255*(1-n)*(1-n))
      if (mode=3)
        color:=(((color-1)//w)<<16)|Mod(color-1,w)
    }
    StrReplace(v,"1","",len1), len0:=StrLen(v)-len1
  }
  e1:=Floor(len1*e1), e0:=Floor(len0*e0)
  return info[key]:=[v, w, h, len1, len0, e1, e0
    , mode, color, n, comment, seterr]
}
GetBitmapWH(hBM, ByRef w, ByRef h)
{
  local
  VarSetCapacity(bm, size:=(A_PtrSize=8 ? 32:24), 0)
  r:=DllCall("GetObject", "Ptr",hBM, "int",size, "Ptr",&bm)
  w:=NumGet(bm,4,"int"), h:=Abs(NumGet(bm,8,"int"))
  return r
}
CopyHBM(hBM1, x1, y1, hBM2, x2, y2, w2, h2)
{
  local
  if (w2<1 or h2<1 or !hBM1 or !hBM2)
    return
  mDC1:=DllCall("CreateCompatibleDC", "Ptr",0, "Ptr")
  oBM1:=DllCall("SelectObject", "Ptr",mDC1, "Ptr",hBM1, "Ptr")
  mDC2:=DllCall("CreateCompatibleDC", "Ptr",0, "Ptr")
  oBM2:=DllCall("SelectObject", "Ptr",mDC2, "Ptr",hBM2, "Ptr")
  DllCall("BitBlt", "Ptr",mDC1
    , "int",x1, "int",y1, "int",w2, "int",h2, "Ptr",mDC2
    , "int",x2, "int",y2, "uint",0xCC0020)
  DllCall("SelectObject", "Ptr",mDC2, "Ptr",oBM2)
  DllCall("DeleteDC", "Ptr",mDC2)
  DllCall("SelectObject", "Ptr",mDC1, "Ptr",oBM1)
  DllCall("DeleteDC", "Ptr",mDC1)
}
CopyBits(Scan01,Stride1,x1,y1,Scan02,Stride2,x2,y2,w2,h2,Reverse:=0)
{
  local
  if (w2<1 or h2<1 or !Scan01 or !Scan02)
    return
  p1:=Scan01+(y1-1)*Stride1+x1*4
  , p2:=Scan02+(y2-1)*Stride2+x2*4, w2*=4
  if (Reverse)
    p2+=(h2+1)*Stride2, Stride2:=-Stride2
  Loop % h2
    DllCall("RtlMoveMemory","Ptr",p1+=Stride1,"Ptr",p2+=Stride2,"Ptr",w2)
}
; 绑定窗口从而可以后台查找这个窗口的图像
; 相当于始终在前台。解绑窗口使用 FindText().BindWindow(0)
BindWindow(bind_id:=0, bind_mode:=0, get_id:=0, get_mode:=0)
{
  local
  (!IsObject(this.bind) && this.bind:=[]), bind:=this.bind
  if (get_id)
    return bind.id
  if (get_mode)
    return bind.mode
  if (bind_id)
  {
    bind.id:=bind_id, bind.mode:=bind_mode, bind.oldStyle:=0
    if (bind_mode & 1)
    {
      WinGet, oldStyle, ExStyle, ahk_id %bind_id%
      bind.oldStyle:=oldStyle
      WinSet, Transparent, 255, ahk_id %bind_id%
      Loop 30
      {
        Sleep, 100
        WinGet, i, Transparent, ahk_id %bind_id%
      }
      Until (i=255)
    }
  }
  else
  {
    bind_id:=bind.id
    if (bind.mode & 1)
      WinSet, ExStyle, % bind.oldStyle, ahk_id %bind_id%
    bind.id:=0, bind.mode:=0, bind.oldStyle:=0
  }
}
; 使用 FindText().CaptureCursor(1) 设置抓图时捕获鼠标
; 使用 FindText().CaptureCursor(0) 取消抓图时捕获鼠标
CaptureCursor(hDC:=0, zx:=0, zy:=0, zw:=0, zh:=0, get_cursor:=0)
{
  local
  if (get_cursor)
    return this.Cursor
  if (hDC=1 or hDC=0) and (zw=0)
  {
    this.Cursor:=hDC
    return
  }
  VarSetCapacity(mi, 40, 0), NumPut(16+A_PtrSize, mi, "int")
  DllCall("GetCursorInfo", "Ptr",&mi)
  bShow   := NumGet(mi, 4, "int")
  hCursor := NumGet(mi, 8, "Ptr")
  x := NumGet(mi, 8+A_PtrSize, "int")
  y := NumGet(mi, 12+A_PtrSize, "int")
  if (!bShow) or (x<zx or y<zy or x>=zx+zw or y>=zy+zh)
    return
  VarSetCapacity(ni, 40, 0)
  DllCall("GetIconInfo", "Ptr",hCursor, "Ptr",&ni)
  xCenter  := NumGet(ni, 4, "int")
  yCenter  := NumGet(ni, 8, "int")
  hBMMask  := NumGet(ni, (A_PtrSize=8?16:12), "Ptr")
  hBMColor := NumGet(ni, (A_PtrSize=8?24:16), "Ptr")
  DllCall("DrawIconEx", "Ptr",hDC
    , "int",x-xCenter-zx, "int",y-yCenter-zy, "Ptr",hCursor
    , "int",0, "int",0, "int",0, "int",0, "int",3)
  DllCall("DeleteObject", "Ptr",hBMMask)
  DllCall("DeleteObject", "Ptr",hBMColor)
}
MCode(ByRef code, hex)
{
  local
  SetBatchLines, % (bch:=A_BatchLines)?"-1":"-1"
  VarSetCapacity(code, len:=StrLen(hex)//2)
  Loop % len
    NumPut("0x" SubStr(hex,2*A_Index-1,2),code,A_Index-1,"uchar")
  DllCall("VirtualProtect","Ptr",&code,"Ptr",len,"uint",0x40,"Ptr*",0)
  SetBatchLines, %bch%
}
base64tobit(s)
{
  local
  Chars:="0123456789+/ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    . "abcdefghijklmnopqrstuvwxyz"
  SetFormat, IntegerFast, d
  Loop Parse, Chars
  {
    s:=RegExReplace(s, "[" A_LoopField "]"
    , ((i:=A_Index-1)>>5&1) . (i>>4&1)
    . (i>>3&1) . (i>>2&1) . (i>>1&1) . (i&1))
  }
  return RegExReplace(RegExReplace(s,"[^01]+"),"10*$")
}
bit2base64(s)
{
  local
  s:=RegExReplace(s,"[^01]+")
  s.=SubStr("100000",1,6-Mod(StrLen(s),6))
  s:=RegExReplace(s,".{6}","|$0")
  Chars:="0123456789+/ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    . "abcdefghijklmnopqrstuvwxyz"
  SetFormat, IntegerFast, d
  Loop Parse, Chars
  {
    s:=StrReplace(s, "|" . ((i:=A_Index-1)>>5&1)
    . (i>>4&1) . (i>>3&1) . (i>>2&1) . (i>>1&1) . (i&1)
    , A_LoopField)
  }
  return s
}
xywh2xywh(x1,y1,w1,h1, ByRef x, ByRef y, ByRef w, ByRef h
  , ByRef zx:="", ByRef zy:="", ByRef zw:="", ByRef zh:="")
{
  SysGet, zx, 76
  SysGet, zy, 77
  SysGet, zw, 78
  SysGet, zh, 79
  w:=Min(x1+w1,zx+zw), x:=Max(x1,zx), w-=x
  , h:=Min(y1+h1,zy+zh), y:=Max(y1,zy), h-=y
}
ASCII(s)
{
  local
  if RegExMatch(s,"\$(\d+)\.([\w+/]+)",r)
  {
    s:=RegExReplace(this.base64tobit(r2),".{" r1 "}","$0`n")
    s:=StrReplace(StrReplace(s,"0","_"),"1","0")
  }
  else s:=""
  return s
}
; 可以在脚本的开头用 FindText().PicLib(Text,1) 导入字库,
; 然后使用 FindText().PicLib("说明文字1|说明文字2|...") 获取字库中的数据
PicLib(comments, add_to_Lib:=0, index:=1)
{
  local
  (!IsObject(this.Lib) && this.Lib:=[]), Lib:=this.Lib
  , (!Lib[index] && Lib[index]:=[]), Lib:=Lib[index]
  if (add_to_Lib)
  {
    re:="<([^>\n]*)>[^$\n]+\$[^""\r\n]+"
    Loop Parse, comments, |
      if RegExMatch(A_LoopField,re,r)
      {
        s1:=Trim(r1), s2:=""
        Loop Parse, s1
          s2.="_" . Format("{:d}",Ord(A_LoopField))
        Lib[s2]:=r
      }
    Lib[""]:=""
  }
  else
  {
    Text:=""
    Loop Parse, comments, |
    {
      s1:=Trim(A_LoopField), s2:=""
      Loop Parse, s1
        s2.="_" . Format("{:d}",Ord(A_LoopField))
      Text.="|" . Lib[s2]
    }
    return Text
  }
}
; 分割字符串为单个文字并获取数据
PicN(Number, index:=1)
{
  return this.PicLib(RegExReplace(Number,".","|$0"), 0, index)
}
; 使用 FindText().PicX(Text) 可以将文字分割成多个单字的组合，从而适应间隔变化
; 但是不能用于“颜色位置二值化”模式, 因为位置是与整体图像相关的
PicX(Text)
{
  local
  if !RegExMatch(Text,"(<[^$\n]+)\$(\d+)\.([\w+/]+)",r)
    return Text
  v:=this.base64tobit(r3), Text:=""
  c:=StrLen(StrReplace(v,"0"))<=StrLen(v)//2 ? "1":"0"
  txt:=RegExReplace(v,".{" r2 "}","$0`n")
  While InStr(txt,c)
  {
    While !(txt~="m`n)^" c)
      txt:=RegExReplace(txt,"m`n)^.")
    i:=0
    While (txt~="m`n)^.{" i "}" c)
      i:=Format("{:d}",i+1)
    v:=RegExReplace(txt,"m`n)^(.{" i "}).*","$1")
    txt:=RegExReplace(txt,"m`n)^.{" i "}")
    if (v!="")
      Text.="|" r1 "$" i "." this.bit2base64(v)
  }
  return Text
}
; 截屏，作为后续操作要用的“上一次的截屏”
ScreenShot(x1:=0, y1:=0, x2:=0, y2:=0)
{
  this.FindText(0, 0, x1, y1, x2, y2)
}
; 从“上一次的截屏”中快速获取指定坐标的RGB颜色
; 如果坐标超出了屏幕范围，将返回白色
GetColor(x, y, fmt:=1)
{
  local
  bits:=this.GetBitsFromScreen(0,0,0,0,0,zx,zy,zw,zh)
  , c:=(x<zx or x>=zx+zw or y<zy or y>=zy+zh or !bits.Scan0)
  ? 0xFFFFFF : NumGet(bits.Scan0+(y-zy)*bits.Stride+(x-zx)*4,"uint")
  return (fmt ? Format("0x{:06X}",c&0xFFFFFF) : c)
}
; 在“上一次的截屏”中设置点的RGB颜色
SetColor(x, y, color:=0x000000)
{
  local
  bits:=this.GetBitsFromScreen(0,0,0,0,0,zx,zy,zw,zh)
  if !(x<zx or x>=zx+zw or y<zy or y>=zy+zh or !bits.Scan0)
    NumPut(color,bits.Scan0+(y-zy)*bits.Stride+(x-zx)*4,"uint")
}
; 根据 FindText() 的结果识别一行文字或验证码
; offsetX 为两个文字的最大间隔，超过会插入*号
; offsetY 为两个文字的最大高度差
; overlapW 用于设置覆盖的宽度
; 最后返回数组:{text:识别结果, x:结果左上角X, y:结果左上角Y, w:宽, h:高}
Ocr(ok, offsetX:=20, offsetY:=20, overlapW:=0)
{
  local
  ocr_Text:=ocr_X:=ocr_Y:=min_X:=dx:=""
  For k,v in ok
    x:=v[1]
    , min_X:=(A_Index=1 or x<min_X ? x : min_X)
    , max_X:=(A_Index=1 or x>max_X ? x : max_X)
  While (min_X!="" and min_X<=max_X)
  {
    LeftX:=""
    For k,v in ok
    {
      x:=v[1], y:=v[2]
      if (x<min_X) or Abs(y-ocr_Y)>offsetY
        Continue
      ; Get the leftmost X coordinates
      if (LeftX="" or x<LeftX)
        LeftX:=x, LeftY:=y, LeftW:=v[3], LeftH:=v[4], LeftOCR:=v.id
    }
    if (LeftX="")
      Break
    if (ocr_X="")
      ocr_X:=LeftX, min_Y:=LeftY, max_Y:=LeftY+LeftH
    ; If the interval exceeds the set value, add "*" to the result
    ocr_Text.=(ocr_Text!="" and LeftX>dx ? "*":"") . LeftOCR
    ; Update for next search
    min_X:=LeftX+LeftW-(overlapW>LeftW//2 ? LeftW//2:overlapW)
    , dx:=LeftX+LeftW+offsetX, ocr_Y:=LeftY
    , (LeftY<min_Y && min_Y:=LeftY)
    , (LeftY+LeftH>max_Y && max_Y:=LeftY+LeftH)
  }
  return {text:ocr_Text, x:ocr_X, y:min_Y
    , w: min_X-ocr_X, h: max_Y-min_Y}
}
; 按照从左到右、从上到下的顺序排序FindText()的结果
; 忽略轻微的Y坐标差距，返回排序后的数组对象
Sort(ok, dy:=10)
{
  local
  if !IsObject(ok)
    return ok
  s:="", n:=150000, ypos:=[]
  For k,v in ok
  {
    x:=v.x, y:=v.y, add:=1
    For k1,v1 in ypos
    if Abs(y-v1)<=dy
    {
      y:=v1, add:=0
      Break
    }
    if (add)
      ypos.Push(y)
    s.=(y*n+x) "." k "|"
  }
  s:=Trim(s,"|")
  Sort, s, N D|
  ok2:=[]
  Loop Parse, s, |
    ok2.Push( ok[(StrSplit(A_LoopField,".")[2])] )
  return ok2
}
; 以指定点为中心，按从近到远排序FindText()的结果，返回排序后的数组
Sort2(ok, px, py)
{
  local
  if !IsObject(ok)
    return ok
  s:=""
  For k,v in ok
    s.=((v.x-px)**2+(v.y-py)**2) "." k "|"
  s:=Trim(s,"|")
  Sort, s, N D|
  ok2:=[]
  Loop Parse, s, |
    ok2.Push( ok[(StrSplit(A_LoopField,".")[2])] )
  return ok2
}
; 按指定的查找方向，排序FindText()的结果，返回排序后的数组
Sort3(ok, dir:=1)
{
  local
  if !IsObject(ok)
    return ok
  s:="", n:=150000
  For k,v in ok
    x:=v[1], y:=v[2]
    , s.=(dir=1 ? y*n+x
    : dir=2 ? y*n-x
    : dir=3 ? -y*n+x
    : dir=4 ? -y*n-x
    : dir=5 ? x*n+y
    : dir=6 ? x*n-y
    : dir=7 ? -x*n+y
    : dir=8 ? -x*n-y : y*n+x) "." k "|"
  s:=Trim(s,"|")
  Sort, s, N D|
  ok2:=[]
  Loop Parse, s, |
    ok2.Push( ok[(StrSplit(A_LoopField,".")[2])] )
  return ok2
}
; 提示某个坐标的位置，或远程控制中当前鼠标的位置
MouseTip(x:="", y:="", w:=10, h:=10, d:=4)
{
  local
  if (x="")
  {
    VarSetCapacity(pt,16,0), DllCall("GetCursorPos","ptr",&pt)
    x:=NumGet(pt,0,"uint"), y:=NumGet(pt,4,"uint")
  }
  Loop 4
  {
    this.RangeTip(x-w, y-h, 2*w+1, 2*h+1, (A_Index & 1 ? "Red":"Blue"), d)
    Sleep, 500
  }
  this.RangeTip()
}
; 显示范围的边框，类似于 ToolTip
RangeTip(x:="", y:="", w:="", h:="", color:="Red", d:=2)
{
  local
  static id:=0
  if (x="")
  {
    id:=0
    Loop 4
      Gui, Range_%A_Index%: Destroy
    return
  }
  if (!id)
  {
    Loop 4
      Gui, Range_%A_Index%: +Hwndid +AlwaysOnTop -Caption +ToolWindow
        -DPIScale +E0x08000000
  }
  x:=Floor(x), y:=Floor(y), w:=Floor(w), h:=Floor(h), d:=Floor(d)
  Loop 4
  {
    i:=A_Index
    , x1:=(i=2 ? x+w : x-d)
    , y1:=(i=3 ? y+h : y-d)
    , w1:=(i=1 or i=3 ? w+2*d : d)
    , h1:=(i=2 or i=4 ? h+2*d : d)
    Gui, Range_%i%: Color, %color%
    Gui, Range_%i%: Show, NA x%x1% y%y1% w%w1% h%h1%
  }
}
; 快速获取屏幕图像的搜索文本数据
GetTextFromScreen(x1, y1, x2, y2, Threshold:=""
  , ScreenShot:=1, ByRef rx:="", ByRef ry:="")
{
  local
  SetBatchLines, % (bch:=A_BatchLines)?"-1":"-1"
  x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
  this.GetBitsFromScreen(x,y,w,h,ScreenShot,zx,zy,zw,zh)
  if (w<1 or h<1)
  {
    SetBatchLines, %bch%
    return
  }
  gs:=[], k:=0
  Loop %h%
  {
    j:=y+A_Index-1
    Loop %w%
      i:=x+A_Index-1, c:=this.GetColor(i,j,0)
      , gs[++k]:=(((c>>16)&0xFF)*38+((c>>8)&0xFF)*75+(c&0xFF)*15)>>7
  }
  if InStr(Threshold,"**")
  {
    Threshold:=StrReplace(Threshold,"*")
    if (Threshold="")
      Threshold:=50
    s:="", sw:=w, w-=2, h-=2, x++, y++
    Loop %h%
    {
      y1:=A_Index
      Loop %w%
        x1:=A_Index, i:=y1*sw+x1+1, j:=gs[i]+Threshold
        , s.=( gs[i-1]>j || gs[i+1]>j
        || gs[i-sw]>j || gs[i+sw]>j
        || gs[i-sw-1]>j || gs[i-sw+1]>j
        || gs[i+sw-1]>j || gs[i+sw+1]>j ) ? "1":"0"
    }
    Threshold:="**" Threshold
  }
  else
  {
    Threshold:=StrReplace(Threshold,"*")
    if (Threshold="")
    {
      pp:=[]
      Loop 256
        pp[A_Index-1]:=0
      Loop % w*h
        pp[gs[A_Index]]++
      IP0:=IS0:=0
      Loop 256
        k:=A_Index-1, IP0+=k*pp[k], IS0+=pp[k]
      Threshold:=Floor(IP0/IS0)
      Loop 20
      {
        LastThreshold:=Threshold
        IP1:=IS1:=0
        Loop % LastThreshold+1
          k:=A_Index-1, IP1+=k*pp[k], IS1+=pp[k]
        IP2:=IP0-IP1, IS2:=IS0-IS1
        if (IS1!=0 and IS2!=0)
          Threshold:=Floor((IP1/IS1+IP2/IS2)/2)
        if (Threshold=LastThreshold)
          Break
      }
    }
    s:=""
    Loop % w*h
      s.=gs[A_Index]<=Threshold ? "1":"0"
    Threshold:="*" Threshold
  }
  ;--------------------
  w:=Format("{:d}",w), CutUp:=CutDown:=0
  re1:="(^0{" w "}|^1{" w "})"
  re2:="(0{" w "}$|1{" w "}$)"
  While RegExMatch(s,re1)
    s:=RegExReplace(s,re1), CutUp++
  While RegExMatch(s,re2)
    s:=RegExReplace(s,re2), CutDown++
  rx:=x+w//2, ry:=y+CutUp+(h-CutUp-CutDown)//2
  s:="|<>" Threshold "$" w "." this.bit2base64(s)
  ;--------------------
  SetBatchLines, %bch%
  return s
}
; 快速保存截图为BMP文件，可用于调试
SavePic(file, x1:=0, y1:=0, x2:=0, y2:=0, ScreenShot:=1)
{
  local
  if (x1*x1+y1*y1+x2*x2+y2*y2<=0)
    n:=150000, x:=y:=-n, w:=h:=2*n
  else
    x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
  bits:=this.GetBitsFromScreen(x,y,w,h,ScreenShot,zx,zy), x-=zx, y-=zy
  if (w<1 or h<1 or !bits.Scan0)
    return
  hBM:=this.CreateDIBSection(w, -h, bpp:=24, ppvBits, bi)
  hBM2:=this.CreateDIBSection(w, h, 32, Scan0), Stride:=w*4
  this.CopyBits(Scan0,Stride,0,0,bits.Scan0,bits.Stride,x,y,w,h)
  this.CopyHBM(hBM, 0, 0, hBM2, 0, 0, w, h)
  DllCall("DeleteObject", "Ptr",hBM2)
  size:=((w*bpp+31)//32)*4*h, NumPut(size, bi, 20, "uint")
  VarSetCapacity(bf, 14, 0), StrPut("BM", &bf, "CP0")
  NumPut(54+size, bf, 2, "uint"), NumPut(54, bf, 10, "uint")
  f:=FileOpen(file,"w"), f.RawWrite(bf,14), f.RawWrite(bi,40)
  , f.RawWrite(ppvBits+0, size), f.Close()
  DllCall("DeleteObject", "Ptr",hBM)
}
; 显示保存的图像
ShowPic(file:="", show:=1, ByRef x:="", ByRef y:="", ByRef w:="", ByRef h:="")
{
  local
  if (file="")
  {
    this.ShowScreenShot()
    return
  }
  if !FileExist(file) or !(hBM:=LoadPicture(file))
    return
  this.GetBitmapWH(hBM, w, h)
  bits:=this.GetBitsFromScreen(0,0,0,0,0,x,y)
  if (w<1 or h<1 or !bits.Scan0)
  {
    DllCall("DeleteObject", "Ptr",hBM)
    return
  }
  hBM2:=this.CreateDIBSection(w, h, 32, Scan0), Stride:=w*4
  this.CopyHBM(hBM2, 0, 0, hBM, 0, 0, w, h)
  this.CopyBits(bits.Scan0,bits.Stride,0,0,Scan0,Stride,0,0,w,h)
  DllCall("DeleteObject", "Ptr",hBM2)
  DllCall("DeleteObject", "Ptr",hBM)
  if (show)
    this.ShowScreenShot(x, y, x+w-1, y+h-1, 0)
}
; 显示内存中的屏幕截图用于调试
ShowScreenShot(x1:=0, y1:=0, x2:=0, y2:=0, ScreenShot:=1)
{
  local
  static hPic, oldw, oldh
  if (x1*x1+y1*y1+x2*x2+y2*y2<=0)
  {
    Gui, FindText_Screen: Destroy
    return
  }
  x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
  bits:=this.GetBitsFromScreen(x,y,w,h,ScreenShot,zx,zy), x-=zx, y-=zy
  if (w<1 or h<1 or !bits.Scan0)
    return
  hBM:=this.CreateDIBSection(w, h, 32, Scan0), Stride:=w*4
  this.CopyBits(Scan0,Stride,0,0,bits.Scan0,bits.Stride,x,y,w,h)
  ;---------------
  Gui, FindText_Screen: +LastFoundExist
  IfWinNotExist
  {
    Gui, FindText_Screen: +AlwaysOnTop -Caption +ToolWindow -DPIScale +E0x08000000
    Gui, FindText_Screen: Margin, 0, 0
    Gui, FindText_Screen: Add, Pic, HwndhPic w%w% h%h%
    Gui, FindText_Screen: Show, NA x%zx% y%zy% w%w% h%h%, Show Pic
    oldw:=w, oldh:=h
  }
  else if (oldw!=w or oldh!=h)
  {
    oldw:=w, oldh:=h
    GuiControl, FindText_Screen: Move, %hPic%, w%w% h%h%
    Gui, FindText_Screen: Show, NA w%w% h%h%
  }
  mDC:=DllCall("CreateCompatibleDC", "Ptr",0, "Ptr")
  oBM:=DllCall("SelectObject", "Ptr",mDC, "Ptr",hBM, "Ptr")
  DllCall("BitBlt", "Ptr",mDC, "int",0, "int",0, "int",w, "int",h
    , "Ptr",mDC, "int",0, "int",0, "uint",0xC000CA) ; MERGECOPY
  ;---------------
  hDC:=DllCall("GetDC", "Ptr",hPic, "Ptr")
  DllCall("BitBlt", "Ptr",hDC, "int",0, "int",0, "int",w, "int",h
    , "Ptr",mDC, "int",0, "int",0, "uint",0xCC0020)
  DllCall("ReleaseDC", "Ptr",hPic, "Ptr",hDC)
  ;---------------
  DllCall("SelectObject", "Ptr",mDC, "Ptr",oBM)
  DllCall("DeleteDC", "Ptr",mDC)
  DllCall("DeleteObject", "Ptr",hBM)
}
; 等待几秒钟直到屏幕图像改变，需要先调用FindText().ScreenShot()
WaitChange(time:=-1, x1:=0, y1:=0, x2:=0, y2:=0)
{
  local
  hash:=this.GetPicHash(x1, y1, x2, y2, 0)
  timeout:=A_TickCount+Round(time*1000)
  Loop
  {
    if (hash!=this.GetPicHash(x1, y1, x2, y2, 1))
      return 1
    if (time>=0 and A_TickCount>=timeout)
      Break
    Sleep, 10
  }
  return 0
}
GetPicHash(x1:=0, y1:=0, x2:=0, y2:=0, ScreenShot:=1)
{
  local
  static h:=DllCall("LoadLibrary", "Str","ntdll", "Ptr")
  if (x1*x1+y1*y1+x2*x2+y2*y2<=0)
    n:=150000, x:=y:=-n, w:=h:=2*n
  else
    x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
  bits:=this.GetBitsFromScreen(x,y,w,h,ScreenShot,zx,zy), x-=zx, y-=zy
  if (w<1 or h<1 or !bits.Scan0)
    return 0
  hash:=0, Stride:=bits.Stride, p:=bits.Scan0+(y-1)*Stride+x*4, w*=4
  Loop % h
    hash:=(hash*31+DllCall("ntdll\RtlComputeCrc32", "uint",0
      , "Ptr",p+=Stride, "uint",w, "uint"))&0xFFFFFFFF
  return hash
}
WindowToScreen(ByRef x, ByRef y, x1, y1, id:="")
{
  local
  WinGetPos, winx, winy,,, % id ? "ahk_id " id : "A"
  x:=x1+Floor(winx), y:=y1+Floor(winy)
}
ScreenToWindow(ByRef x, ByRef y, x1, y1, id:="")
{
  local
  this.WindowToScreen(dx,dy,0,0,id), x:=x1-dx, y:=y1-dy
}
ClientToScreen(ByRef x, ByRef y, x1, y1, id:="")
{
  local
  if (!id)
    WinGet, id, ID, A
  VarSetCapacity(pt,8,0), NumPut(0,pt,"int64")
  , DllCall("ClientToScreen", "Ptr",id, "Ptr",&pt)
  , x:=x1+NumGet(pt,"int"), y:=y1+NumGet(pt,4,"int")
}
ScreenToClient(ByRef x, ByRef y, x1, y1, id:="")
{
  local
  this.ClientToScreen(dx,dy,0,0,id), x:=x1-dx, y:=y1-dy
}
; 不像 FindText 总是使用屏幕坐标，它使用与内置命令
; ImageSearch 一样的 CoordMode 设置的坐标模式
ImageSearch(ByRef rx, ByRef ry, x1, y1, x2, y2, text
  , ScreenShot:=1, FindAll:=0)
{
  local
  dx:=dy:=0
  if (A_CoordModePixel="Window")
    this.WindowToScreen(dx,dy,0,0)
  else if (A_CoordModePixel="Client")
    this.ClientToScreen(dx,dy,0,0)
  if FileExist(pic:=RegExReplace(text,"\*\S+\s+"))
    text:="|<>##10$" pic
  if (ok:=this.FindText(x, y, x1+dx, y1+dy, x2+dx, y2+dy
    , 0, 0, text, ScreenShot, FindAll))
  {
    For k,v in ok  ; you can use ok:=FindText().ok
      v[1]-=dx, v[2]-=dy, v.x-=dx, v.y-=dy
    rx:=x-dx, ry:=y-dy, ErrorLevel:=0
    return 1
  }
  else
  {
    rx:=ry:="", ErrorLevel:=1
    return 0
  }
}
Click(x:="", y:="", other:="")
{
  local
  bak:=A_CoordModeMouse
  CoordMode, Mouse, Screen
  MouseMove, x, y, 0
  Click, %x%, %y%, %other%
  CoordMode, Mouse, %bak%
}
; 动态运行AHK代码作为新线程
Class Thread
{
  __New(args*)
  {
    this.pid:=this.Exec(args*)
  }
  __Delete()
  {
    DetectHiddenWindows, On
    WinWait, % "ahk_pid " this.pid,, 0.5
    IfWinExist, % "ahk_class AutoHotkey ahk_pid " this.pid
    {
      PostMessage, 0x111, 65307
      WinWaitClose,,, 0.5
    }
    Process, Close, % this.pid
  }
  Exec(s, Ahk:="", args:="")
  {
    local
    Ahk:=Ahk ? Ahk:A_IsCompiled ? A_ScriptDir "\AutoHotkey.exe":A_AhkPath
    s:="`nDllCall(""SetWindowText"",""Ptr"",A_ScriptHwnd,""Str"",""<AHK>"")`n"
      . "`nSetBatchLines,-1`n" . StrReplace(s,"`r")
    Try
    {
      shell:=ComObjCreate("WScript.Shell")
      oExec:=shell.Exec("""" Ahk """ /force * " args)
      oExec.StdIn.Write(s)
      oExec.StdIn.Close(), pid:=oExec.ProcessID
    }
    Catch
    {
      f:=A_Temp "\~ahk.tmp"
      s:="`n FileDelete, " f "`n" s
      FileDelete, %f%
      FileAppend, %s%, %f%
      r:=this.Clear.Bind(this)
      SetTimer, %r%, -3000
      Run, "%Ahk%" /force "%f%" %args%,, UseErrorLevel, pid
    }
    return pid
  }
  Clear()
  {
    FileDelete, % A_Temp "\~ahk.tmp"
    SetTimer,, Off
  }
}
; FindText().QPC() 用法类似于 A_TickCount
QPC()
{
  static f:=0, c:=DllCall("QueryPerformanceFrequency","Int*",f)+(f/=1000)
  return (!DllCall("QueryPerformanceCounter","Int64*",c))*0+(c/f)
}
; FindText().ToolTip() 用法类似于 ToolTip
ToolTip(s:="", x:="", y:="", num:=1, arg:="")
{
  local
  static ini:=[], ToolTipOff:=""
  f:= "ToolTip_" . Round(num)
  if (s="")
  {
    ini.Delete(f)
    Gui, %f%: Destroy
    return
  }
  ;-----------------
  r1:=A_CoordModeToolTip
  r2:=A_CoordModeMouse
  CoordMode, Mouse, Screen
  MouseGetPos, x1, y1
  CoordMode, Mouse, %r1%
  MouseGetPos, x2, y2
  CoordMode, Mouse, %r2%
  x:=Round(x="" ? x1+16 : x+x1-x2)
  y:=Round(y="" ? y1+16 : y+y1-y2)
  ;-----------------
  bgcolor:=arg.bgcolor!="" ? arg.bgcolor : "FAFBFC"
  color:=arg.color!="" ? arg.color : "Black"
  font:=arg.font ? arg.font : "Consolas"
  size:=arg.size ? arg.size : "10"
  bold:=arg.bold ? arg.bold : ""
  trans:=arg.trans!="" ? Round(arg.trans & 255) : 255
  timeout:=arg.timeout!="" ? arg.timeout : ""
  ;-----------------
  r:=bgcolor "|" color "|" font "|" size "|" bold "|" trans "|" s
  if (ini[f]!=r)
  {
    ini[f]:=r
    Gui, %f%: Destroy
    Gui, %f%: +AlwaysOnTop -Caption +ToolWindow
      -DPIScale +Hwndid +E0x80020
    Gui, %f%: Margin, 2, 2
    Gui, %f%: Color, %bgcolor%
    Gui, %f%: Font, c%color% s%size% %bold%, %font%
    Gui, %f%: Add, Text,, %s%
    Gui, %f%: Show, Hide, %f%
    ;------------------
    dhw:=A_DetectHiddenWindows
    DetectHiddenWindows, On
    WinSet, Transparent, %trans%, ahk_id %id%
    DetectHiddenWindows, %dhw%
  }
  Gui, %f%: +AlwaysOnTop
  Gui, %f%: Show, NA x%x% y%y%
  if (timeout)
  {
    if (!ToolTipOff)
      ToolTipOff:=this.ToolTip.Bind(this,"")
    SetTimer, %ToolTipOff%, % -Round(Abs(timeout*1000))-1
  }
}
; FindText().ObjView() 查看对象的值用于调试
ObjView(obj, keyname="")
{
  local
  if IsObject(obj)  ; thanks lexikos's type(v)
  {
    s:=""
    For k,v in obj
      s.=this.ObjView(v, keyname "[" (StrLen(k)>1000
      || [k].GetCapacity(1) ? """" k """":k) "]")
  }
  else
    s:=keyname ": " (StrLen(obj)>1000
    || [obj].GetCapacity(1) ? """" obj """":obj) "`n"
  if (keyname!="")
    return s
  ;------------------
  Gui, Gui_DeBug_Gui: Destroy
  Gui, Gui_DeBug_Gui: +AlwaysOnTop +Hwndid
  Gui, Gui_DeBug_Gui: Add, Button, y270 w350 gCancel Default, OK
  Gui, Gui_DeBug_Gui: Add, Edit, xp y10 w350 h250 -Wrap -WantReturn
  GuiControl, Gui_DeBug_Gui:, Edit1, %s%
  Gui, Gui_DeBug_Gui: Show,NA, Debug view object values
  DetectHiddenWindows, Off
  WinWaitClose, ahk_id %id%
  Gui, Gui_DeBug_Gui: Destroy
}
}
;================= The End =================


/*
BlockKeyboardInputs(state = "On"){
	static keys ;所有按键的变量
	keys=RButton,MButton,WheelDown,WheelUp,WheelLeft,WheelRight,XButton1,XButton2,Space,Enter,Ctrl,Alt,Shift,Tab,Esc,BackSpace,Del,Ins,Home,End,PgDn,PgUp,Up,Down,Left,Right,CtrlBreak,ScrollLock,PrintScreen,CapsLock,Pause,AppsKey,LWin,LWin,NumLock,Numpad0,Numpad1,Numpad2,Numpad3,Numpad4,Numpad5,Numpad6,Numpad7,Numpad8,Numpad9,NumpadDot,NumpadDiv,NumpadMult,NumpadAdd,NumpadSub,NumpadEnter,NumpadIns,NumpadEnd,NumpadDown,NumpadPgDn,NumpadLeft,NumpadClear,NumpadRight,NumpadHome,NumpadUp,NumpadPgUp,NumpadDel,Media_Next,Media_Play_Pause,Media_Prev,Media_Stop,Volume_Down,Volume_Up,Volume_Mute,Browser_Back,Browser_Favorites,Browser_Home,Browser_Refresh,Browser_Search,Browser_Stop,Launch_App1,Launch_App2,Launch_Mail,Launch_Media,F1,F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F12,1,2,3,4,5,6,7,8,9,0,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,?,&,é,",',(,-,è,_,?,à,),=,$,?,ù,*,~,#,{,[,|,``,\,^,@,],},;,:,!,?,.,/,§,<,>,vkBC
	Loop,Parse,keys, `,
	{
		Hotkey, *%A_LoopField%, KeyboardDummyLabel, %state% UseErrorLevel ;禁用按键
		If GetKeystate(A_Loopfield, "P") ;放开按键
			Send % "{" A_Loopfield " Up}" ;放开按键
		Return
	}
	KeyboardDummyLabel: ; hotkeys need a label, so give them one that do nothing
	Return
}
*/

OnExit:
	ExitApp
return

GuiClose:
	ExitApp
return
