sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        's5aemmaintain/test/integration/FirstJourney',
		's5aemmaintain/test/integration/pages/ConfigList',
		's5aemmaintain/test/integration/pages/ConfigObjectPage'
    ],
    function(JourneyRunner, opaJourney, ConfigList, ConfigObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('s5aemmaintain') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheConfigList: ConfigList,
					onTheConfigObjectPage: ConfigObjectPage
                }
            },
            opaJourney.run
        );
    }
);