//
//  Logs.swift
//  covid19tracker
//
//  Created by William Calkins on 3/28/20.
//  Copyright © 2020 Calkins Computer Consulting. All rights reserved.
//

import Foundation
import os

//MARK:- Log extensions
private let subsystem = "com.c3.CovidNumbers"

struct Log {
    //create log for decoding data structures
    static let decodingLogger = OSLog(subsystem: subsystem, category: "decoding")
    static let fileSystemLogger = OSLog(subsystem: subsystem, category: "filesystem")
    static let locationSystemLogger = OSLog(subsystem: subsystem, category: "cl-location")
    static let mapViewLogger = OSLog(subsystem: subsystem, category: "mapview")
    static let subscriberLogger = OSLog(subsystem: subsystem, category: "combine-subscriber")
    static let publisherLogger = OSLog(subsystem: subsystem, category: "combine-publisher")
    static let networkLogger = OSLog(subsystem: subsystem, category: "network")
    static let viewLogger = OSLog(subsystem: subsystem, category: "views")
    static let viewModelLogger = OSLog(subsystem: subsystem, category: "viewModels")
    static let coreDataLogger = OSLog(subsystem: subsystem, category: "coredata")
    static let unknownErrorLogger = OSLog(subsystem: subsystem, category: "unknown")
    
}
