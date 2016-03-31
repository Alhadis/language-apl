:Class Solitaire: 'Form'

	:Field Public Started←0
	:Field Public Won←0

	:Field Public Shared Rules
	∆←⊂'Object is to promote all the cards from the table and the pile onto the stacks'
	∆,←⊂'top right. The first cards to promote are the Aces; the stacks are then filled'
	∆,←⊂'by suit, in order, Ace to King.'
	∆,←⊂''
	∆,←⊂'Right-click on an exposed card to promote it. Cards in the table cannot be'
	∆,←⊂'promoted if they have cards below them.'
	∆,←⊂''
	∆,←⊂'Left-click on exposed cards to move them to the table. Only a King may be moved'
	∆,←⊂'to an empty column of the table.'
	∆,←⊂''
	∆,←⊂'Left-click on the pile to turn over three cards onto the discards. When the pile'
	∆,←⊂'is empty, left-click in its place to flip the discards over to make a new pile.'
	Rules←↑∆

⍝ ---------------------------------------------------- construction
	∇ makegame
		:Access Public
		:Implements Constructor :Base ('BCol'DKGREEN)('Coord' 'Pixel')
		
		:With MB←⎕NEW⊂'MenuBar'
			File Edit Help←{⎕NEW'Menu'(⊂'Caption'⍵)}¨'&File' '&Edit' '&Help'
			:With File
				New←⎕NEW'MenuItem'(⊂'Caption' 'New game')
				Ext←⎕NEW'MenuItem'(⊂'Caption' 'E&xit')
			:EndWith
			:With Edit
				Undo←⎕NEW'MenuItem'(('Caption' '&Undo')('Active' 0))
				Redo←⎕NEW'MenuItem'(('Caption' '&Redo')('Active' 0))
			:EndWith
			:With Help
				Hlp←⎕NEW'MenuItem'(⊂'Caption' '&Help…')
				Abt←⎕NEW'MenuItem'(⊂'Caption' '&About…')
			:EndWith
		:EndWith
		MB.File.(New Ext).onSelect←'NewGame' '⍎Close'
		MB.Help.(Abt Hlp).onSelect←'About' 'Help'
		
		⎕RL←1000⊥¯2↑⎕TS                                   ⍝ seed random link
		
		PACK←,{⎕NEW Card ⍵}¨SUITS∘.,VALUES                ⍝ uses private class
		CARDSZ←(⊃PACK).Size
		
		⍝ layout positions
		SEPN←CARDSZ+10 20                                 ⍝ horz & vert sepn
		TABL←,100 20∘+¨SEPN∘×¨i0 1,NCOLUMNS               ⍝ posns for Table tops
		PILE DISC STAX←{(1⊃⍵)(2⊃⍵)(3↓⍵)}20,¨2⊃¨TABL       ⍝ posns for stacks
		
		NewGame
	∇

⍝ ---------------------------------------------------- event handlers
	∇ MUHandler(this _ Y X btn _);col;MOVE;PROMOTE
		⍝ Handles MouseUp events
		⍝ Left clicks to move cards to/within the Table
		⍝ OR on Pile to turn cards
		⍝ Right clicks to promote cards
		⍝ Click L or R on Form in Pile space to turn cards
		:If this=⎕THIS
			Turn NCARDS×Y X inside PILE CARDSZ                    ⍝ DblClick on Form under Pile
		
		:Else
			MOVE PROMOTE←1 2                                      ⍝ left & right buttons
			:Select btn
			
			:Case MOVE
				:If this=⊃Pile
					Turn NCARDS
				:ElseIf (⍴Table)≥col←1⍳⍨(⊃∘⌽¨Table)canhold¨this
					Move this col
				:EndIf
			
			:Case PROMOTE
				:If this∊(⊃Discards),⊃∘⌽¨Table
				:AndIf this follows⊃Stacks⊃⍨SUITS⍳this.Suit
					Promote this
				:EndIf
			
			:EndSelect
		:EndIf
	∇

⍝ ---------------------------------------------------- public methods
	∇ About;∆
		:Access Public
		:With ⎕NEW'MsgBox'(('Caption' 'About Solitaire')('Style' 'Info'))
			∆←⊂'This implementation of the game of Solitaire illustrates'
			∆,←⊂'how to build an application in a Dyalog GUI class'
			∆,←⊂'using arrays of objects.'
			∆,←⊂''
			∆,←⊂'It is a stand-alone script, and requires neither'
			∆,←⊂'other classes nor .Net assemblies.'
			∆,←⊂''
			∆,←⊂'The code exemplifies the use of an informal DSL'
			∆,←⊂'(domain-specific language) to expose the logic'
			∆,←⊂'to a non-programming reader of the source code.'
			∆,←⊂''
			∆,←⊂'Version 1.0 • 15Apr2008 • Stephen Taylor'
			∆,←⊂''
			∆,←⊂'©2008 Dyalog Ltd'
			Text←∆
			Wait
		:EndWith
	∇

	∇ Arrange;qry;status                                          ⍝ Reflect the game state
		:Access Public
		status←(⍕Started),' started, ',(⍕Won),' won'
		Caption←'Solitaire: ',{'New game'}if{Started=1}status
		(Pile Discards,Stacks)stackedat¨PILE DISC,STAX            ⍝ arrange piles
		Table.Posn←TABL{⍺∘+¨0,⍨¨(⊃SEPN)×i0⍴⍵}¨Table               ⍝ arrange Table
		Size←400,⍨200⌈20+(⊃CARDSZ)+⌈/⊃¨(⊃∘⌽¨Table).Posn           ⍝ adjust form size
		PACK.(onMouseDblClick onMouseUp)←DISABLED                 ⍝ turn off handlers
		onMouseDblClick←DISABLED
		:If 0∊⍴Pile,Discards                                      ⍝ are we there yet?
		:AndIf ∧/(⊃,/Table).FaceUp
			Won+←1
			qry←'Congratulations, that’s a win!' 'New game?'
			:If confirm qry
				NewGame
			:Else
				Close                                             ⍝ TERMINATE
			:EndIf
		:Else                                                     ⍝ reassign handlers
			(⊃¨Pile Discards).onMouseDblClick←⊂'⍎Turn NCARDS'
			(⊃¨Pile Discards,Stacks).onMouseUp←⊂'MUHandler'
			({⍵/⍨⍵.FaceUp}⊃,/Table).onMouseUp←⊂'MUHandler'
			onMouseUp←{DISABLED}if{×⊃⍴Pile}'MUHandler'
		:EndIf
	∇

	∇ z←Display;∆                                               ⍝ text display
		:Access Public                                          ⍝ (devt tool)
		∆←⊂'Stacks: ',⍕⊃¨Stacks
		∆,←⊂⍕column¨Table
		∆,←⊂⍕⊃¨Pile Discards
		z←column ∆
	∇

	∇ Help
		:Access Public
		:With ⎕NEW'MsgBox'(('Style' 'Info')('Text'Rules))
			Caption←'Rules of Solitaire'
			Wait
		:EndWith
	∇

	⍝ Move and Promote:
	⍝    both take in their arguments either
	⍝    - card refs (eg Move card 3 or Promote card) OR
	⍝    - value/suit pairs (eg Move '3H' 3; or Promote 'K♠')
	⍝    Card refs are for internal call; V/S pairs for external.
	⍝    Calls are unvalidated: invalid calls will break.

	∇ Move(this dst);src;leave;card                             ⍝ move to or within Table
		:Access Public
		card←identify if notref this
		:If card=⊃Discards                                      ⍝ move from Discards to Table
			(dst⊃Table),←card
			Discards↓⍨←1
		:ElseIf card∊⊃¨Stacks                                   ⍝ move from Stacks to Table
			(dst⊃Table),←card
			src←SUITS⍳card.Suit
			(src⊃Stacks)↓⍨←1
		:Else                                                   ⍝ move within Table
			src←1⍳⍨card∘∊¨Table                                 ⍝ source column in Table
			leave←1-⍨(src⊃Table)⍳card                           ⍝ # of cards to leave
			(dst⊃Table),←leave↓src⊃Table                        ⍝ append to destn column
			(src⊃Table)↑⍨←leave                                 ⍝ remove from source column
			(⊃⌽src⊃Table).FaceUp←1                              ⍝ expose last card
		:EndIf
		Arrange
	∇

	∇ NewGame
		:Access Public
		Discards←0/PACK
		Stacks←(⍴SUITS)/⊂0/PACK                                 ⍝ a stack for each suit
		PACK.(FaceUp Visible)←⊂0 1
		Pile Table←NCOLUMNS deal shuffle PACK
		(⊃∘⌽¨Table).FaceUp←1                                    ⍝ expose last cards
		Started+←1
		Arrange
	∇

	∇ Promote this;suit;col;card                                ⍝ promote to Stacks
		:Access Public
		card←identify if notref this
		suit←SUITS⍳card.Suit                                    ⍝ index into Stacks
		:If card∊Discards
			(suit⊃Stacks),⍨←card
			Discards↓⍨←1
			(⊃Discards).Visible←1                               ⍝ expose new top card
		:ElseIf 7≥col←(⊃∘⌽¨Table)⍳card
			(suit⊃Stacks),⍨←card
			(col⊃Table)↓⍨←¯1
			(⊃⌽col⊃Table).FaceUp←1
		:EndIf
		Arrange
	∇

	∇ Turn ncards
		:Access Public
		:If 0∊⍴Pile
			Pile Discards←{(⌽⍵)(0/⍵)}Discards
			Pile.FaceUp←0
		:EndIf
		:If ncards>0
			Discards,⍨←⌽ncards{⍵↑⍨⍺⌊⍴⍵}Pile
			Discards.FaceUp←1
			Pile↓⍨←ncards
		:EndIf
		Arrange
	∇

⍝ ---------------------------------------------------- vocabulary
	if←{(⍺⍺⍣(⍵⍵ ⍵))⍵}                                         ⍝ syntactic sugar

	canhold←{
		⍺.Value=0:⍵.Value='K'                                 ⍝ empty column holds K
		(⍺ follows ⍵)∧⊃≢/(⍺ ⍵).Colour                         ⍝ prev card of opp. colour
	}

	column←{⍵⍴⍨⌽1,⍴⍵}

	confirm←{
		MB←⎕NEW'MsgBox'(⊂'Style' 'Query')
		MB.(Caption Text)←⍵
		MB.(onMsgBtn1 onMsgBtn2)←1
		'MsgBtn1'≡2⊃MB.Wait
	}

	cnvrt←⍎if{∧/⍵∊⎕D}

	∇ (pile table)←ncols deal cards;intbl
		⍝ deal cards into table with ncols; return rest as pile
		intbl←+/⍳ncols                                        ⍝ # of cards in table
		table←(⊃,/1↑⍨¨⍳ncols)⊂intbl↑cards                     ⍝ filled with cards
		pile←intbl↓cards                                      ⍝ rest
	∇

	follows←{
		0∊v←(⍺ ⍵).Value:v≡'A' 0                               ⍝ Ace follows (prototype Value)
		1=-/VALUES⍳v
	}

	i0←{⎕IO←0 ⋄ ⍳⍵}
	identify←{PACK⊃⍨PACK.(Value Suit)⍳,/translate ⍵}          ⍝ ref to card from (value suit)

	inside←{                                                  ⍝ is point ⍺ within a rectangle
		TL SZ←⍵                                               ⍝ defined by
		∧/⍺{1=+/⍺>⍵}¨TL+¨0,¨SZ                                ⍝ TL corner (yx coords)
	}

	notref←{9≠⊃⎕NC'⍵'}                                        ⍝ not an obj reference
	shuffle←{⍵[?⍨⍴⍵]}
	stackedat←{⍺.Posn←⊂⍵ ⋄ ⍺.Visible←1↑⍨⍴⍺}                   ⍝ colocate; show top card
	translate←{(cnvrt¯1↓⍵)((,⍨SUITS)⊃⍨(SUITS,ACRONYMS)⍳⊃⌽⍵)}  ⍝ regularise (value suit)

⍝ ---------------------------------------------------- constants
	:Field Public Shared ReadOnly COLOURS←4⍴'Black' 'Red'
	:Field Public Shared ReadOnly NCARDS←3                      ⍝ # of cards to turn over
	:Field Public Shared ReadOnly SUITS←⎕UCS 9800+24 29 27 30   ⍝ spades hearts clubs diamonds

	:Field Private Shared ReadOnly ACRONYMS←'SHCD'              ⍝ for suits
	:Field Private Shared ReadOnly DISABLED←¯1                  ⍝ no callback
	:Field Private Shared ReadOnly DKGREEN←0 64 0
	:Field Private Shared ReadOnly NCOLUMNS←7                   ⍝ # of columns in table
	:Field Private Shared ReadOnly VALUES←'A',(1↓⍳10),'JQK'

	:Field Private CARDSZ                                       ⍝ card size
	:Field Private DISC                                         ⍝ coords of Discards
	:Field Private PACK
	:Field Private PILE                                         ⍝ coords of Pile
	:Field Private SEPN                                         ⍝ separation of Table cards
	:Field Private STAX                                         ⍝ coords of Stacks

	⎕IO ⎕ML←1 0

⍝ ---------------------------------------------------- private properties
	:Field Private Discards                                     ⍝ list of cards
	:Field Private Pile                                         ⍝ list of cards
	:Field Private Stacks                                       ⍝ 4 lists of cards
	:Field Private Table


⍝ ==================================================== private class
	:Class Card: 'SubForm'

		:Field Public Colour←''
		:Field Public FaceUp←0
		:Field Public Suit←' '                                  ⍝ null suit
		:Field Public Value←0                                   ⍝ null value

		:Field Private Shared ReadOnly BLACK←0 0 0
		:Field Private Shared ReadOnly NAVY←0 0 128
		:Field Private Shared ReadOnly RED←255 0 0
		:Field Private Shared ReadOnly WHITE←255 255 255

	⍝ ------------------------------------------------ construction
		∇ makecard0
			:Access Public
			:Implements Constructor :Base
			⎕DF'⎕'                                                ⍝ null display
		∇

		∇ makecard1(suit value)
			:Access Public
			:Implements Constructor :Base ('BCol'(0 0 128))('Size'(40 30))
			Suit Value←suit value
			Colour←##.COLOURS⊃⍨##.SUITS⍳Suit
			⎕DF'⌹'
		∇

	⍝ ------------------------------------------------ trigger
		∇ expose;tag;fcol
			:Implements Trigger FaceUp
			:If FaceUp
				BCol←WHITE
				tag←⊃,/⍕¨Value Suit
				⎕DF Suit,⍨⍕Value
			:Else
				BCol←NAVY
				tag←''
				⎕DF'⌹'
			:EndIf
			fcol←⊃(Colour≡'Red')⌽BLACK RED
			Tag←⎕NEW'Text'(('FCol'fcol)('Points'(5 5))('Text'tag))
		∇

	:EndClass
⍝ ====================================================

:EndClass
