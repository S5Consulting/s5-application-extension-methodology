sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 's5aemmaintain',
            componentId: 'ConfigList',
            contextPath: '/Config'
        },
        CustomPageDefinitions
    );
});