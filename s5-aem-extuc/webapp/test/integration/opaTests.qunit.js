sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        's5aemextuc/test/integration/FirstJourney',
		's5aemextuc/test/integration/pages/ExtUseCaseList',
		's5aemextuc/test/integration/pages/ExtUseCaseObjectPage'
    ],
    function(JourneyRunner, opaJourney, ExtUseCaseList, ExtUseCaseObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('s5aemextuc') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheExtUseCaseList: ExtUseCaseList,
					onTheExtUseCaseObjectPage: ExtUseCaseObjectPage
                }
            },
            opaJourney.run
        );
    }
);