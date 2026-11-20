:Class Name: Superclass, Interface, 'Interface'
	⍝ Comment
:EndClass


:Class Bird: 'Animal', FlyingCreature, WarmBlooded
	
:EndClass


:Class c1
:using System
	:attribute SerializableAttribute
	:attribute CLSCompliantAttribute 1

	∇ foo(p1 p2)
		:Access public instance
		:Signature String[]←Format Object Array
		:Attribute ObsoleteAttribute
	∇

	∇ goo(p1 p2)
		:Access public instance
		:Signature Int32[]←IndexGen Int32 N, Int32 Origin
		:Attribute ObsoleteAttribute 'Don''t use this' 1
	∇
:EndClass ⍝ c1

:Class KeyedFile: ComponentFile
	:Field Public Keys
	⎕ML←0

	∇ Open filename
		:Implements Constructor :Base filename
		:Access Public Instance
		:If Count>0
			Keys←{⊃⍵⊃⎕BASE.Component}¨⍳Count
		:Else
			Keys←0⍴⊂''
		:EndIf
	∇

	:Property Numbered Component
	:Access Public Instance
		∇ r←shape
			r←¯1+2⊃⎕FSIZE tie
		∇
		∇ r←get arg
			r←⎕FREAD tie arg.Indexers
		∇
		∇ set arg
			arg.NewValue ⎕FREPLACE tie,arg.Indexers
		∇
	:EndProperty

	:Property Numbered Default Component
	:Access Public Instance
		∇ r←shape
			r←¯1+2⊃⎕FSIZE tie
		∇
		∇ r←get arg
			r←⎕FREAD tie arg.Indexers
		∇
		∇ set arg
			arg.NewValue ⎕FREPLACE tie,arg.Indexers
		∇
	:EndProperty

	:Property Keyed Component
	:Access Public Instance
		∇ r←get arg;keys;sink
			keys←⊃arg.Indexers
			⎕SIGNAL(~^/keys∊Keys)/3
			r←{2⊃⍵⊃⎕BASE.Component}¨Keys⍳keys
		∇
		∇ set arg;new;keys;vals
			vals←arg.NewValue
			keys←⊃arg.Indexers
			⎕SIGNAL((⍴,keys)≠⍴,vals)/5
			:If ∨/new←~keys∊Keys
				sink←Append¨↓⍉↑(⊂new)/¨keys vals
				Keys,←new/keys
				keys vals/⍨←⊂~new
			:EndIf
			:If 0<⍴,keys
				Replace¨↓⍉↑(Keys⍳keys)(↓⍉↑keys vals)
			:EndIf
		∇
	:EndProperty
:EndClass ⍝ Class KeyedFile

)OFF
