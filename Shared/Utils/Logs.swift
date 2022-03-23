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
    static let decodingLogger = Logger(subsystem: subsystem, category: "decoding")
    static let fileSystemLogger = Logger(subsystem: subsystem, category: "filesystem")
    static let locationSystemLogger = Logger(subsystem: subsystem, category: "cl-location")
    static let mapViewLogger = Logger(subsystem: subsystem, category: "mapview")
    static let subscriberLogger = Logger(subsystem: subsystem, category: "combine-subscriber")
    static let publisherLogger = Logger(subsystem: subsystem, category: "combine-publisher")
    static let networkLogger = Logger(subsystem: subsystem, category: "network")
    static let viewLogger = Logger(subsystem: subsystem, category: "views")
    static let viewModelLogger = Logger(subsystem: subsystem, category: "viewModels")
    static let coreDataLogger = Logger(subsystem: subsystem, category: "coredata")
    static let unknownErrorLogger = Logger(subsystem: subsystem, category: "unknown")
}
