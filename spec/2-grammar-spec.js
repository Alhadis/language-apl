"use strict";

describe("Syntax highlighting", () => {
	let grammar;
	before("Initialising grammar", () => {
		grammar = atom.grammars.grammarForScopeName("source.apl");
	});
	
	describe("Comments", () => {
		it("tokenises comment-lines", () => {
			const {tokens} = grammar.tokenizeLine("⍝ Comment");
			tokens[0].should.eql({value: "⍝", scopes: ["source.apl", "comment.line.apl", "punctuation.definition.comment.apl"]});
			tokens[1].should.eql({value: " Comment", scopes: ["source.apl", "comment.line.apl"]});
		});
		
		it("tokenises hashbangs", () => {
			const hashbang = "#!/usr/local/bin/apl --script";
			const lines = grammar.tokenizeLines(`${hashbang}\n`.repeat(2));
			const scopes = ["source.apl", "comment.line.shebang.apl"];
			lines[0][0].should.eql({value: hashbang, scopes});
			lines[1][0].should.not.eql({value: hashbang, scopes});
		});
	});
	
	describe("Numbers", () => {
		const scopes = ["source.apl", "constant.numeric.apl"];
		
		it("tokenises integers", () => {
			grammar.tokenizeLine("3") .tokens[0].should.eql({value: "3",  scopes});
			grammar.tokenizeLine("45").tokens[0].should.eql({value: "45", scopes});
			grammar.tokenizeLine("¯2").tokens[0].should.eql({value: "¯2", scopes});
		});
		
		it("tokenises floats", () => {
			grammar.tokenizeLine("4.5") .tokens[0].should.eql({value: "4.5",  scopes});
			grammar.tokenizeLine(".25") .tokens[0].should.eql({value: ".25",  scopes});
			grammar.tokenizeLine("¯2.3").tokens[0].should.eql({value: "¯2.3", scopes});
			grammar.tokenizeLine("¯.5") .tokens[0].should.eql({value: "¯.5",  scopes});
		});
		
		it("tokenises scientific notation", () => {
			grammar.tokenizeLine("29.e¯2").tokens[0].should.eql({value: "29.e¯2", scopes});
			grammar.tokenizeLine("29e2")  .tokens[0].should.eql({value: "29e2",   scopes});
			grammar.tokenizeLine("2.9e2") .tokens[0].should.eql({value: "2.9e2",  scopes});
			grammar.tokenizeLine("2.9e¯2").tokens[0].should.eql({value: "2.9e¯2", scopes});
			grammar.tokenizeLine("¯2.2e¯20j¯3.3e¯30").tokens[0].should.eql({value: "¯2.2e¯20j¯3.3e¯30", scopes});
		});
	});
	
	describe("Strings", () => {
		it("tokenises single-quoted strings", () => {
			const {tokens} = grammar.tokenizeLine("'String'");
			tokens[0].should.eql({value: "'", scopes: ["source.apl", "string.quoted.single.apl", "punctuation.definition.string.begin.apl"]});
			tokens[1].should.eql({value: "String", scopes: ["source.apl", "string.quoted.single.apl"]});
			tokens[2].should.eql({value: "'", scopes: ["source.apl", "string.quoted.single.apl", "punctuation.definition.string.end.apl"]});
		});
		
		it("tokenises double-quoted strings", () => {
			const {tokens} = grammar.tokenizeLine('"String"');
			tokens[0].should.eql({value: '"', scopes: ["source.apl", "string.quoted.double.apl", "punctuation.definition.string.begin.apl"]});
			tokens[1].should.eql({value: "String", scopes: ["source.apl", "string.quoted.double.apl"]});
			tokens[2].should.eql({value: '"', scopes: ["source.apl", "string.quoted.double.apl", "punctuation.definition.string.end.apl"]});
		});
	});
	
	describe("Symbols", () => {
		it("tokenises APL functions", () => {
			grammar.tokenizeLine("+").tokens[0].should.eql({value: "+", scopes: ["source.apl", "keyword.operator.plus.apl"]});
			grammar.tokenizeLine("-").tokens[0].should.eql({value: "-", scopes: ["source.apl", "keyword.operator.minus.apl"]});
			grammar.tokenizeLine("−").tokens[0].should.eql({value: "−", scopes: ["source.apl", "keyword.operator.minus.apl"]});
			grammar.tokenizeLine("×").tokens[0].should.eql({value: "×", scopes: ["source.apl", "keyword.operator.times.apl"]});
			grammar.tokenizeLine("÷").tokens[0].should.eql({value: "÷", scopes: ["source.apl", "keyword.operator.divide.apl"]});
			grammar.tokenizeLine("⌊").tokens[0].should.eql({value: "⌊", scopes: ["source.apl", "keyword.operator.floor.apl"]});
			grammar.tokenizeLine("⌈").tokens[0].should.eql({value: "⌈", scopes: ["source.apl", "keyword.operator.ceiling.apl"]});
			grammar.tokenizeLine("∣").tokens[0].should.eql({value: "∣", scopes: ["source.apl", "keyword.operator.absolute.apl"]});
			grammar.tokenizeLine("|").tokens[0].should.eql({value: "|", scopes: ["source.apl", "keyword.operator.absolute.apl"]});
			grammar.tokenizeLine("⋆").tokens[0].should.eql({value: "⋆", scopes: ["source.apl", "keyword.operator.exponent.apl"]});
			grammar.tokenizeLine("*").tokens[0].should.eql({value: "*", scopes: ["source.apl", "keyword.operator.exponent.apl"]});
			grammar.tokenizeLine("⍟").tokens[0].should.eql({value: "⍟", scopes: ["source.apl", "keyword.operator.logarithm.apl"]});
			grammar.tokenizeLine("○").tokens[0].should.eql({value: "○", scopes: ["source.apl", "keyword.operator.circle.apl"]});
			grammar.tokenizeLine("!").tokens[0].should.eql({value: "!", scopes: ["source.apl", "keyword.operator.factorial.apl"]});
			grammar.tokenizeLine("∧").tokens[0].should.eql({value: "∧", scopes: ["source.apl", "keyword.operator.and.apl"]});
			grammar.tokenizeLine("∨").tokens[0].should.eql({value: "∨", scopes: ["source.apl", "keyword.operator.or.apl"]});
			grammar.tokenizeLine("⍲").tokens[0].should.eql({value: "⍲", scopes: ["source.apl", "keyword.operator.nand.apl"]});
			grammar.tokenizeLine("⍱").tokens[0].should.eql({value: "⍱", scopes: ["source.apl", "keyword.operator.nor.apl"]});
			grammar.tokenizeLine("<").tokens[0].should.eql({value: "<", scopes: ["source.apl", "keyword.operator.less.apl"]});
			grammar.tokenizeLine("≤").tokens[0].should.eql({value: "≤", scopes: ["source.apl", "keyword.operator.less-or-equal.apl"]});
			grammar.tokenizeLine("=").tokens[0].should.eql({value: "=", scopes: ["source.apl", "keyword.operator.equal.apl"]});
			grammar.tokenizeLine("≥").tokens[0].should.eql({value: "≥", scopes: ["source.apl", "keyword.operator.greater-or-equal.apl"]});
			grammar.tokenizeLine(">").tokens[0].should.eql({value: ">", scopes: ["source.apl", "keyword.operator.greater.apl"]});
			grammar.tokenizeLine("≠").tokens[0].should.eql({value: "≠", scopes: ["source.apl", "keyword.operator.not-equal.apl"]});
			grammar.tokenizeLine("∼").tokens[0].should.eql({value: "∼", scopes: ["source.apl", "keyword.operator.tilde.apl"]});
			grammar.tokenizeLine("~").tokens[0].should.eql({value: "~", scopes: ["source.apl", "keyword.operator.tilde.apl"]});
			grammar.tokenizeLine("?").tokens[0].should.eql({value: "?", scopes: ["source.apl", "keyword.operator.random.apl"]});
			grammar.tokenizeLine("∊").tokens[0].should.eql({value: "∊", scopes: ["source.apl", "keyword.operator.member-of.apl"]});
			grammar.tokenizeLine("∈").tokens[0].should.eql({value: "∈", scopes: ["source.apl", "keyword.operator.member-of.apl"]});
			grammar.tokenizeLine("⍷").tokens[0].should.eql({value: "⍷", scopes: ["source.apl", "keyword.operator.find.apl"]});
			grammar.tokenizeLine(",").tokens[0].should.eql({value: ",", scopes: ["source.apl", "keyword.operator.comma.apl"]});
			grammar.tokenizeLine("⍪").tokens[0].should.eql({value: "⍪", scopes: ["source.apl", "keyword.operator.comma-bar.apl"]});
			grammar.tokenizeLine("⌷").tokens[0].should.eql({value: "⌷", scopes: ["source.apl", "keyword.operator.squad.apl"]});
			grammar.tokenizeLine("⍳").tokens[0].should.eql({value: "⍳", scopes: ["source.apl", "keyword.operator.iota.apl"]});
			grammar.tokenizeLine("⍴").tokens[0].should.eql({value: "⍴", scopes: ["source.apl", "keyword.operator.rho.apl"]});
			grammar.tokenizeLine("↑").tokens[0].should.eql({value: "↑", scopes: ["source.apl", "keyword.operator.take.apl"]});
			grammar.tokenizeLine("↓").tokens[0].should.eql({value: "↓", scopes: ["source.apl", "keyword.operator.drop.apl"]});
			grammar.tokenizeLine("⊣").tokens[0].should.eql({value: "⊣", scopes: ["source.apl", "keyword.operator.left.apl"]});
			grammar.tokenizeLine("⊢").tokens[0].should.eql({value: "⊢", scopes: ["source.apl", "keyword.operator.right.apl"]});
			grammar.tokenizeLine("⊤").tokens[0].should.eql({value: "⊤", scopes: ["source.apl", "keyword.operator.encode.apl"]});
			grammar.tokenizeLine("⊥").tokens[0].should.eql({value: "⊥", scopes: ["source.apl", "keyword.operator.decode.apl"]});
			grammar.tokenizeLine("/").tokens[0].should.eql({value: "/", scopes: ["source.apl", "keyword.operator.slash.apl"]});
			grammar.tokenizeLine("⌿").tokens[0].should.eql({value: "⌿", scopes: ["source.apl", "keyword.operator.slash-bar.apl"]});
			grammar.tokenizeLine("\\").tokens[0].should.eql({value: "\\", scopes: ["source.apl", "keyword.operator.backslash.apl"]});
			grammar.tokenizeLine("⍀").tokens[0].should.eql({value: "⍀", scopes: ["source.apl", "keyword.operator.backslash-bar.apl"]});
			grammar.tokenizeLine("⌽").tokens[0].should.eql({value: "⌽", scopes: ["source.apl", "keyword.operator.rotate-last.apl"]});
			grammar.tokenizeLine("⊖").tokens[0].should.eql({value: "⊖", scopes: ["source.apl", "keyword.operator.rotate-first.apl"]});
			grammar.tokenizeLine("⍉").tokens[0].should.eql({value: "⍉", scopes: ["source.apl", "keyword.operator.transpose.apl"]});
			grammar.tokenizeLine("⍋").tokens[0].should.eql({value: "⍋", scopes: ["source.apl", "keyword.operator.grade-up.apl"]});
			grammar.tokenizeLine("⍒").tokens[0].should.eql({value: "⍒", scopes: ["source.apl", "keyword.operator.grade-down.apl"]});
			grammar.tokenizeLine("⌹").tokens[0].should.eql({value: "⌹", scopes: ["source.apl", "keyword.operator.quad-divide.apl"]});
			grammar.tokenizeLine("≡").tokens[0].should.eql({value: "≡", scopes: ["source.apl", "keyword.operator.identical.apl"]});
			grammar.tokenizeLine("≢").tokens[0].should.eql({value: "≢", scopes: ["source.apl", "keyword.operator.not-identical.apl"]});
			grammar.tokenizeLine("⊂").tokens[0].should.eql({value: "⊂", scopes: ["source.apl", "keyword.operator.enclose.apl"]});
			grammar.tokenizeLine("⊃").tokens[0].should.eql({value: "⊃", scopes: ["source.apl", "keyword.operator.pick.apl"]});
			grammar.tokenizeLine("∩").tokens[0].should.eql({value: "∩", scopes: ["source.apl", "keyword.operator.intersection.apl"]});
			grammar.tokenizeLine("∪").tokens[0].should.eql({value: "∪", scopes: ["source.apl", "keyword.operator.union.apl"]});
			grammar.tokenizeLine("⍎").tokens[0].should.eql({value: "⍎", scopes: ["source.apl", "keyword.operator.hydrant.apl"]});
			grammar.tokenizeLine("⍕").tokens[0].should.eql({value: "⍕", scopes: ["source.apl", "keyword.operator.thorn.apl"]});
			grammar.tokenizeLine("⊆").tokens[0].should.eql({value: "⊆", scopes: ["source.apl", "keyword.operator.underbar-shoe-left.apl"]});
			grammar.tokenizeLine("⍸").tokens[0].should.eql({value: "⍸", scopes: ["source.apl", "keyword.operator.underbar-iota.apl"]});
		});
		
		it("tokenises APL operators", () => {
			grammar.tokenizeLine("¨").tokens[0].should.eql({value: "¨", scopes: ["source.apl", "keyword.operator.each.apl"]});
			grammar.tokenizeLine("⍤").tokens[0].should.eql({value: "⍤", scopes: ["source.apl", "keyword.operator.rank.apl"]});
			grammar.tokenizeLine("⌸").tokens[0].should.eql({value: "⌸", scopes: ["source.apl", "keyword.operator.quad-equal.apl"]});
			grammar.tokenizeLine("⍨").tokens[0].should.eql({value: "⍨", scopes: ["source.apl", "keyword.operator.commute.apl"]});
			grammar.tokenizeLine("⍣").tokens[0].should.eql({value: "⍣", scopes: ["source.apl", "keyword.operator.power.apl"]});
			grammar.tokenizeLine(".").tokens[0].should.eql({value: ".", scopes: ["source.apl", "keyword.operator.dot.apl"]});
			grammar.tokenizeLine("∘").tokens[0].should.eql({value: "∘", scopes: ["source.apl", "keyword.operator.jot.apl"]});
			grammar.tokenizeLine("⍠").tokens[0].should.eql({value: "⍠", scopes: ["source.apl", "keyword.operator.quad-colon.apl"]});
			grammar.tokenizeLine("&").tokens[0].should.eql({value: "&", scopes: ["source.apl", "keyword.operator.ampersand.apl"]});
			grammar.tokenizeLine("⌶").tokens[0].should.eql({value: "⌶", scopes: ["source.apl", "keyword.operator.i-beam.apl"]});
			grammar.tokenizeLine("⌺").tokens[0].should.eql({value: "⌺", scopes: ["source.apl", "keyword.operator.quad-diamond.apl"]});
			grammar.tokenizeLine("@").tokens[0].should.eql({value: "@", scopes: ["source.apl", "keyword.operator.at.apl"]});
		});
		
		it("tokenises other symbols", () => {
			grammar.tokenizeLine("◊").tokens[0].should.eql({value: "◊", scopes: ["source.apl", "keyword.operator.lozenge.apl"]});
			grammar.tokenizeLine(";").tokens[0].should.eql({value: ";", scopes: ["source.apl", "keyword.operator.semicolon.apl"]});
			grammar.tokenizeLine("¯").tokens[0].should.eql({value: "¯", scopes: ["source.apl", "keyword.operator.high-minus.apl"]});
			grammar.tokenizeLine("←").tokens[0].should.eql({value: "←", scopes: ["source.apl", "keyword.operator.assignment.apl"]});
			grammar.tokenizeLine("→").tokens[0].should.eql({value: "→", scopes: ["source.apl", "keyword.control.goto.apl"]});
			grammar.tokenizeLine("⍬").tokens[0].should.eql({value: "⍬", scopes: ["source.apl", "constant.language.zilde.apl"]});
			grammar.tokenizeLine("⋄").tokens[0].should.eql({value: "⋄", scopes: ["source.apl", "keyword.operator.diamond.apl"]});
			grammar.tokenizeLine("⍫").tokens[0].should.eql({value: "⍫", scopes: ["source.apl", "keyword.operator.lock.apl"]});
			grammar.tokenizeLine("##").tokens[0].should.eql({value: "##", scopes: ["source.apl", "constant.language.namespace.parent.apl"]});
			grammar.tokenizeLine("#").tokens[0].should.eql({value: "#", scopes: ["source.apl", "constant.language.namespace.root.apl"]});
			grammar.tokenizeLine("⌻").tokens[0].should.eql({value: "⌻", scopes: ["source.apl", "keyword.operator.quad-jot.apl"]});
			grammar.tokenizeLine("⌼").tokens[0].should.eql({value: "⌼", scopes: ["source.apl", "keyword.operator.quad-circle.apl"]});
			grammar.tokenizeLine("⌾").tokens[0].should.eql({value: "⌾", scopes: ["source.apl", "keyword.operator.circle-jot.apl"]});
			grammar.tokenizeLine("⍁").tokens[0].should.eql({value: "⍁", scopes: ["source.apl", "keyword.operator.quad-slash.apl"]});
			grammar.tokenizeLine("⍂").tokens[0].should.eql({value: "⍂", scopes: ["source.apl", "keyword.operator.quad-backslash.apl"]});
			grammar.tokenizeLine("⍃").tokens[0].should.eql({value: "⍃", scopes: ["source.apl", "keyword.operator.quad-less.apl"]});
			grammar.tokenizeLine("⍄").tokens[0].should.eql({value: "⍄", scopes: ["source.apl", "keyword.operator.greater.apl"]});
			grammar.tokenizeLine("⍅").tokens[0].should.eql({value: "⍅", scopes: ["source.apl", "keyword.operator.vane-left.apl"]});
			grammar.tokenizeLine("⍆").tokens[0].should.eql({value: "⍆", scopes: ["source.apl", "keyword.operator.vane-right.apl"]});
			grammar.tokenizeLine("⍇").tokens[0].should.eql({value: "⍇", scopes: ["source.apl", "keyword.operator.quad-arrow-left.apl"]});
			grammar.tokenizeLine("⍈").tokens[0].should.eql({value: "⍈", scopes: ["source.apl", "keyword.operator.quad-arrow-right.apl"]});
			grammar.tokenizeLine("⍊").tokens[0].should.eql({value: "⍊", scopes: ["source.apl", "keyword.operator.tack-down.apl"]});
			grammar.tokenizeLine("⍌").tokens[0].should.eql({value: "⍌", scopes: ["source.apl", "keyword.operator.quad-caret-down.apl"]});
			grammar.tokenizeLine("⍍").tokens[0].should.eql({value: "⍍", scopes: ["source.apl", "keyword.operator.quad-del-up.apl"]});
			grammar.tokenizeLine("⍏").tokens[0].should.eql({value: "⍏", scopes: ["source.apl", "keyword.operator.vane-up.apl"]});
			grammar.tokenizeLine("⍐").tokens[0].should.eql({value: "⍐", scopes: ["source.apl", "keyword.operator.quad-arrow-up.apl"]});
			grammar.tokenizeLine("⍑").tokens[0].should.eql({value: "⍑", scopes: ["source.apl", "keyword.operator.tack-up.apl"]});
			grammar.tokenizeLine("⍓").tokens[0].should.eql({value: "⍓", scopes: ["source.apl", "keyword.operator.quad-caret-up.apl"]});
			grammar.tokenizeLine("⍔").tokens[0].should.eql({value: "⍔", scopes: ["source.apl", "keyword.operator.quad-del-down.apl"]});
			grammar.tokenizeLine("⍖").tokens[0].should.eql({value: "⍖", scopes: ["source.apl", "keyword.operator.vane-down.apl"]});
			grammar.tokenizeLine("⍗").tokens[0].should.eql({value: "⍗", scopes: ["source.apl", "keyword.operator.quad-arrow-down.apl"]});
			grammar.tokenizeLine("⍘").tokens[0].should.eql({value: "⍘", scopes: ["source.apl", "keyword.operator.underbar-quote.apl"]});
			grammar.tokenizeLine("⍚").tokens[0].should.eql({value: "⍚", scopes: ["source.apl", "keyword.operator.underbar-diamond.apl"]});
			grammar.tokenizeLine("⍛").tokens[0].should.eql({value: "⍛", scopes: ["source.apl", "keyword.operator.underbar-jot.apl"]});
			grammar.tokenizeLine("⍜").tokens[0].should.eql({value: "⍜", scopes: ["source.apl", "keyword.operator.underbar-circle.apl"]});
			grammar.tokenizeLine("⍡").tokens[0].should.eql({value: "⍡", scopes: ["source.apl", "keyword.operator.dotted-tack-up.apl"]});
			grammar.tokenizeLine("⍢").tokens[0].should.eql({value: "⍢", scopes: ["source.apl", "keyword.operator.dotted-del.apl"]});
			grammar.tokenizeLine("⍥").tokens[0].should.eql({value: "⍥", scopes: ["source.apl", "keyword.operator.dotted-circle.apl"]});
			grammar.tokenizeLine("⍦").tokens[0].should.eql({value: "⍦", scopes: ["source.apl", "keyword.operator.stile-shoe-up.apl"]});
			grammar.tokenizeLine("⍧").tokens[0].should.eql({value: "⍧", scopes: ["source.apl", "keyword.operator.stile-shoe-left.apl"]});
			grammar.tokenizeLine("⍩").tokens[0].should.eql({value: "⍩", scopes: ["source.apl", "keyword.operator.dotted-greater.apl"]});
			grammar.tokenizeLine("⍭").tokens[0].should.eql({value: "⍭", scopes: ["source.apl", "keyword.operator.stile-tilde.apl"]});
			grammar.tokenizeLine("⍮").tokens[0].should.eql({value: "⍮", scopes: ["source.apl", "keyword.operator.underbar-semicolon.apl"]});
			grammar.tokenizeLine("⍯").tokens[0].should.eql({value: "⍯", scopes: ["source.apl", "keyword.operator.quad-not-equal.apl"]});
			grammar.tokenizeLine("⍰").tokens[0].should.eql({value: "⍰", scopes: ["source.apl", "keyword.operator.quad-question.apl"]});
		});
		
		it("tags symbols with surrounding whitespace", () => {
			const lines = grammar.tokenizeLines(" ← \n → \n ≡ \n ≢ ");
			lines[0][1].should.eql({value: "←", scopes: ["source.apl", "keyword.spaced.operator.assignment.apl"]});
			lines[1][1].should.eql({value: "→", scopes: ["source.apl", "keyword.spaced.control.goto.apl"]});
			lines[2][1].should.eql({value: "≡", scopes: ["source.apl", "keyword.spaced.operator.identical.apl"]});
			lines[3][1].should.eql({value: "≢", scopes: ["source.apl", "keyword.spaced.operator.not-identical.apl"]});
		});
	});

	describe("Lambdas", () => {
		it("tokenises lambda functions", () => {
			let lines = grammar.tokenizeLines("life←{↑1 ⍵∨.∧3 4=+/,¯1 0 1∘.⊖¯1 0 1∘.⌽⊂⍵}");
			lines[0][0].should.eql({value: "life", scopes: ["source.apl", "variable.other.readwrite.apl"]});
			lines[0][1].should.eql({value: "←", scopes: ["source.apl", "keyword.operator.assignment.apl"]});
			lines[0][2].should.eql({value: "{", scopes: ["source.apl", "meta.lambda.function.apl", "punctuation.definition.lambda.begin.apl"]});
			lines[0][3].should.eql({value: "↑", scopes: ["source.apl", "meta.lambda.function.apl", "keyword.operator.take.apl"]});
			lines[0][4].should.eql({value: "1", scopes: ["source.apl", "meta.lambda.function.apl", "constant.numeric.apl"]});
			lines[0][6].should.eql({value: "⍵", scopes: ["source.apl", "meta.lambda.function.apl", "constant.language.lambda.arguments.right.apl"]});
			lines[0][7].should.eql({value: "∨", scopes: ["source.apl", "meta.lambda.function.apl", "keyword.operator.or.apl"]});
			lines[0][8].should.eql({value: ".", scopes: ["source.apl", "meta.lambda.function.apl", "keyword.operator.dot.apl"]});
			lines[0][9].should.eql({value: "∧", scopes: ["source.apl", "meta.lambda.function.apl", "keyword.operator.and.apl"]});
			lines[0][10].should.eql({value: "3", scopes: ["source.apl", "meta.lambda.function.apl", "constant.numeric.apl"]});
			lines[0][12].should.eql({value: "4", scopes: ["source.apl", "meta.lambda.function.apl", "constant.numeric.apl"]});
			lines[0][13].should.eql({value: "=", scopes: ["source.apl", "meta.lambda.function.apl", "keyword.operator.equal.apl"]});
			lines[0][14].should.eql({value: "+", scopes: ["source.apl", "meta.lambda.function.apl", "keyword.operator.plus.apl"]});
			lines[0][15].should.eql({value: "/", scopes: ["source.apl", "meta.lambda.function.apl", "keyword.operator.slash.apl"]});
			lines[0][16].should.eql({value: ",", scopes: ["source.apl", "meta.lambda.function.apl", "keyword.operator.comma.apl"]});
			lines[0][17].should.eql({value: "¯1", scopes: ["source.apl", "meta.lambda.function.apl", "constant.numeric.apl"]});
			lines[0][19].should.eql({value: "0", scopes: ["source.apl", "meta.lambda.function.apl", "constant.numeric.apl"]});
			lines[0][21].should.eql({value: "1", scopes: ["source.apl", "meta.lambda.function.apl", "constant.numeric.apl"]});
			lines[0][22].should.eql({value: "∘", scopes: ["source.apl", "meta.lambda.function.apl", "keyword.operator.jot.apl"]});
			lines[0][23].should.eql({value: ".", scopes: ["source.apl", "meta.lambda.function.apl", "keyword.operator.dot.apl"]});
			lines[0][24].should.eql({value: "⊖", scopes: ["source.apl", "meta.lambda.function.apl", "keyword.operator.rotate-first.apl"]});
			lines[0][25].should.eql({value: "¯1", scopes: ["source.apl", "meta.lambda.function.apl", "constant.numeric.apl"]});
			lines[0][27].should.eql({value: "0", scopes: ["source.apl", "meta.lambda.function.apl", "constant.numeric.apl"]});
			lines[0][29].should.eql({value: "1", scopes: ["source.apl", "meta.lambda.function.apl", "constant.numeric.apl"]});
			lines[0][30].should.eql({value: "∘", scopes: ["source.apl", "meta.lambda.function.apl", "keyword.operator.jot.apl"]});
			lines[0][31].should.eql({value: ".", scopes: ["source.apl", "meta.lambda.function.apl", "keyword.operator.dot.apl"]});
			lines[0][32].should.eql({value: "⌽", scopes: ["source.apl", "meta.lambda.function.apl", "keyword.operator.rotate-last.apl"]});
			lines[0][33].should.eql({value: "⊂", scopes: ["source.apl", "meta.lambda.function.apl", "keyword.operator.enclose.apl"]});
			lines[0][34].should.eql({value: "⍵", scopes: ["source.apl", "meta.lambda.function.apl", "constant.language.lambda.arguments.right.apl"]});
			lines[0][35].should.eql({value: "}", scopes: ["source.apl", "meta.lambda.function.apl", "punctuation.definition.lambda.end.apl"]});
			
			lines = grammar.tokenizeLines("txt←'<nowiki><html><body><p>This is <em>emphasized</em> text.</p></body></html></nowiki>'\n⎕←{⍵/⍨~{⍵∨≠\\⍵}⍵∊'<>'}txt");
			lines[0][0].should.eql({value: "txt", scopes: ["source.apl", "variable.other.readwrite.apl"]});
			lines[0][1].should.eql({value: "←", scopes: ["source.apl", "keyword.operator.assignment.apl"]});
			lines[0][2].should.eql({value: "'", scopes: ["source.apl", "string.quoted.single.apl", "punctuation.definition.string.begin.apl"]});
			lines[0][3].should.eql({value: "<nowiki><html><body><p>This is <em>emphasized</em> text.</p></body></html></nowiki>", scopes: ["source.apl", "string.quoted.single.apl"]});
			lines[0][4].should.eql({value: "'", scopes: ["source.apl", "string.quoted.single.apl", "punctuation.definition.string.end.apl"]});
			lines[1][0].should.eql({value: "⎕", scopes: ["source.apl", "support.system.variable.apl", "punctuation.definition.quad.apl"]});
			lines[1][1].should.eql({value: "←", scopes: ["source.apl", "keyword.operator.assignment.apl"]});
			lines[1][2].should.eql({value: "{", scopes: ["source.apl", "meta.lambda.function.apl", "punctuation.definition.lambda.begin.apl"]});
			lines[1][3].should.eql({value: "⍵", scopes: ["source.apl", "meta.lambda.function.apl", "constant.language.lambda.arguments.right.apl"]});
			lines[1][4].should.eql({value: "/", scopes: ["source.apl", "meta.lambda.function.apl", "keyword.operator.slash.apl"]});
			lines[1][5].should.eql({value: "⍨", scopes: ["source.apl", "meta.lambda.function.apl", "keyword.operator.commute.apl"]});
			lines[1][6].should.eql({value: "~", scopes: ["source.apl", "meta.lambda.function.apl", "keyword.operator.tilde.apl"]});
			lines[1][7].should.eql({value: "{", scopes: ["source.apl", "meta.lambda.function.apl", "meta.lambda.function.apl", "punctuation.definition.lambda.begin.apl"]});
			lines[1][8].should.eql({value: "⍵", scopes: ["source.apl", "meta.lambda.function.apl", "meta.lambda.function.apl", "constant.language.lambda.arguments.right.apl"]});
			lines[1][9].should.eql({value: "∨", scopes: ["source.apl", "meta.lambda.function.apl", "meta.lambda.function.apl", "keyword.operator.or.apl"]});
			lines[1][10].should.eql({value: "≠", scopes: ["source.apl", "meta.lambda.function.apl", "meta.lambda.function.apl", "keyword.operator.not-equal.apl"]});
			lines[1][11].should.eql({value: "\\", scopes: ["source.apl", "meta.lambda.function.apl", "meta.lambda.function.apl", "keyword.operator.backslash.apl"]});
			lines[1][12].should.eql({value: "⍵", scopes: ["source.apl", "meta.lambda.function.apl", "meta.lambda.function.apl", "constant.language.lambda.arguments.right.apl"]});
			lines[1][13].should.eql({value: "}", scopes: ["source.apl", "meta.lambda.function.apl", "meta.lambda.function.apl", "punctuation.definition.lambda.end.apl"]});
			lines[1][14].should.eql({value: "⍵", scopes: ["source.apl", "meta.lambda.function.apl", "constant.language.lambda.arguments.right.apl"]});
			lines[1][15].should.eql({value: "∊", scopes: ["source.apl", "meta.lambda.function.apl", "keyword.operator.member-of.apl"]});
			lines[1][16].should.eql({value: "'", scopes: ["source.apl", "meta.lambda.function.apl", "string.quoted.single.apl", "punctuation.definition.string.begin.apl"]});
			lines[1][17].should.eql({value: "<>", scopes: ["source.apl", "meta.lambda.function.apl", "string.quoted.single.apl"]});
			lines[1][18].should.eql({value: "'", scopes: ["source.apl", "meta.lambda.function.apl", "string.quoted.single.apl", "punctuation.definition.string.end.apl"]});
			lines[1][19].should.eql({value: "}", scopes: ["source.apl", "meta.lambda.function.apl", "punctuation.definition.lambda.end.apl"]});
			lines[1][20].should.eql({value: "txt", scopes: ["source.apl", "variable.other.readwrite.apl"]});
		});
		
		it("tokenises lambda-specific variables", () => {
			const vars = "⍺⍺ ⍵⍵ ⍺ ⍶ ⍵ ⍹ χ ∇∇ ∇ λ";
			grammar.tokenizeLine(vars).tokens[0].should.eql({value: vars, scopes: ["source.apl"]});
			const {tokens} = grammar.tokenizeLine(`{${vars}}`);
			tokens[0].should.eql({value: "{", scopes: ["source.apl", "meta.lambda.function.apl", "punctuation.definition.lambda.begin.apl"]});
			tokens[1].should.eql({value: "⍺⍺", scopes: ["source.apl", "meta.lambda.function.apl", "constant.language.lambda.operands.left.apl"]});
			tokens[3].should.eql({value: "⍵⍵", scopes: ["source.apl", "meta.lambda.function.apl", "constant.language.lambda.operands.right.apl"]});
			tokens[5].should.eql({value: "⍺", scopes: ["source.apl", "meta.lambda.function.apl", "constant.language.lambda.arguments.left.apl"]});
			tokens[7].should.eql({value: "⍶", scopes: ["source.apl", "meta.lambda.function.apl", "constant.language.lambda.arguments.left.apl"]});
			tokens[9].should.eql({value: "⍵", scopes: ["source.apl", "meta.lambda.function.apl", "constant.language.lambda.arguments.right.apl"]});
			tokens[11].should.eql({value: "⍹", scopes: ["source.apl", "meta.lambda.function.apl", "constant.language.lambda.arguments.right.apl"]});
			tokens[13].should.eql({value: "χ", scopes: ["source.apl", "meta.lambda.function.apl", "constant.language.lambda.arguments.axis.apl"]});
			tokens[15].should.eql({value: "∇∇", scopes: ["source.apl", "meta.lambda.function.apl", "constant.language.lambda.operands.self.operator.apl"]});
			tokens[17].should.eql({value: "∇", scopes: ["source.apl", "meta.lambda.function.apl", "constant.language.lambda.operands.self.function.apl"]});
			tokens[19].should.eql({value: "λ", scopes: ["source.apl", "meta.lambda.function.apl", "constant.language.lambda.symbol.apl"]});
			tokens[20].should.eql({value: "}", scopes: ["source.apl", "meta.lambda.function.apl", "punctuation.definition.lambda.end.apl"]});
		});
	});

	describe("Functions", () => {
		it("tokenises monadic functions", () => {
			const lines = grammar.tokenizeLines("∇R ← FUNCTION X\n\tR ← X + X\n∇");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][1].should.eql({value: "R", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.apl"]});
			lines[0][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][5].should.eql({value: "FUNCTION", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][7].should.eql({value: "X", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[1][1].should.eql({value: "R", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "keyword.spaced.operator.assignment.apl"]});
			lines[1][5].should.eql({value: "X", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][7].should.eql({value: "+", scopes: ["source.apl", "meta.function.apl", "keyword.operator.plus.apl"]});
			lines[1][9].should.eql({value: "X", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[2][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "keyword.operator.nabla.apl"]});
		});
		
		it("tokenises monadic functions with local variables", () => {
			const lines = grammar.tokenizeLines("∇R ← FUNCTION X ;A;B\n\tR ← X + X\n∇");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][1].should.eql({value: "R", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.apl"]});
			lines[0][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][5].should.eql({value: "FUNCTION", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][7].should.eql({value: "X", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[0][9].should.eql({value: ";", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl", "punctuation.separator.apl"]});
			lines[0][10].should.eql({value: "A", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl"]});
			lines[0][11].should.eql({value: ";", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl", "punctuation.separator.apl"]});
			lines[0][12].should.eql({value: "B", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl"]});
			lines[1][1].should.eql({value: "R", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "keyword.spaced.operator.assignment.apl"]});
			lines[1][5].should.eql({value: "X", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][7].should.eql({value: "+", scopes: ["source.apl", "meta.function.apl", "keyword.operator.plus.apl"]});
			lines[1][9].should.eql({value: "X", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[2][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "keyword.operator.nabla.apl"]});
		});
		
		it("tokenises dyadic functions", () => {
			const lines = grammar.tokenizeLines("∇R ← X FUNCTION Y\n\tR ← X + Y\n∇");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][1].should.eql({value: "R", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.apl"]});
			lines[0][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][5].should.eql({value: "X ", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.left.apl"]});
			lines[0][6].should.eql({value: "FUNCTION", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][8].should.eql({value: "Y", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[1][1].should.eql({value: "R", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "keyword.spaced.operator.assignment.apl"]});
			lines[1][5].should.eql({value: "X", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][7].should.eql({value: "+", scopes: ["source.apl", "meta.function.apl", "keyword.operator.plus.apl"]});
			lines[1][9].should.eql({value: "Y", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[2][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "keyword.operator.nabla.apl"]});
		});
		
		it("tokenises dyadic functions with local variables", () => {
			const lines = grammar.tokenizeLines("∇R ← X FUNCTION Y;A;B\n\tR ← X + Y\n∇");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][1].should.eql({value: "R", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.apl"]});
			lines[0][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][5].should.eql({value: "X ", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.left.apl"]});
			lines[0][6].should.eql({value: "FUNCTION", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][8].should.eql({value: "Y", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[0][9].should.eql({value: ";", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl", "punctuation.separator.apl"]});
			lines[0][10].should.eql({value: "A", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl"]});
			lines[0][11].should.eql({value: ";", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl", "punctuation.separator.apl"]});
			lines[0][12].should.eql({value: "B", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl"]});
			lines[1][1].should.eql({value: "R", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "keyword.spaced.operator.assignment.apl"]});
			lines[1][5].should.eql({value: "X", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][7].should.eql({value: "+", scopes: ["source.apl", "meta.function.apl", "keyword.operator.plus.apl"]});
			lines[1][9].should.eql({value: "Y", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[2][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "keyword.operator.nabla.apl"]});
		});
		
		it("tokenises operators", () => {
			let lines = grammar.tokenizeLines("∇R ← X (LOP OPERATOR ROP) Y ;A;B\n\tR ← X + Y\n∇");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][1].should.eql({value: "R", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.apl"]});
			lines[0][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][5].should.eql({value: "X ", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.left.apl"]});
			lines[0][6].should.eql({value: "(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.begin.apl"]});
			lines[0][7].should.eql({value: "LOP", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.operands.left.apl"]});
			lines[0][9].should.eql({value: "OPERATOR", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][11].should.eql({value: "ROP", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.operands.right.apl"]});
			lines[0][12].should.eql({value: ")", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.end.apl"]});
			lines[0][14].should.eql({value: "Y", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[0][16].should.eql({value: ";", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl", "punctuation.separator.apl"]});
			lines[0][17].should.eql({value: "A", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl"]});
			lines[0][18].should.eql({value: ";", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl", "punctuation.separator.apl"]});
			lines[0][19].should.eql({value: "B", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl"]});
			lines[1][1].should.eql({value: "R", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "keyword.spaced.operator.assignment.apl"]});
			lines[1][5].should.eql({value: "X", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][7].should.eql({value: "+", scopes: ["source.apl", "meta.function.apl", "keyword.operator.plus.apl"]});
			lines[1][9].should.eql({value: "Y", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[2][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "keyword.operator.nabla.apl"]});

			lines = grammar.tokenizeLines("∇R ← (LOP OPERATOR ROP) X ;A;B\n\tR ← X + Y\n∇");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][1].should.eql({value: "R", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.apl"]});
			lines[0][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][5].should.eql({value: "(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.begin.apl"]});
			lines[0][6].should.eql({value: "LOP", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.operands.left.apl"]});
			lines[0][8].should.eql({value: "OPERATOR", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][10].should.eql({value: "ROP", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.operands.right.apl"]});
			lines[0][11].should.eql({value: ")", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.end.apl"]});
			lines[0][13].should.eql({value: "X", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[0][15].should.eql({value: ";", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl", "punctuation.separator.apl"]});
			lines[0][16].should.eql({value: "A", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl"]});
			lines[0][17].should.eql({value: ";", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl", "punctuation.separator.apl"]});
			lines[0][18].should.eql({value: "B", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl"]});
			lines[1][1].should.eql({value: "R", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "keyword.spaced.operator.assignment.apl"]});
			lines[1][5].should.eql({value: "X", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][7].should.eql({value: "+", scopes: ["source.apl", "meta.function.apl", "keyword.operator.plus.apl"]});
			lines[1][9].should.eql({value: "Y", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[2][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "keyword.operator.nabla.apl"]});
			
			lines = grammar.tokenizeLines("∇ {(Z1 Z2)}←{(L1 L2 L3)} (LO DyadicOp RO) (R1 R2 R3 R4)");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][2].should.eql({value: "{(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.shy.apl", "punctuation.definition.return-value.begin.apl"]});
			lines[0][3].should.eql({value: "Z1 Z2", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.shy.apl"]});
			lines[0][4].should.eql({value: ")}", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.shy.apl", "punctuation.definition.return-value.end.apl"]});
			lines[0][5].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][6].should.eql({value: "{(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.left.optional.apl", "punctuation.definition.arguments.begin.apl"]});
			lines[0][7].should.eql({value: "L1 L2 L3", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.left.optional.apl"]});
			lines[0][8].should.eql({value: ")}", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.left.optional.apl", "punctuation.definition.arguments.end.apl"]});
			lines[0][10].should.eql({value: "(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.begin.apl"]});
			lines[0][11].should.eql({value: "LO", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.operands.left.apl"]});
			lines[0][13].should.eql({value: "DyadicOp", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][15].should.eql({value: "RO", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.operands.right.apl"]});
			lines[0][16].should.eql({value: ")", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.end.apl"]});
			lines[0][18].should.eql({value: "(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl", "punctuation.definition.arguments.begin.apl"]});
			lines[0][19].should.eql({value: "R1 R2 R3 R4", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[0][20].should.eql({value: ")", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl", "punctuation.definition.arguments.end.apl"]});
			
			lines = grammar.tokenizeLines("∇ {(Z1 Z2)}←{(L1 L2 L3)} (LO MonadicOp) (R1 R2 R3 R4)");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][2].should.eql({value: "{(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.shy.apl", "punctuation.definition.return-value.begin.apl"]});
			lines[0][3].should.eql({value: "Z1 Z2", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.shy.apl"]});
			lines[0][4].should.eql({value: ")}", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.shy.apl", "punctuation.definition.return-value.end.apl"]});
			lines[0][5].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][6].should.eql({value: "{(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.left.optional.apl", "punctuation.definition.arguments.begin.apl"]});
			lines[0][7].should.eql({value: "L1 L2 L3", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.left.optional.apl"]});
			lines[0][8].should.eql({value: ")}", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.left.optional.apl", "punctuation.definition.arguments.end.apl"]});
			lines[0][10].should.eql({value: "(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.begin.apl"]});
			lines[0][11].should.eql({value: "LO", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.operands.left.apl"]});
			lines[0][13].should.eql({value: "MonadicOp", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][14].should.eql({value: ")", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.end.apl"]});
			lines[0][16].should.eql({value: "(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl", "punctuation.definition.arguments.begin.apl"]});
			lines[0][17].should.eql({value: "R1 R2 R3 R4", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[0][18].should.eql({value: ")", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl", "punctuation.definition.arguments.end.apl"]});
			
			lines = grammar.tokenizeLines("∇ {(Z1 Z2)}←{(L1 L2 L3)} (LO DydadicOp [X] RO) (R1 R2 R3 R4)");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][2].should.eql({value: "{(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.shy.apl", "punctuation.definition.return-value.begin.apl"]});
			lines[0][3].should.eql({value: "Z1 Z2", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.shy.apl"]});
			lines[0][4].should.eql({value: ")}", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.shy.apl", "punctuation.definition.return-value.end.apl"]});
			lines[0][5].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][6].should.eql({value: "{(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.left.optional.apl", "punctuation.definition.arguments.begin.apl"]});
			lines[0][7].should.eql({value: "L1 L2 L3", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.left.optional.apl"]});
			lines[0][8].should.eql({value: ")}", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.left.optional.apl", "punctuation.definition.arguments.end.apl"]});
			lines[0][10].should.eql({value: "(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.begin.apl"]});
			lines[0][11].should.eql({value: "LO", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.operands.left.apl"]});
			lines[0][13].should.eql({value: "DydadicOp", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][15].should.eql({value: "[", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.axis.apl", "punctuation.definition.axis.begin.apl"]});
			lines[0][16].should.eql({value: "X", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.axis.apl"]});
			lines[0][17].should.eql({value: "]", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.axis.apl", "punctuation.definition.axis.end.apl"]});
			lines[0][19].should.eql({value: "RO", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.operands.right.apl"]});
			lines[0][20].should.eql({value: ")", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.end.apl"]});
			lines[0][22].should.eql({value: "(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl", "punctuation.definition.arguments.begin.apl"]});
			lines[0][23].should.eql({value: "R1 R2 R3 R4", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[0][24].should.eql({value: ")", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl", "punctuation.definition.arguments.end.apl"]});
			
			lines = grammar.tokenizeLines("∇ {(Z1 Z2)}←{(L1 L2 L3)} (LO MonadicOp[X]) (R1 R2 R3 R4)");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][2].should.eql({value: "{(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.shy.apl", "punctuation.definition.return-value.begin.apl"]});
			lines[0][3].should.eql({value: "Z1 Z2", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.shy.apl"]});
			lines[0][4].should.eql({value: ")}", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.shy.apl", "punctuation.definition.return-value.end.apl"]});
			lines[0][5].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][6].should.eql({value: "{(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.left.optional.apl", "punctuation.definition.arguments.begin.apl"]});
			lines[0][7].should.eql({value: "L1 L2 L3", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.left.optional.apl"]});
			lines[0][8].should.eql({value: ")}", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.left.optional.apl", "punctuation.definition.arguments.end.apl"]});
			lines[0][10].should.eql({value: "(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.begin.apl"]});
			lines[0][11].should.eql({value: "LO", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.operands.left.apl"]});
			lines[0][13].should.eql({value: "MonadicOp", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][14].should.eql({value: "[", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.axis.apl", "punctuation.definition.axis.begin.apl"]});
			lines[0][15].should.eql({value: "X", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.axis.apl"]});
			lines[0][16].should.eql({value: "]", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.axis.apl", "punctuation.definition.axis.end.apl"]});
			lines[0][17].should.eql({value: ")", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.end.apl"]});
			lines[0][19].should.eql({value: "(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl", "punctuation.definition.arguments.begin.apl"]});
			lines[0][20].should.eql({value: "R1 R2 R3 R4", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[0][21].should.eql({value: ")", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl", "punctuation.definition.arguments.end.apl"]});
		});
		
		it("tokenises operators with invalid headers", () => {
			let lines = grammar.tokenizeLines("∇R ← X (LOP OPERATOR ROP) Y ;A;B;\n\tR ← X + Y\n∇");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][1].should.eql({value: "R", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.apl"]});
			lines[0][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][5].should.eql({value: "X ", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.left.apl"]});
			lines[0][6].should.eql({value: "(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.begin.apl"]});
			lines[0][7].should.eql({value: "LOP", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.operands.left.apl"]});
			lines[0][9].should.eql({value: "OPERATOR", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][11].should.eql({value: "ROP", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.operands.right.apl"]});
			lines[0][12].should.eql({value: ")", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.end.apl"]});
			lines[0][14].should.eql({value: "Y", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[0][16].should.eql({value: ";A;B;", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl", "invalid.illegal.local-variables.apl"]});
			lines[1][1].should.eql({value: "R", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "keyword.spaced.operator.assignment.apl"]});
			lines[1][5].should.eql({value: "X", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][7].should.eql({value: "+", scopes: ["source.apl", "meta.function.apl", "keyword.operator.plus.apl"]});
			lines[1][9].should.eql({value: "Y", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[2][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "keyword.operator.nabla.apl"]});
			
			lines = grammar.tokenizeLines("∇R ← X (LOP OPERATOR ROP) Y Whoops;L;E;;;L\n\tR ← X + Y\n∇");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][1].should.eql({value: "R", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.apl"]});
			lines[0][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][5].should.eql({value: "X ", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.left.apl"]});
			lines[0][6].should.eql({value: "(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.begin.apl"]});
			lines[0][7].should.eql({value: "LOP", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.operands.left.apl"]});
			lines[0][9].should.eql({value: "OPERATOR", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][11].should.eql({value: "ROP", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.operands.right.apl"]});
			lines[0][12].should.eql({value: ")", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.end.apl"]});
			lines[0][14].should.eql({value: "Y", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[0][16].should.eql({value: "Whoops", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "invalid.illegal.arguments.right.apl"]});
			lines[0][17].should.eql({value: ";L;E;;;L", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl", "invalid.illegal.local-variables.apl"]});
			lines[1][1].should.eql({value: "R", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "keyword.spaced.operator.assignment.apl"]});
			lines[1][5].should.eql({value: "X", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][7].should.eql({value: "+", scopes: ["source.apl", "meta.function.apl", "keyword.operator.plus.apl"]});
			lines[1][9].should.eql({value: "Y", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[2][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "keyword.operator.nabla.apl"]});
			
			lines = grammar.tokenizeLines("∇R ← X (LOP OPERATOR ROP) Y Whoops;k;e;k\n\tR ← X + Y\n∇");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][1].should.eql({value: "R", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.apl"]});
			lines[0][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][5].should.eql({value: "X ", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.left.apl"]});
			lines[0][6].should.eql({value: "(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.begin.apl"]});
			lines[0][7].should.eql({value: "LOP", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.operands.left.apl"]});
			lines[0][9].should.eql({value: "OPERATOR", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][11].should.eql({value: "ROP", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.operands.right.apl"]});
			lines[0][12].should.eql({value: ")", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.end.apl"]});
			lines[0][14].should.eql({value: "Y", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[0][16].should.eql({value: "Whoops", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "invalid.illegal.arguments.right.apl"]});
			lines[0][17].should.eql({value: ";", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl", "punctuation.separator.apl"]});
			lines[0][18].should.eql({value: "k", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl"]});
			lines[0][19].should.eql({value: ";", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl", "punctuation.separator.apl"]});
			lines[0][20].should.eql({value: "e", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl"]});
			lines[0][21].should.eql({value: ";", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl", "punctuation.separator.apl"]});
			lines[0][22].should.eql({value: "k", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl"]});
			lines[1][1].should.eql({value: "R", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "keyword.spaced.operator.assignment.apl"]});
			lines[1][5].should.eql({value: "X", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][7].should.eql({value: "+", scopes: ["source.apl", "meta.function.apl", "keyword.operator.plus.apl"]});
			lines[1][9].should.eql({value: "Y", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[2][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "keyword.operator.nabla.apl"]});
			
			lines = grammar.tokenizeLines("∇R ← (LOP OPERATOR ROP) Y Invalid;B;R;U;H;\n\tR ← X + Y\n∇");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][1].should.eql({value: "R", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.apl"]});
			lines[0][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][5].should.eql({value: "(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.begin.apl"]});
			lines[0][6].should.eql({value: "LOP", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.operands.left.apl"]});
			lines[0][8].should.eql({value: "OPERATOR", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][10].should.eql({value: "ROP", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.operands.right.apl"]});
			lines[0][11].should.eql({value: ")", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.end.apl"]});
			lines[0][13].should.eql({value: "Y", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[0][15].should.eql({value: "Invalid", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "invalid.illegal.arguments.right.apl"]});
			lines[0][16].should.eql({value: ";B;R;U;H;", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl", "invalid.illegal.local-variables.apl"]});
			lines[1][1].should.eql({value: "R", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "keyword.spaced.operator.assignment.apl"]});
			lines[1][5].should.eql({value: "X", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][7].should.eql({value: "+", scopes: ["source.apl", "meta.function.apl", "keyword.operator.plus.apl"]});
			lines[1][9].should.eql({value: "Y", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[2][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "keyword.operator.nabla.apl"]});
		});
		
		it("tokenises axis operators", () => {
			let lines = grammar.tokenizeLines("∇ FUNCTION [AXIS] right;X;Y\n\t⎕←input\n∇");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][2].should.eql({value: "FUNCTION", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][4].should.eql({value: "[", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.axis.apl", "punctuation.definition.axis.begin.apl"]});
			lines[0][5].should.eql({value: "AXIS", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.axis.apl"]});
			lines[0][6].should.eql({value: "]", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.axis.apl", "punctuation.definition.axis.end.apl"]});
			lines[0][8].should.eql({value: "right", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[0][9].should.eql({value: ";", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl", "punctuation.separator.apl"]});
			lines[0][10].should.eql({value: "X", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl"]});
			lines[0][11].should.eql({value: ";", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl", "punctuation.separator.apl"]});
			lines[0][12].should.eql({value: "Y", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl"]});
			lines[1][1].should.eql({value: "⎕", scopes: ["source.apl", "meta.function.apl", "support.system.variable.apl", "punctuation.definition.quad.apl"]});
			lines[1][2].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "keyword.operator.assignment.apl"]});
			lines[1][3].should.eql({value: "input", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[2][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "keyword.operator.nabla.apl"]});
			
			lines = grammar.tokenizeLines("∇ Z ← X FUNCTION [ AXIS ] Y\n\tZ ← X + Y\n∇");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][2].should.eql({value: "Z", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.apl"]});
			lines[0][4].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][6].should.eql({value: "X ", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.left.apl"]});
			lines[0][7].should.eql({value: "FUNCTION", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][9].should.eql({value: "[", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.axis.apl", "punctuation.definition.axis.begin.apl"]});
			lines[0][10].should.eql({value: " AXIS ", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.axis.apl"]});
			lines[0][11].should.eql({value: "]", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.axis.apl", "punctuation.definition.axis.end.apl"]});
			lines[0][13].should.eql({value: "Y", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[1][1].should.eql({value: "Z", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "keyword.spaced.operator.assignment.apl"]});
			lines[1][5].should.eql({value: "X", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][7].should.eql({value: "+", scopes: ["source.apl", "meta.function.apl", "keyword.operator.plus.apl"]});
			lines[1][9].should.eql({value: "Y", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[2][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "keyword.operator.nabla.apl"]});
		});
		
		it("tokenises axis operators with invalid headers", () => {
			const lines = grammar.tokenizeLines("∇ left FUNCTION[AXIS INVALID] right\n\t⎕←input\n∇");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][2].should.eql({value: "left ", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.left.apl"]});
			lines[0][3].should.eql({value: "FUNCTION", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][4].should.eql({value: "[", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.axis.apl", "punctuation.definition.axis.begin.apl"]});
			lines[0][5].should.eql({value: "AXIS ", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.axis.apl"]});
			lines[0][6].should.eql({value: "INVALID", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.axis.apl", "invalid.illegal.extra-characters.apl"]});
			lines[0][7].should.eql({value: "]", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.axis.apl", "punctuation.definition.axis.end.apl"]});
			lines[0][9].should.eql({value: "right", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[1][1].should.eql({value: "⎕", scopes: ["source.apl", "meta.function.apl", "support.system.variable.apl", "punctuation.definition.quad.apl"]});
			lines[1][2].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "keyword.operator.assignment.apl"]});
			lines[1][3].should.eql({value: "input", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[2][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "keyword.operator.nabla.apl"]});
		});
		
		it("tokenises Dyalog/NARS2000-style headers", () => {
			let lines = grammar.tokenizeLines("∇ Z ← FUNCTION (X Y)\n\tZ ← R1 + R2\n∇");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][2].should.eql({value: "Z", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.apl"]});
			lines[0][4].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][6].should.eql({value: "FUNCTION", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][8].should.eql({value: "(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl", "punctuation.definition.arguments.begin.apl"]});
			lines[0][9].should.eql({value: "X Y", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[0][10].should.eql({value: ")", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl", "punctuation.definition.arguments.end.apl"]});
			lines[1][1].should.eql({value: "Z", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "keyword.spaced.operator.assignment.apl"]});
			lines[1][5].should.eql({value: "R1", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][7].should.eql({value: "+", scopes: ["source.apl", "meta.function.apl", "keyword.operator.plus.apl"]});
			lines[1][9].should.eql({value: "R2", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[2][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "keyword.operator.nabla.apl"]});
			
			lines = grammar.tokenizeLines("∇ Z ← X (A FUNCTION [AXIS] B) (X Y)\n\tZ ← R1 + R2\n∇");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][2].should.eql({value: "Z", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.apl"]});
			lines[0][4].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][6].should.eql({value: "X ", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.left.apl"]});
			lines[0][7].should.eql({value: "(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.begin.apl"]});
			lines[0][8].should.eql({value: "A", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.operands.left.apl"]});
			lines[0][10].should.eql({value: "FUNCTION", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][12].should.eql({value: "[", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.axis.apl", "punctuation.definition.axis.begin.apl"]});
			lines[0][13].should.eql({value: "AXIS", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.axis.apl"]});
			lines[0][14].should.eql({value: "]", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.axis.apl", "punctuation.definition.axis.end.apl"]});
			lines[0][16].should.eql({value: "B", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.operands.right.apl"]});
			lines[0][17].should.eql({value: ")", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.end.apl"]});
			lines[0][19].should.eql({value: "(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl", "punctuation.definition.arguments.begin.apl"]});
			lines[0][20].should.eql({value: "X Y", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[0][21].should.eql({value: ")", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl", "punctuation.definition.arguments.end.apl"]});
			lines[1][1].should.eql({value: "Z", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "keyword.spaced.operator.assignment.apl"]});
			lines[1][5].should.eql({value: "R1", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[1][7].should.eql({value: "+", scopes: ["source.apl", "meta.function.apl", "keyword.operator.plus.apl"]});
			lines[1][9].should.eql({value: "R2", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[2][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "keyword.operator.nabla.apl"]});
			
			lines = grammar.tokenizeLines("∇ Z←FOO R;g1 g2 g3 g4;h1 h2 h3\n∇");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][2].should.eql({value: "Z", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.apl"]});
			lines[0][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][4].should.eql({value: "FOO", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][6].should.eql({value: "R", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[0][7].should.eql({value: ";", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl", "punctuation.separator.apl"]});
			lines[0][8].should.eql({value: "g1 g2 g3 g4", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl"]});
			lines[0][9].should.eql({value: ";", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl", "punctuation.separator.apl"]});
			lines[0][10].should.eql({value: "h1 h2 h3", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl"]});
			lines[1][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "keyword.operator.nabla.apl"]});
			
			lines = grammar.tokenizeLines("∇ Z←(LO MonOp) R\n∇");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][2].should.eql({value: "Z", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.apl"]});
			lines[0][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][4].should.eql({value: "(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.begin.apl"]});
			lines[0][5].should.eql({value: "LO", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.operands.left.apl"]});
			lines[0][7].should.eql({value: "MonOp", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][8].should.eql({value: ")", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.operands.apl", "punctuation.definition.operands.end.apl"]});
			lines[0][10].should.eql({value: "R", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[1][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "keyword.operator.nabla.apl"]});
		});
		
		it("tokenises “shy”/non-displayable return values", () => {
			let lines = grammar.tokenizeLines("∇ {Y Z} ← FUNCTION X\n∇");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][2].should.eql({value: "{", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.shy.apl", "punctuation.definition.return-value.begin.apl"]});
			lines[0][3].should.eql({value: "Y Z", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.shy.apl"]});
			lines[0][4].should.eql({value: "}", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.shy.apl", "punctuation.definition.return-value.end.apl"]});
			lines[0][6].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][8].should.eql({value: "FUNCTION", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][10].should.eql({value: "X", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[1][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "keyword.operator.nabla.apl"]});
			
			lines = grammar.tokenizeLines("∇ ({Y Z}) ← FUNCTION X\n∇");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][2].should.eql({value: "({", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.shy.apl", "punctuation.definition.return-value.begin.apl"]});
			lines[0][3].should.eql({value: "Y Z", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.shy.apl"]});
			lines[0][4].should.eql({value: "})", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.shy.apl", "punctuation.definition.return-value.end.apl"]});
			lines[0][6].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][8].should.eql({value: "FUNCTION", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][10].should.eql({value: "X", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[1][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "keyword.operator.nabla.apl"]});
			
			lines = grammar.tokenizeLines("∇ {(Y Z)} ← FUNCTION X\n∇");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][2].should.eql({value: "{(", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.shy.apl", "punctuation.definition.return-value.begin.apl"]});
			lines[0][3].should.eql({value: "Y Z", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.shy.apl"]});
			lines[0][4].should.eql({value: ")}", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.shy.apl", "punctuation.definition.return-value.end.apl"]});
			lines[0][6].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][8].should.eql({value: "FUNCTION", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][10].should.eql({value: "X", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[1][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "keyword.operator.nabla.apl"]});
		});
		
		it("tokenises local variable lists on separate lines", () => {
			const lines = grammar.tokenizeLines("∇ r←foo y;a;b       ⍝ Locals\n         ;c;d       ⍝ More locals\n  (a b c d)←y\n  r←a+b-c×d\n∇");
			lines[0][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.nabla.apl"]});
			lines[0][2].should.eql({value: "r", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.return-value.apl"]});
			lines[0][3].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "keyword.operator.assignment.apl"]});
			lines[0][4].should.eql({value: "foo", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.name.apl", "markup.bold.identifier.apl"]});
			lines[0][6].should.eql({value: "y", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.arguments.right.apl"]});
			lines[0][7].should.eql({value: ";", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl", "punctuation.separator.apl"]});
			lines[0][8].should.eql({value: "a", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl"]});
			lines[0][9].should.eql({value: ";", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl", "punctuation.separator.apl"]});
			lines[0][10].should.eql({value: "b       ", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl"]});
			lines[0][11].should.eql({value: "⍝ Locals", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "comment.line.apl"]});
			lines[1][1].should.eql({value: ";", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl", "punctuation.separator.apl"]});
			lines[1][2].should.eql({value: "c", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl"]});
			lines[1][3].should.eql({value: ";", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl", "punctuation.separator.apl"]});
			lines[1][4].should.eql({value: "d       ", scopes: ["source.apl", "meta.function.apl", "entity.function.definition.apl", "entity.function.local-variables.apl"]});
			lines[1][5].should.eql({value: "⍝", scopes: ["source.apl", "meta.function.apl", "comment.line.apl", "punctuation.definition.comment.apl"]});
			lines[1][6].should.eql({value: " More locals", scopes: ["source.apl", "meta.function.apl", "comment.line.apl"]});
			lines[2][1].should.eql({value: "(", scopes: ["source.apl", "meta.function.apl", "meta.round.bracketed.group.apl", "punctuation.round.bracket.begin.apl"]});
			lines[2][2].should.eql({value: "a", scopes: ["source.apl", "meta.function.apl", "meta.round.bracketed.group.apl", "variable.other.readwrite.apl"]});
			lines[2][4].should.eql({value: "b", scopes: ["source.apl", "meta.function.apl", "meta.round.bracketed.group.apl", "variable.other.readwrite.apl"]});
			lines[2][6].should.eql({value: "c", scopes: ["source.apl", "meta.function.apl", "meta.round.bracketed.group.apl", "variable.other.readwrite.apl"]});
			lines[2][8].should.eql({value: "d", scopes: ["source.apl", "meta.function.apl", "meta.round.bracketed.group.apl", "variable.other.readwrite.apl"]});
			lines[2][9].should.eql({value: ")", scopes: ["source.apl", "meta.function.apl", "meta.round.bracketed.group.apl", "punctuation.round.bracket.end.apl"]});
			lines[2][10].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "keyword.operator.assignment.apl"]});
			lines[2][11].should.eql({value: "y", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[3][1].should.eql({value: "r", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[3][2].should.eql({value: "←", scopes: ["source.apl", "meta.function.apl", "keyword.operator.assignment.apl"]});
			lines[3][3].should.eql({value: "a", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[3][4].should.eql({value: "+", scopes: ["source.apl", "meta.function.apl", "keyword.operator.plus.apl"]});
			lines[3][5].should.eql({value: "b", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[3][6].should.eql({value: "-", scopes: ["source.apl", "meta.function.apl", "keyword.operator.minus.apl"]});
			lines[3][7].should.eql({value: "c", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[3][8].should.eql({value: "×", scopes: ["source.apl", "meta.function.apl", "keyword.operator.times.apl"]});
			lines[3][9].should.eql({value: "d", scopes: ["source.apl", "meta.function.apl", "variable.other.readwrite.apl"]});
			lines[4][0].should.eql({value: "∇", scopes: ["source.apl", "meta.function.apl", "keyword.operator.nabla.apl"]});
		});
	});

	describe("Classes", () => {
		it("tokenises classes", () => {
			const lines = grammar.tokenizeLines(":Class Bird: 'Animal', FlyingCreature, WarmBlooded\n:EndClass");
			lines[0][0].should.eql({value: ":", scopes: ["source.apl", "meta.class.apl", "keyword.control.class.apl", "punctuation.definition.class.apl"]});
			lines[0][1].should.eql({value: "Class", scopes: ["source.apl", "meta.class.apl", "keyword.control.class.apl"]});
			lines[0][3].should.eql({value: "Bird", scopes: ["source.apl", "meta.class.apl", "entity.name.type.class.apl"]});
			lines[0][4].should.eql({value: ":", scopes: ["source.apl", "meta.class.apl", "entity.other.inherited-class.apl", "punctuation.separator.inheritance.apl"]});
			lines[0][6].should.eql({value: "'", scopes: ["source.apl", "meta.class.apl", "entity.other.inherited-class.apl", "string.quoted.single.apl", "punctuation.definition.string.begin.apl"]});
			lines[0][7].should.eql({value: "Animal", scopes: ["source.apl", "meta.class.apl", "entity.other.inherited-class.apl", "string.quoted.single.apl"]});
			lines[0][8].should.eql({value: "'", scopes: ["source.apl", "meta.class.apl", "entity.other.inherited-class.apl", "string.quoted.single.apl", "punctuation.definition.string.end.apl"]});
			lines[0][9].should.eql({value: ",", scopes: ["source.apl", "meta.class.apl", "entity.other.class.interfaces.apl", "punctuation.separator.apl"]});
			lines[0][11].should.eql({value: "FlyingCreature", scopes: ["source.apl", "meta.class.apl", "entity.other.class.interfaces.apl", "variable.other.readwrite.apl"]});
			lines[0][12].should.eql({value: ",", scopes: ["source.apl", "meta.class.apl", "entity.other.class.interfaces.apl", "punctuation.separator.apl"]});
			lines[0][14].should.eql({value: "WarmBlooded", scopes: ["source.apl", "meta.class.apl", "entity.other.class.interfaces.apl", "variable.other.readwrite.apl"]});
			lines[1][0].should.eql({value: ":", scopes: ["source.apl", "keyword.control.class.apl", "punctuation.definition.class.apl"]});
			lines[1][1].should.eql({value: "EndClass", scopes: ["source.apl", "keyword.control.class.apl"]});
		});
		
		it("tokenises subclasses", () => {
			const lines = grammar.tokenizeLines(":Class Name: Superclass, Interface, 'Interface'\n\t⍝ Comment\n:EndClass");
			lines[0][0].should.eql({value: ":", scopes: ["source.apl", "meta.class.apl", "keyword.control.class.apl", "punctuation.definition.class.apl"]});
			lines[0][1].should.eql({value: "Class", scopes: ["source.apl", "meta.class.apl", "keyword.control.class.apl"]});
			lines[0][3].should.eql({value: "Name", scopes: ["source.apl", "meta.class.apl", "entity.name.type.class.apl"]});
			lines[0][4].should.eql({value: ":", scopes: ["source.apl", "meta.class.apl", "entity.other.inherited-class.apl", "punctuation.separator.inheritance.apl"]});
			lines[0][6].should.eql({value: "Superclass", scopes: ["source.apl", "meta.class.apl", "entity.other.inherited-class.apl"]});
			lines[0][7].should.eql({value: ",", scopes: ["source.apl", "meta.class.apl", "entity.other.class.interfaces.apl", "punctuation.separator.apl"]});
			lines[0][9].should.eql({value: "Interface", scopes: ["source.apl", "meta.class.apl", "entity.other.class.interfaces.apl", "variable.other.readwrite.apl"]});
			lines[0][10].should.eql({value: ",", scopes: ["source.apl", "meta.class.apl", "entity.other.class.interfaces.apl", "punctuation.separator.apl"]});
			lines[0][12].should.eql({value: "'", scopes: ["source.apl", "meta.class.apl", "entity.other.class.interfaces.apl", "string.quoted.single.apl", "punctuation.definition.string.begin.apl"]});
			lines[0][13].should.eql({value: "Interface", scopes: ["source.apl", "meta.class.apl", "entity.other.class.interfaces.apl", "string.quoted.single.apl"]});
			lines[0][14].should.eql({value: "'", scopes: ["source.apl", "meta.class.apl", "entity.other.class.interfaces.apl", "string.quoted.single.apl", "punctuation.definition.string.end.apl"]});
			lines[1][1].should.eql({value: "⍝", scopes: ["source.apl", "comment.line.apl", "punctuation.definition.comment.apl"]});
			lines[1][2].should.eql({value: " Comment", scopes: ["source.apl", "comment.line.apl"]});
			lines[2][0].should.eql({value: ":", scopes: ["source.apl", "keyword.control.class.apl", "punctuation.definition.class.apl"]});
			lines[2][1].should.eql({value: "EndClass", scopes: ["source.apl", "keyword.control.class.apl"]});
		});
	});
});
