⍝ Conway's Game of Life
⍝ Source: https://en.wikipedia.org/wiki/APL_(programming_language)#Game_of_Life
life←{↑1 ⍵∨.∧3 4=+/,¯1 0 1∘.⊖¯1 0 1∘.⌽⊂⍵}
