//
//  Initiator.swift
//  wkhwappsecond WatchKit Extension
//

import Foundation
import DummyApiNetworkClient

class Initiator {
    static func makeDefault() {
        DummyAPIConfig.customHeaders.updateValue("5f7c2dcc582b4b0e578d238d", forKey: "app-id")
    }
}
