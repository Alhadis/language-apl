:Namespace DiaryStuff
:Using System
:Using System.Diagnostics,System.dll
:Using Microsoft.Win32,mscorlib.dll
:Class DiaryEntry
	:Field Public When
	:Field Public What
	∇ Make(ymdhm wot)
		:Access Public
		:Implements Constructor
		:Implements Trigger foo, bar, baz
		When What←(⎕NEW DateTime(6↑5↑ymdhm))wot
		⎕DF⍕When What
	∇
	∇ Make0
		:Access Public
		:Implements Constructor
		:Implements Trigger *
		When What←⎕NULL''
	∇
:EndClass ⍝ DiaryEntry
