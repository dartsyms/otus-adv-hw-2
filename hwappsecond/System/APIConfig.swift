//
//  APIConfig.swift
//  hwappsecond
//

import Foundation

open class APIConfig: DummyApiConfig {
    private static var dummyApiKey = "5f7c2dcc582b4b0e578d238d"
    public static var basePath = "https://dummyapi.io/data/api"
    public static var credential: URLCredential?
    public static var customHeaders: [String:String] = ["app-id": APIConfig.dummyApiKey]
    public static var requestBuilderFactory: RequestBuilderFactory = URLSessionRequestBuilderFactory()
    public static var apiResponseQueue: DispatchQueue = .main
}

public enum ApiError: Error {
    case unknown(String)
}
