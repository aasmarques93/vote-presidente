//
//  Connection.swift
//  Water
//
//  Created by Arthur Augusto Sousa Marques on 30/01/17.
//  Copyright © 2017 Arthur Augusto Sousa Marques. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias HandlerObject = (Any?) -> Swift.Void

// MARK: - Service Model -

class ServiceModel {
    
    // MARK: - Properties -
    
    var url : String?
    var parameters : [String:Any]?
    
    // MARK: - Constructors -
    
    init() {
        
    }
    
    init(url : String?) {
        self.url = url
    }
    
    init(url : String?, parameters : [String:Any]?) {
        self.url = url
        self.parameters = parameters
    }
    
    // MARK: - Service Delegate Methods -
    
    func request<T:Model>(_:T.Type, method: HTTPMethod = .get, requestUrl: RequestUrl, stringUrl: String? = nil, parameters: [String:Any]? = nil, urlParameters: [String:Any]? = nil, handlerObject: @escaping HandlerObject, handlerJson: HandlerObject? = nil) {
        
        var url = ""
        
        if let stringUrl = stringUrl {
            url = stringUrl
        } else {
            url = self.requestUrl(type: requestUrl, parameters: urlParameters)
        }
        
        if !verifyConnection() {
            let error = ReachabilityError.notConnection
            handlerObject(error)
            return
        }
        
        Connection.request(url, method: method, parameters: parameters) { (dataResponse) in
            if let value = dataResponse.result.value {
                if let handlerJson = handlerJson {
                    handlerJson(value)
                }
                
                if let array = value as? [Any] {
                    var arrayObject = [T]()
                    
                    for object in array {
                        arrayObject.append(T(json: JSON(object)))
                    }
                    
                    handlerObject(arrayObject)
                } else {
                    handlerObject(T(json: JSON(value)))
                }
            } else {
                handlerObject(ReachabilityError.requestTimeout)
                
                if let handlerJson = handlerJson {
                    handlerJson(nil)
                }
            }
        }
    }
    
    func loadImage(path: String?, handlerData: @escaping HandlerObject) {
        var url = keyManagerFile(key: EnvironmentBase.images)
        if let path = path { url += path }
        
        if !verifyConnection() {
            let error = ReachabilityError.notConnection
            handlerData(error)
            return
        }
        
        Connection.requestData(url, method: .get, parameters: nil) { (data) in
            if let data = data {
                handlerData(data)
            } else {
                handlerData(ReachabilityError.requestTimeout)
            }
        }
    }
    
    // MARK: - Verifications -
    
    static func verifyResult(_ object : Any?) -> String? {
        if let error = object as? ReachabilityError {
            return error.descriptionError()
        }
        if let error = object as? Error {
            return error.localizedDescription
        }
        return nil
    }
    
    func verifyConnection() -> Bool{
        if let reachabilityNetwork = Alamofire.NetworkReachabilityManager(host: "www.google.com") {
            
            if reachabilityNetwork.isReachable {
                return true
            }
        }
        return false
    }
    
    // MARK: - File manager - Link requests -
    
    private func requestUrl(type: RequestUrl, parameters: [String:Any]? = nil) -> String {
        if type.rawValue.contains("http") {
            return type.rawValue
        }
        
        var link = ""
        
        link += keyManagerFile(key: EnvironmentHost.shared.current)
        
        guard let parameters = parameters else {
            link += keyManagerFile(key: type)
            return link
        }
        
        link += createUrl(from: keyManagerFile(key: type), parameters: parameters)
        
        return link
    }
    
    func keyManagerFile(key:Any) -> String{
        if let key = key as? EnvironmentBase {
            let file = FileManager.load(name: FileName.environmentLink)
            if let host = file?.object(forKey: key.rawValue) as? String {
                return host
            }
        }
        
        if let key = key as? RequestUrl {
            let file = FileManager.load(name: FileName.requestUrl)
            if let link = file?.object(forKey: key.rawValue) as? String {
                return link
            }
        }
        
        return ""
    }
    
    func createUrl(from string: String, parameters: [String:Any]) -> String {
        var url = string
        
        for parameter in parameters {
            if url.contains("{\(parameter.key)}") {
                let array = url.components(separatedBy: "{\(parameter.key)}")
                if array.count == 2 { url = "\(array[0])\(parameter.value)\(array[1])" }
            }
        }
        
        return url
    }
}

// MARK: - Reachability Custom Error -

enum ReachabilityError : Error {
    case notConnection
    case requestTimeout
    
    func descriptionError() -> String {
        switch self {
        case .notConnection:
            return "CONNECTION_VERIFY"
        case .requestTimeout:
            return "REQUEST_TIMEOUT"
        }
    }
}
