sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 's5aemextuc',
            componentId: 'ExtUseCaseObjectPage',
            contextPath: '/ExtUseCase'
        },
        CustomPageDefinitions
    );
});