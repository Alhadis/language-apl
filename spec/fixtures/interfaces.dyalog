:Interface FishBehaviour
	∇ R←Swim ⍝ Returns description of swimming capability
	∇
:EndInterface ⍝ FishBehaviour


:Interface BirdBehaviour
	∇ R←Fly ⍝ Returns description of flying capability
	∇
	∇ R←Lay ⍝ Returns description of egg-laying behaviour
	∇
	∇ R←Sing ⍝ Returns description of bird-song
	∇
:EndInterface ⍝ BirdBehaviour


:Class Penguin: Animal, BirdBehaviour, FishBehaviour
	∇ R←NoCanFly
		:Implements Method BirdBehaviour.Fly
		R←'Although I am a bird, I cannot fly'
	∇
	∇ R←LayOneEgg
		:Implements Method BirdBehaviour.Lay
		R←'I lay one egg every year'
	∇
	∇ R←Croak
		:Implements Method BirdBehaviour.Sing
		R←'Croak, Croak!'
	∇
	∇ R←Dive
		:Implements Method FishBehaviour.Swim
		R←'I can dive and swim like a fish'
	∇
:EndClass ⍝ Penguin
