sap.ui.define(
    ["sap/fe/core/AppComponent"],
    function (Component) {
        "use strict";

        return Component.extend("s5aemmaintain.Component", {
            metadata: {
                manifest: "json"
            },
            init() {
                Component.prototype.init.call(this);
                this.getModel().attachDataReceived(
                    (oEvent) => {
                        // oEvent.getSource().getModel().refresh()
                    }
                )
                this.getModel().attachRequestSent(
                    (oEvent) => {
                        let cache = [];
                        let sJson = 
                        JSON.stringify(oEvent, (key, value) => {
                            if (typeof value === 'object' && value !== null) {
                                // Duplicate reference found, discard key
                                if (cache.includes(value)) return;

                                // Store value in our collection
                                cache.push(value);
                            }
                            return value;
                        })
                        console.log(sJson)

                    }
                )
            }
        });
    }
);