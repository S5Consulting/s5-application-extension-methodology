sap.ui.define([], function () {
    "use strict";
    return {
        onAfterActionExecution: async function () {
            await this.extensionAPI.getTransactionController().submitBatch();
            this.extensionAPI.refresh();
        }
    };
});