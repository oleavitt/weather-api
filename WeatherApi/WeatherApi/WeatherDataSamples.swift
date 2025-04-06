//
//  WeatherDataSamples.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 4/5/25.
//

import Foundation

#if DEBUG
// swiftlint:disable line_length
// Disable line_length in this file for the sample data below
extension WeatherDataAlerts {
    /// Sample data for Previews
    static var sample: [WeatherDataAlert] {
        [
            WeatherDataAlert(id: UUID(), category: "Met",
                             msgtype: "Alert",
                             note: "",
                             headline: "Flood Warning issued April 5 at 4:47AM CDT until April 5 at 8:03PM CDT by NWS Fort Worth TX",
                             effective: "2025-04-05T04:47:00-05:00",
                             event: "Flood Warning",
                             expires: "2025-04-05T20:15:00-05:00",
                             desc: "...The National Weather Service in Fort Worth TX has issued a Flood\nWarning for the following rivers in Texas...\n\nWhite Rock Creek Near White Rock Creek At Greenville Ave\naffecting Dallas County.\n\n* WHAT...Minor flooding is forecast.\n\n* WHERE...White Rock Creek near White Rock Creek At Greenville Ave.\n\n* WHEN...Until this evening.\n\n* IMPACTS...At 84.0 feet, Minor flooding will occur near the creek.\nBike paths downstream of the gage will be flooded. Water\napproaches ball fields at Emmett Conrad High School.\n\n* ADDITIONAL DETAILS...\n- At 4:15 AM CDT Saturday the stage was 71.0 feet.\n- Bankfull stage is 84.0 feet.\n- Flood stage is 84.0 feet.\n- Forecast...The river is expected to rise above flood stage\nearly this morning to a crest of 85.8 feet this morning. It\nwill then fall below flood stage this morning.\n",
                             instruction: "\n\nDo not drive cars through flooded areas.\nCaution is urged when walking near riverbanks.\n\nAdditional information is available at www.water.noaa.gov/wfo/FWD.",
                             urgency: "Expected",
                             severity: "Severe",
                             areas: "Dallas, TX",
                             certainty: "Likely"),
            WeatherDataAlert(id: UUID(), category: "Met",
                             msgtype: "Update",
                             note: "",
                             headline: "Flood Warning issued April 5 at 8:55AM CDT until April 5 at 4:13PM CDT by NWS Fort Worth TX",
                             effective: "2025-04-05T08:55:00-05:00",
                             event: "Flood Warning",
                             expires: "2025-04-05T20:15:00-05:00",
                             desc: "...The Flood Warning continues for the following rivers in Texas...\n\nWhite Rock Creek Near White Rock Creek At Greenville Ave\naffecting Dallas County.\n\n* WHAT...Minor flooding is forecast.\n\n* WHERE...White Rock Creek near White Rock Creek At Greenville Ave.\n\n* WHEN...Until late this afternoon.\n\n* IMPACTS...At 84.0 feet, Minor flooding will occur near the creek.\nBike paths downstream of the gage will be flooded. Water\napproaches ball fields at Emmett Conrad High School.\n\n* ADDITIONAL DETAILS...\n- At 8:15 AM CDT Saturday the stage was 83.9 feet.\n- Bankfull stage is 84.0 feet.\n- Flood stage is 84.0 feet.\n- Forecast...The river is expected to rise to a crest of 84.4\nfeet late this morning. It will then fall below flood stage\nlate this morning.\n",
                             instruction: "\n\nDo not drive cars through flooded areas.\nCaution is urged when walking near riverbanks.\n\nAdditional information is available at www.water.noaa.gov/wfo/FWD.",
                             urgency: "Immediate",
                             severity: "Severe",
                             areas: "Dallas, TX",
                             certainty: "Observed"),
            WeatherDataAlert(id: UUID(), category: "Met",
                             msgtype: "Alert",
                             note: "",
                             headline: "Flood Warning issued April 4 at 8:39PM CDT until April 6 at 2:12PM CDT by NWS Fort Worth TX",
                             effective: "2025-04-04T20:39:00-05:00",
                             event: "Flood Warning",
                             expires: "2025-04-05T14:45:00-05:00",
                             desc: "...The Flood Warning is extended for the following rivers in Texas...\n\nSouth Sulphur River Near Cooper affecting Delta and Hopkins\nCounties.\n\nCowleech Fork Sabine River At Greenville affecting Hunt County.\n\nSouth Fork Sabine River Near Quinlan affecting Hunt and Rockwall\nCounties.\n\n* WHAT...Minor flooding is forecast.\n\n* WHERE...South Fork Sabine River near Quinlan.\n\n* WHEN...From Saturday evening to early Sunday afternoon.\n\n* IMPACTS...At 15.0 feet, Minor out of bank flooding will occur.\n\n* ADDITIONAL DETAILS...\n- At 7:45 PM CDT Friday the stage was 6.4 feet.\n- Bankfull stage is 15.0 feet.\n- Flood stage is 15.0 feet.\n- Forecast...The river is expected to rise above flood stage\ntomorrow evening to a crest of 15.2 feet early Sunday\nmorning. It will then fall below flood stage early Sunday\nmorning.\n",
                             instruction: "\n\nDo not drive cars through flooded areas.\nCaution is urged when walking near riverbanks.\n\nAdditional information is available at www.water.noaa.gov/wfo/FWD.",
                             urgency: "Immediate",
                             severity: "Severe",
                             areas: "Hunt, TX; Rockwall, TX",
                             certainty: "Observed")
        ]
    }
}
// swiftlint:enable line_length
#endif
