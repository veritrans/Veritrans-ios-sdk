//
//  AnalyticsManager.swift
//  Example-ObjC
//
//  Created by Abhijeet Mallick on 14/02/24.
//

import Foundation
import UIKit

@objcMembers
public class AnalyticsManager: NSObject {
    
    @objc public static let shared = AnalyticsManager()

    private override init() { }
    
    
    
    /// Initialise Clickstream
    @objc public func initialiseClickstream() {  }
    
    @objc public func trackEvent(eventName: String, properties: [String: Any]?) {
        guard let properties = properties else {
            assertionFailure("No properties in the event \(eventName)!")
            return
        }
        if let message = ClickstreamContractFactory.constructContract(eventName: eventName,
                                                                      properties: properties), var _message = message as? ProductCommons {
            
            let eventGuid = UUID().uuidString
            let timestamp = Date()
            
            let meta = Midtrans_Clickstream_Meta_EventMeta.with {
                $0.eventGuid = eventGuid
                $0.app = self.appData(properties: properties)
                $0.device = self.deviceData(properties: properties)
                $0.merchant = self.merchantData(properties: properties)
            }
            _message.meta = meta
            _message.eventTimestamp = Google_Protobuf_Timestamp(date: timestamp)
            do {
                let typeOfEvent = type(of: _message).protoMessageName
                let eventData = try _message.serializedData()
                
                let eventDTO = try ClickstreamEvent(guid: eventGuid, timeStamp: timestamp, message: _message, eventName: type(of: _message).protoMessageName, eventData: _message.serializedData())
                let eventRequestData = try createEventRequestBatch(event: eventDTO)!.serializedData()
                
                self.uploadToClickstream(data: eventRequestData)
            } catch {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    private func createEventRequestBatch(event: ClickstreamEvent) -> Odpf_Raccoon_EventRequest? {
        guard var typeOfEvent: String = event.eventName.components(separatedBy: ".").last?.lowercased() else {
            assertionFailure("Event Name is incorrect")
            return nil
        }
        // Constructing the Odpf_Raccoon_Event
        let csEvent = Odpf_Raccoon_Event.with {
            $0.eventBytes = event.eventData
            $0.type = typeOfEvent
        }
          
        // Constructing Odpf_Raccoon_EventRequest
        let eventRequest = Odpf_Raccoon_EventRequest.with {
            $0.reqGuid = UUID().uuidString
            $0.sentTime = Google_Protobuf_Timestamp(date: Date())
            $0.events = [csEvent]
        }
        
        return eventRequest
    }
    
    private func uploadToClickstream(data: Data) {
        guard var urlRequest = self.urlRequest() else {
            assertionFailure("URL is incorrect for Clickstream")
            return
        }
        urlRequest.httpBody = data
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let _ = data, error == nil else {
                print("Error: Failed to get json data, error: \(String(describing: error))")
                return
            }
            print("Clickstream event sent successfully")
        }
        dataTask.resume()
    }
    
    private func appData(properties: [String: Any]) -> Midtrans_Clickstream_Meta_App {
        let app = Midtrans_Clickstream_Meta_App.with {
            $0.sdkVersion = properties["sdk version"] as? String ?? ""
            $0.appName = properties["host_app"] as? String ?? ""
        }
        return app
    }
    
    private func deviceData(properties: [String: Any]) -> Midtrans_Clickstream_Meta_Device {
        let device = Midtrans_Clickstream_Meta_Device.with {
            $0.platform = properties["platform"] as? String ?? ""
            $0.osVersion = properties["os_version"] as? String ?? ""
            $0.model = properties["Device Model"] as? String ?? ""
            $0.deviceID = properties["Device ID"] as? String ?? ""
            $0.deviceType = properties["Device Type"] as? String ?? ""
            $0.osVersion = properties["os_version"] as? String ?? ""
        }
        return device
    }
    
    private func merchantData(properties: [String: Any]) -> Midtrans_Clickstream_Meta_Merchant {
        let merchant = Midtrans_Clickstream_Meta_Merchant.with {
            $0.merchantName = properties["merchant"] as? String ?? ""
            $0.merchantID = properties["merchant_id"] as? String ?? ""
        }
        return merchant
    }
}

extension AnalyticsManager {
    private func urlRequest() -> URLRequest? {
        // URL
        guard let url = URL(string: "Midtrans Clickstream URL") else {
            return nil
        }
        
        // Header
        let integrationApiKey = "Clickatream API key" // Add API key here
        guard let credentialsData = integrationApiKey.data(using: String.Encoding.utf8) else {
            return nil
        }
        let base64CredentialsString = credentialsData.base64EncodedString()
        let headers = ["Authorization": "Basic \(base64CredentialsString)",
                      "X-UniqueId": "\(UIDevice.current.identifierForVendor?.uuidString ?? "")"]
        
        // URLRequest
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = "POST"
        return urlRequest
    }
}

enum EventStatus: String {
    case displayStatus
}
