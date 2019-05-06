⍝
⍝ Author:      Jürgen Sauermann
⍝ Date:        May 30, 2015
⍝ Copyright:   Copyright (C) 2015 by Jürgen Sauermann
⍝ License:     GPL see http://www.gnu.org/licenses/gpl-3.0.en.html
⍝ email:       bug-apl@gnu.org
⍝ Portability: L3 (GNU APL)
⍝
⍝ Purpose:
⍝ This workspace solves sudokus by applying rules as described in the 
⍝ tutorial www.ursoswald.ch/download/TUTORIAL.pdf by Urs Oswald
⍝
⍝ Description:
⍝
⍝ )LOAD ./sudoku.apl
⍝
⍝ -or-
⍝
⍝ apl -f ./sudoku.apl
⍝
⍝ You can then override one of the sudokus at the end of this file with
⍝ the one that you would like to solve


∆Log←1 3   ⍝ what shall be logged, 1-3 or ⍬ for nothing

I9←⍳9
∆Box←9 9⍴1 3 2 4⍉3 3 3 3⍴⍉∆Col←⍉∆Row←9 9⍴⍳81

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
∇A Log B
 →((A∈∆Log)↓0) ◊ B
∇
∇Z←RC F1;R1;C1
 ⍝
 ⍝ split F1 into string row:column
 ⍝
 (R1 C1)←1 + 9 9 ⊤ ""⍴F1-1 ◊ Z←(⍕R1),':',⍕C1
∇

∇Z1←RoBoCo F1;R0;C0;B0
 B0 ← 3 3 ⊥ , 1 2 ↑ 3 3 ⊤ (R0 C0)←9 9 ⊤ F1-1
 Z1←∪ ∆Row[R0+1;], ∆Col[C0+1;], ∆Box[B0+1;]
∇

∇Z1←B get_placed Fields;Placed
 Placed ← 1=+/Z1 ← B[Fields;]   ⍝ Placed: all Fields with exactly one candidate
 Z1 ← ∨⌿Placed⌿Z1
∇

∇Z←status B;FF;N1
 ⍝
 ⍝ check sudoku B. Return: 0: B is complete
 ⍝                         1: B has unplaced fields
 ⍝                         2: B has empty candidates
 ⍝                         3: B has duplicate candidates (→internal error)
 FF←+/B
 Z←2 ◊ →(0∈FF)/0   ⍝ empty candidates

 N1←0 ◊ Z←0
LOOP: →(9<N1←N1+1)/0
 Z←Z ⌈ B check_9 ∆Row[N1;] ◊ →(Z≥3)/0
 Z←Z ⌈ B check_9 ∆Col[N1;] ◊ →(Z≥3)/0
 Z←Z ⌈ B check_9 ∆Box[N1;] ◊ →(Z≥3)/0
 →LOOP
∇

∇Z←C check_9 FF
 C←C get_placed FF ◊ C←C/I9
 Z←9≠⍴C ◊ →(C≡∪C)/0 ◊ Z←3 ◊ +++
∇

∇Z←C can_place_digit B;F1;D1
 (F1 D1)←B ◊ Z←C[F1;D1]
∇

∇C←C place_digit B;D1;F1;Rule;RN
 ⍝
 ⍝ Let B = (Rule F1 D1). Place digit D1 into field F1 of candidate matrix C
 ⍝
 (RN Rule F1 D1)←B
 →(C[F1;D1])⍴1+↑⎕LC   ◊ 'PLACE non-candidate' D1 'on field ' (RC F1) ◊ →0
 →(1=+/C[F1;])↓1+↑⎕LC ◊ 2 Log 're-PLACE ' D1 'on field ' (RC F1) ◊ →0

 1 Log 'Rule' Rule': place' D1 'on' (RC F1)
 C[RoBoCo F1;D1]←0    ⍝ clear D1 in Row, Box, and Col of F1 (including F1)
 C[F1;]←0             ⍝ clear all candidates for F1
 C[F1;D1]←1           ⍝ set D1 in F1
∇

∇C←C remove_candidates B;Rule;FF;D1;RN
 ⍝
 ⍝ Let B = (RN Rule FF D1). Remove digit D1 from fields FF of candidate matrix C
 ⍝
 (RN Rule FF D1)←B ◊ FF←C[FF;D1]/FF ◊ →(0=⍴FF)/0
 1 Log 'Rule' Rule ': remove candidate' D1 'from field(s)' (,' ',⊃RC¨FF)
 C[FF;D1]←0
∇

∇Z←read_sudo;Data;F1;R1;C1;Digit
 ⍝
 ⍝ Read the subsequent input lines as sudoku data
 ⍝ Return a 9×9 character matrix containing the data
 ⍝ The input lines should only contain ' ' and '0' ... '9'
 ⍝
 Data←⎕INP 'END'
 Data←(⊃Data)[2×I9;¯1+4×I9]
 Z←Z←81 9⍴1 ◊ F1←0
LOOP: →(81<F1←F1+1)/0 ◊ (R1 C1)←1 + 9 9 ⊤ F1 - 1
 Digit←Data[R1;C1] ◊ →(Digit=' ')/LOOP
 Z←Z place_digit 1 'init' F1, '123456789'⍳Digit ◊ →LOOP
∇

∇Z←GRID N;IV;IH
 IH←(1+2×IV=2)/IV←1⌽5,1,(¯1+2×N×N)⍴((¯1+2×N)⍴2 3),4
 Z←(5 5⍴'╔═╤╦╗║ │║║╟─┼╫╢╠═╪╬╣╚═╧╩╝')[IV;IH]
∇

∇Z←cand_to_int Cand;Count
 ⍝
 ⍝ For a the 9-element 0-1 candidate vector Cand (the candidates for one
 ⍝ field) return:
 ⍝
 ⍝    ¯1                       for no candidates,
 ⍝    0                        for > 1 candidates,
 ⍝    the (single) candidate   otherwise
 ⍝
 Count←+/Cand
 Z←0 ◊ →(Count > 1)/0
 Z←¯1 ◊ →(Count < 1)/0
 Z←''⍴Cand/I9
∇

∇show_sudo B;I;Z;E
 Z←GRID 3 ◊ I←⊃cand_to_int ¨ ⊂[2] B
 E←⍕+/,I=0
 Z[2×I9;¯1+4×I9]←9 9⍴'? 123456789'[2 + I]
 Z←19 1⍴⊂[2]Z ◊ Z[19;1]←⊂(⊃Z[19;1]),' ',E,' empty field(s)' 
 Z
∇

∇Z←apply_elementary_rules B;D1;F1;N1;I1;P;Ri;Ci;Bi;ZZ
 ⍝
 ⍝ apply different rules to B, which may remove candidates from B (or,
 ⍝ place more digits into B)
 ⍝ return when no more elementary rules are successful
 ⍝
 Z←B
PROGRESS: B←Z

 ⍝ Rule F: Let field F1 be empty, and let all digits except D1 occur in the
 ⍝         same row, column or box as F1. Then place D1 into F1.
 ⍝
Rule_F: F1←0
Loop_F: →(81<F1←F1+1)/Rule_N
 →(1=+/Z[F1;])/Loop_F   ⍝ F1 not empty
 P←∼Z get_placed RoBoCo F1
 →(1=+/P)↓Loop_F
 D1←P/I9
 
 →(Z can_place_digit F1 D1)↓0
 Z←Z place_digit 2 'F' F1 D1
 →Loop_F

 ⍝ Rule N = Nr Nc Nb: Let D be a digit. If only one field F1 in a Row 
 ⍝ (sub-rule Nr) resp. Col ⍝ (sub-rule Nc) resp. Box (sub-rule Nb) allows D,
 ⍝ then place D into F1
 ⍝
Rule_N: N1←0
Loop_N: →(81<N1←N1+1)/Rule_B ◊ (I1 D1)←1+9 9 ⊤ N1 - 1
 Ri←∆Row[I1;] ◊ ZZ←Z[Ri;D1] ◊ →(1≠+/ZZ)/Loop_N
 F1←⍬⍴ZZ/Ri 
 →(Z can_place_digit F1 D1)↓0
 Z←Z place_digit 3 'Nr' F1, D1

 Ci←∆Col[I1;] ◊ ZZ←Z[Ci;D1] ◊ →(1≠+/ZZ)/Loop_N
 F1←⍬⍴ZZ/Ci
 →(Z can_place_digit F1 D1)↓0
 Z←Z place_digit 4 'Nc' F1, D1

 Bi←∆Box[I1;] ◊ ZZ←Z[Bi;D1] ◊ →(1≠+/ZZ)/Loop_N
 F1←⍬⍴ZZ/Bi
 →(Z can_place_digit F1 D1)↓0
 Z←Z place_digit 5 'Nb' F1, D1
 →Loop_N

 ⍝ Rule B = Brb Bbr Bcb Bbc: Let I = Row ∩ Box. If Digit D1 is not allowed 
 ⍝ outside I in (say) Row, then it is also not allowed outside I on Box.
 ⍝ And vice versa, and for Col instead of Row. Proof: D1 must be in in I.
 ⍝
Rule_B: N1←0
Loop_B: →(729<N1←N1+1)/Rule_T ◊ (F1 D1)←1+81 9 ⊤ N1 - 1
 Ri←∆Row[1+''⍴9 9 ⊤ F1-1;] ◊ Ci←∆Col[''⍴1+¯1↑9 9 ⊤ F1-1;]
 Bi←∆Box[1+3 3 ⊥ , 1 2↑ 3 3 ⊤ 9 9 ⊤ F1-1;]
 →(1∈Z[Ri∼Bi;D1])/1+↑⎕LC ◊ Z←Z remove_candidates 6 'B→R' (Bi∼Ri) D1
 →(1∈Z[Bi∼Ri;D1])/1+↑⎕LC ◊ Z←Z remove_candidates 7 'R←B' (Ri∼Bi) D1
 →(1∈Z[Ci∼Bi;D1])/1+↑⎕LC ◊ Z←Z remove_candidates 8 'B←C' (Bi∼Ci) D1
 →(1∈Z[Bi∼Ci;D1])/1+↑⎕LC ◊ Z←Z remove_candidates 9 'C←B' (Ci∼Bi) D1
 →Loop_B

Rule_T:
 →(B≡Z)↓PROGRESS
∇

∇Z←get_plans B;Placed;Bad;ZZ;Todo;F1
 ⍝
 ⍝ a plan is a triple (SUDOKU FIELD DIGIT) and means that DIGIT shall be
 ⍝ placed in FIELD of SUDOKU.
 ⍝
 Z←0 3⍴0
 Bad←0=+/B    ◊ Bad←Bad/⍳81       ◊ 3 Log (2 0⍕⍴Bad)    'Bad:   '  Bad
 Placed←1=+/B ◊ Placed←Placed/⍳81 ◊ 3 Log (2 0⍕⍴Placed) 'Placed:'  Placed
 Todo←2≤+/B   ◊ Todo←Todo/⍳81     ◊ 3 Log (2 0⍕⍴Todo)   'Todo:  '  Todo

Loop: →(0=⍴Todo)/0 ◊ F1←↑Todo ◊ Todo←1↓Todo
 ZZ←1 3⍴(⊂B),F1,⍪B[F1;]/I9
 Z←Z⍪ZZ ◊ →Loop
∇

∇solve_sudoku B;S;St;Plans;F1;D1
 show_sudo B
 S←apply_elementary_rules B
 →(status S)/1+↑⎕LC ◊ show_sudo S ◊ 'solved with elementary rules' ◊ →0
 Plans←get_plans S
Loop: →(↑⍴Plans)/1+↑⎕LC ◊ show_sudo S ◊ 'NOT solved!' ◊ →0
 (S F1 D1)←Plans[1;] ◊ Plans←1 0↓Plans
 S←S place_digit 10 'recu' F1 D1
 St←status S←apply_elementary_rules S 
 Plans←(get_plans S)⍪Plans ◊ →(0≠St)/Loop
 show_sudo S ◊ 'solved!'
∇

SUDO_p5 ← read_sudo   ⍝ page 4
╔═══╤═══╤═══╦═══╤═══╤═══╦═══╤═══╤═══╗
║ 2 │   │   ║   │   │ 5 ║   │   │ 7 ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │ 4 │   ║ 6 │   │ 8 ║   │ 9 │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║ 1 │   │ 9 ║   │   │   ║
╠═══╪═══╪═══╬═══╪═══╪═══╬═══╪═══╪═══╣
║   │ 8 │ 3 ║   │   │   ║ 7 │ 4 │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║   │   │   ║   │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║ 1 │ 7 │ 9 ║   │   │   ║ 6 │ 5 │   ║
╠═══╪═══╪═══╬═══╪═══╪═══╬═══╪═══╪═══╣
║   │   │   ║ 9 │   │ 4 ║   │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │ 5 │   ║ 8 │   │ 3 ║   │ 1 │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║ 4 │   │   ║   │   │   ║   │   │ 8 ║
╚═══╧═══╧═══╩═══╧═══╧═══╩═══╧═══╧═══╝
END

SUDO_sdk_10 ← read_sudo   ⍝ page 10
╔═══╤═══╤═══╦═══╤═══╤═══╦═══╤═══╤═══╗
║   │ 9 │   ║   │   │ 8 ║ 1 │ 6 │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │ 1 ║ 7 │   │   ║ 9 │ 2 │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║ 2 │   │   ║   │   │   ║   │   │ 3 ║
╠═══╪═══╪═══╬═══╪═══╪═══╬═══╪═══╪═══╣
║ 3 │   │ 8 ║ 4 │   │ 1 ║ 5 │   │ 6 ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │ 4 │ 9 ║ 8 │   │   ║ 2 │ 3 │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║ 6 │   │   ║   │   │ 7 ║ 8 │   │ 4 ║
╠═══╪═══╪═══╬═══╪═══╪═══╬═══╪═══╪═══╣
║ 8 │   │   ║ 6 │ 4 │   ║   │   │ 9 ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║   │ 7 │ 2 ║ 6 │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │ 6 │ 7 ║ 1 │ 8 │   ║   │ 5 │ 2 ║
╚═══╧═══╧═══╩═══╧═══╧═══╩═══╧═══╧═══╝
END

SUDO_sdk_16 ← read_sudo   ⍝ page 12
╔═══╤═══╤═══╦═══╤═══╤═══╦═══╤═══╤═══╗
║ 2 │   │ 7 ║   │ 4 │   ║ 6 │   │ 8 ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║ 4 │ 3 │ 5 ║ 9 │ 6 │ 8 ║ 7 │ 1 │ 2 ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │ 6 │ 8 ║ 7 │   │   ║   │   │   ║
╠═══╪═══╪═══╬═══╪═══╪═══╬═══╪═══╪═══╣
║ 5 │ 4 │ 1 ║ 6 │ 3 │ 9 ║ 2 │ 8 │ 7 ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║ 6 │ 7 │ 2 ║   │ 8 │   ║   │   │ 3 ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║ 3 │ 8 │ 9 ║ 2 │ 7 │ 5 ║ 4 │ 6 │ 1 ║
╠═══╪═══╪═══╬═══╪═══╪═══╬═══╪═══╪═══╣
║   │   │   ║   │   │ 6 ║   │ 7 │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║ 8 │ 5 │ 6 ║ 3 │   │ 7 ║ 1 │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║ 7 │   │   ║   │ 1 │   ║   │   │ 6 ║
╚═══╧═══╧═══╩═══╧═══╧═══╩═══╧═══╧═══╝
END

SUDO_sdk_23 ← read_sudo   ⍝ page 26
╔═══╤═══╤═══╦═══╤═══╤═══╦═══╤═══╤═══╗
║ 5 │   │ 2 ║   │   │   ║ 4 │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║ 7 │ 1 │   ║   │   │ 3 ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║   │   │   ║   │   │   ║
╠═══╪═══╪═══╬═══╪═══╪═══╬═══╪═══╪═══╣
║   │   │   ║   │   │ 4 ║ 6 │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │ 7 │   ║ 2 │   │   ║   │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │ 1 │   ║   │   │   ║   │   │   ║
╠═══╪═══╪═══╬═══╪═══╪═══╬═══╪═══╪═══╣
║ 6 │   │   ║   │   │ 2 ║   │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║   │ 3 │   ║   │ 1 │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║ 4 │   │   ║   │   │   ║   │   │   ║
╚═══╧═══╧═══╩═══╧═══╧═══╩═══╧═══╧═══╝
END

solve_sudoku SUDO_p5         ⍝ dito
solve_sudoku SUDO_sdk_10     ⍝ dito
solve_sudoku SUDO_sdk_16     ⍝ dito
solve_sudoku SUDO_sdk_23     ⍝ dito

⍝ GRID 2 ⍝ print an empty 2x2 grid
⍝ GRID 3 ⍝ print an empty 3x3 grid
⍝ GRID 4 ⍝ print an empty 4x4 grid

)OFF
⍝
⍝ EOF 
