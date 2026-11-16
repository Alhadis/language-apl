div←{                  ⍝ Tolerant division:: ⍺÷0 → ⍺.
	⍺←1                ⍝ default numerator.
	5::↑∇/↓↑⍺ ⍵        ⍝ LENGTH:: stretch to fit.
	11::⍺ ∇ ⍵+⍵=0      ⍝ DOMAIN:: increase divisor.
	⍺÷⍵                ⍝ attempt division.
}

open←{                 ⍝ Handle for component file ⍵.
	0::0               ⍝ Fails:: return 0 handle.
	22::⍵ ⎕FCREATE 0   ⍝ FILE NAME:: create new one.
	24 25::⍵ ⎕FSTIE 0  ⍝ FILE TIED:: try share tie.
			⍵ ⎕FTIE 0  ⍝ Attempt to open file.
}
