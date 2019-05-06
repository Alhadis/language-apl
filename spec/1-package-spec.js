"use strict";

describe("Package activation", () => {
	const {join} = require("path");
	
	before("Preparing environment", () => {
		atom.config.set("core.useTreeSitterParsers", false);
		return Promise.all([
			atom.packages.activatePackage("language-html"),
			atom.packages.activatePackage("language-xml"),
			atom.packages.activatePackage("language-css"),
			atom.packages.activatePackage("language-javascript"),
			atom.packages.activatePackage("language-json"),
			atom.packages.activatePackage("language-text"),
		]);
	});
	
	it("activates the package successfully", async () => {
		await atom.packages.activatePackage(join(__dirname, ".."));
		atom.packages.isPackageActive("language-apl").should.be.true;
	});
	
	it("loads the APL grammar correctly", () =>
		atom.grammars.grammarForScopeName("source.apl")
			.should.be.an("object")
			.that.respondsTo("tokenizeLine")
			.that.respondsTo("tokenizeLines")
			.that.has.property("scopeName", "source.apl"));
});
