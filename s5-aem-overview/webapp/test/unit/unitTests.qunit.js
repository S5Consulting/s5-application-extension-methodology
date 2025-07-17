/* global QUnit */
QUnit.config.autostart = false;

sap.ui.getCore().attachInit(function () {
	"use strict";

	sap.ui.require([
		"s5aemoverview/test/unit/AllTests"
	], function () {
		QUnit.start();
	});
});
