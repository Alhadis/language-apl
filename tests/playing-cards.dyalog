∇  Solitaire;i;j;cbk;n;bkg;ep;c

⍝ Display Card Table
CardTable
'fm' ⎕wi 'caption' 'Solitaire'

⍝ Get the card back bitmap
cbk←MakeCardDLL 62

⍝ Get the empty pile bitmap
ep←MakeCardDLL 53

⍝ Select 10 cards at random
c←10?52

⍝ Display discard piles
:for i :in ⍳4
	bkg←(∼∆bkg)×⎕wi 'Get' 7 (180+86×i) 96 71
	⎕wi 'Put' (bkg+∆bkg×(1↑,bkg)×∼ep=0) 7 (180+86×i)
:endfor

⍝ Display draw pile
:for i :in ⍳3
	bkg←(∼∆bkg)×⎕wi 'Get' (5+2×i) (5+2×i) 96 71
	⎕wi 'Put' (bkg+cbk) (5+2×i) (5+2×i)
:endfor

⍝ Display first three cards drawn
:for i :in ⍳3
	bkg←(∼∆bkg)×⎕wi 'Get' (7+2×i) (80+15×i) 96 71
	⎕wi 'Put' (bkg+MakeCardDLL c[i]) (7+2×i) (80+15×i)
:endfor

⍝ Display the seven initial deal piles
:for i :in ⍳7

⍝ Face down cards
	:for j :in ⍳i-1
		bkg←(∼∆bkg)×⎕wi 'Get'(130+3×j) (7+86×i-1) 96 71
		⎕wi 'Put' (bkg+cbk) (130+3×j) (7+86×i-1)
	:endfor

⍝ Face up cards
	bkg←(∼∆bkg)×⎕wi 'Get' (130+3×i) (7+86×i-1) 96 71
	⎕wi 'Put' (bkg+MakeCardDLL c[i+3]) (130+3×i) (7+86×i-1)
:endfor

'fm' ⎕wi 'visible' 1

 ∇
