!addplugindir `${PACKAGE}\Other\Source\Plugins`

${SegmentFile}

Var Exists_LEGACY_SMARTDEFRAGDRIVER
Var Exists_Services_SmartDefragBootTime
Var Exists_Services_SmartDefragDriver
Var Exists_SmartDefrag3_Update_Scheduled_Task
Var Exists_SmartDefrag_AutoAnalyze_Scheduled_Task
Var Exists_SmartDefrag_Update_Scheduled_Task

${SegmentPrePrimary}
	${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\SmartDefragBootTime" $R0
	${If} $R0 = 0
		StrCpy $Exists_Services_SmartDefragBootTime true
	${EndIf}
	
	${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\SmartDefragDriver" $R0
	${If} $R0 = 0
		StrCpy $Exists_Services_SmartDefragDriver true
	${EndIf}
	
	${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_SMARTDEFRAGDRIVER" $R0
	${If} $R0 = 0
		StrCpy $Exists_LEGACY_SMARTDEFRAGDRIVER true
	${EndIf}

	${If} ${FileExists} "$SYSDIR\Tasks\SmartDefrag3_Update"
		StrCpy $Exists_SmartDefrag3_Update_Scheduled_Task true
	${EndIf}
	
	${If} ${FileExists} "$SYSDIR\Tasks\SmartDefrag_AutoAnalyze"
		StrCpy $Exists_SmartDefrag_AutoAnalyze_Scheduled_Task true
	${EndIf}
	
	${If} ${FileExists} "$SYSDIR\Tasks\SmartDefrag_Update"
		StrCpy $Exists_SmartDefrag_Update_Scheduled_Task true
	${EndIf}
	
	Rename "$WINDIR\Tasks\SmartDefrag3_Update.job" "$WINDIR\Tasks\SmartDefrag3_Update-BackUpBySmartDefragPortable.job"
	Rename "$WINDIR\Tasks\SmartDefrag4_Update.job" "$WINDIR\Tasks\SmartDefrag4_Update-BackUpBySmartDefragPortable.job"
	Rename "$WINDIR\Tasks\SmartDefrag5_Update.job" "$WINDIR\Tasks\SmartDefrag5_Update-BackUpBySmartDefragPortable.job"
	Rename "$WINDIR\Tasks\SmartDefrag_Schedule.job" "$WINDIR\Tasks\SmartDefrag_Schedule-BackUpBySmartDefragPortable.job"
	Rename "$WINDIR\Tasks\SmartDefrag_Startup.job" "$WINDIR\Tasks\SmartDefrag_Startup-BackUpBySmartDefragPortable.job"
	Rename "$WINDIR\Tasks\SmartDefragUpdate.job" "$WINDIR\Tasks\SmartDefragUpdate-BackUpBySmartDefragPortable.job"
	Rename "$WINDIR\system32\drivers\SmartDefragDriver.sys" "$WINDIR\system32\drivers\SmartDefragDriver-BackUpBySmartDefragPortable.sys"
	Rename "$WINDIR\system32\SmartDefragBootTime.exe" "$WINDIR\system32\SmartDefragBootTime-BackUpBySmartDefragPortable.exe"
	;Rename "$WINDIR\system32\IObitSmartDefragExtension.dll" "$WINDIR\system32\IObitSmartDefragExtension-BackUpBySmartDefragPortable.dll"
!macroend

${SegmentPostPrimary}
	${IfNot} $Exists_LEGACY_SMARTDEFRAGDRIVER == true
		${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_SMARTDEFRAGDRIVER" $R0
		${If} $R0 = 0
			AccessControl::GrantOnRegKey HKLM "SYSTEM\CurrentControlSet\Enum\Root\LEGACY_SMARTDEFRAGDRIVER" "(BU)" "FullAccess"
			Pop $R0
			${If} $R0 == error
				Pop $R0
				;MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
			${Else}
				${registry::DeleteKey} "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_SMARTDEFRAGDRIVER" $R0
			${EndIf}
		${EndIf}
	${EndIf}
	
	${IfNot} $Exists_Services_SmartDefragDriver == true
		${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\SmartDefragDriver" $R0
		${If} $R0 = 0
			AccessControl::GrantOnRegKey HKLM "SYSTEM\CurrentControlSet\Services\SmartDefragDriver" "(BU)" "FullAccess"
			Pop $R0
			${If} $R0 == error
				Pop $R0
				;MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
			${Else}
				${registry::DeleteKey} "HKLM\SYSTEM\CurrentControlSet\Services\SmartDefragDriver" $R0
			${EndIf}
		${EndIf}
	${EndIf}

	${IfNot} $Exists_Services_SmartDefragBootTime == true
		${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\SmartDefragBootTime" $R0
		${If} $R0 = 0
			AccessControl::GrantOnRegKey HKLM "SYSTEM\CurrentControlSet\Services\SmartDefragBootTime" "(BU)" "FullAccess"
			Pop $R0
			${If} $R0 == error
				Pop $R0
				;MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
			${Else}
				${registry::DeleteKey} "HKLM\SYSTEM\CurrentControlSet\Services\SmartDefragBootTime" $R0
			${EndIf}
		${EndIf}
	${EndIf}
	
	
	${If} $Exists_SmartDefrag3_Update_Scheduled_Task != true
		nsExec::Exec /TIMEOUT=10000 `"schtasks.exe" /delete /tn SmartDefrag3_Update /f`
		Pop $0
	${EndIf}
	
	${If} $Exists_SmartDefrag_AutoAnalyze_Scheduled_Task != true
		nsExec::Exec /TIMEOUT=10000 `"schtasks.exe" /delete /tn SmartDefrag_AutoAnalyze /f`
		Pop $0
	${EndIf}
	
	${If} $Exists_SmartDefrag_Update_Scheduled_Task != true
		nsExec::Exec /TIMEOUT=10000 `"schtasks.exe" /delete /tn SmartDefrag_Update /f`
		Pop $0
	${EndIf}	
	
	Delete "$WINDIR\Tasks\SmartDefrag_Schedule.job"
	Delete "$WINDIR\Tasks\SmartDefrag_Startup.job"
	Delete "$WINDIR\Tasks\SmartDefragUpdate.job"
	Delete "$WINDIR\Tasks\SmartDefrag3_Update.job"
	Rename "$WINDIR\Tasks\SmartDefrag3_Update-BackUpBySmartDefragPortable.job" "$WINDIR\Tasks\SmartDefrag3_Update.job"
	Delete "$WINDIR\Tasks\SmartDefrag4_Update.job"
	Rename "$WINDIR\Tasks\SmartDefrag4_Update-BackUpBySmartDefragPortable.job" "$WINDIR\Tasks\SmartDefrag4_Update.job"
	Delete "$WINDIR\Tasks\SmartDefrag5_Update.job"
	Rename "$WINDIR\Tasks\SmartDefrag5_Update-BackUpBySmartDefragPortable.job" "$WINDIR\Tasks\SmartDefrag5_Update.job"
	Rename "$WINDIR\Tasks\SmartDefrag_Schedule-BackUpBySmartDefragPortable.job" "$WINDIR\Tasks\SmartDefrag_Schedule.job"
	Rename "$WINDIR\Tasks\SmartDefrag_Startup-BackUpBySmartDefragPortable.job" "$WINDIR\Tasks\SmartDefrag_Startup.job"
	Rename "$WINDIR\Tasks\SmartDefragUpdate-BackUpBySmartDefragPortable.job" "$WINDIR\Tasks\SmartDefragUpdate.job"
	Delete "$WINDIR\system32\drivers\SmartDefragDriver.sys"
	Rename "$WINDIR\system32\drivers\SmartDefragDriver-BackUpBySmartDefragPortable.sys" "$WINDIR\system32\drivers\SmartDefragDriver.sys"
	Delete "$WINDIR\system32\SmartDefragBootTime.exe"
	Rename "$WINDIR\system32\SmartDefragBootTime-BackUpBySmartDefragPortable.exe" "$WINDIR\system32\SmartDefragBootTime.exe"
	;Delete "$WINDIR\system32\IObitSmartDefragExtension.dll"
	;Rename "$WINDIR\system32\IObitSmartDefragExtension-BackUpBySmartDefragPortable.dll" "$WINDIR\system32\IObitSmartDefragExtension.dll"
	System::Call "wininet::DeleteUrlCacheEntryW(t'http://update.iobit.com/infofiles/smartdefrag/isd2update.upt')i .r2"
!macroend