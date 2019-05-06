⍝ Conway's Game of Life
⍝ Source: https://en.wikipedia.org/wiki/APL_%28programming_language%29#Game_of_Life
life←{↑1 ⍵∨.∧3 4=+/,¯1 0 1∘.⊖¯1 0 1∘.⌽⊂⍵}
