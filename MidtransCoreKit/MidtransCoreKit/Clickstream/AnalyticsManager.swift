//
//  AnalyticsManager.swift
//  Example-ObjC
//
//  Created by Abhijeet Mallick on 14/02/24.
//

import Foundation
import ClickstreamLib
import UIKit
import SwiftProtobuf

@objcMembers
public class AnalyticsManager: NSObject {
    
    private var clickstream: Clickstream?
    
    /// Initialise Clickstream
    @objc public func initialiseClickstream() {
        
        Clickstream.setLogLevel(.verbose)
        do {
            let header = createHeader()
            let request = self.urlRequest(headerParamaters: header)
            
            let configurations = ClickstreamConstraints(maxConnectionRetries: 5)
            let classification = ClickstreamEventClassification()

            self.clickstream = try Clickstream.initialise(
                with: request ?? URLRequest(url: URL(string: "")!),
                configurations: configurations,
                eventClassification: classification,
                appPrefix: "midtrans"
            )
        } catch  {
            print(error.localizedDescription)
        }
        
        EventsHelper.shared.startCapturing()
    }
    
    @objc public func trackEvent(eventName: String, properties: [String: Any]?) {
        guard let clickstream = clickstream else {
            assertionFailure("Need to initialise clicksteam first before trying to send events!")
            return
        }
        guard let properties = properties else {
            assertionFailure("No properties in the event \(eventName)!")
            return
        }
        if let message = ClickstreamContractFactory.constructContract(eventName: eventName,
                                                                      properties: properties), var _message = message as? ProductCommons {
            
            let eventGuid = UUID().uuidString
            let meta = Midtrans_Clickstream_Meta_EventMeta.with {
                $0.eventGuid = eventGuid
            }
            _message.meta = meta
            _message.eventTimestamp = Google_Protobuf_Timestamp(date: Date())
            
            do {
                let eventDTO = try ClickstreamEvent(guid: eventGuid, timeStamp: Date(), message: _message, eventName: type(of: _message).protoMessageName, eventData: _message.serializedData())
                clickstream.trackEvent(with: eventDTO)
            } catch {
                print(error.localizedDescription)
                return
            }
            
        }
    }
    
    /// De-initialize Clickstream
    @objc func disconnect() {
        Clickstream.destroy()
        clickstream = nil
    }
}

extension AnalyticsManager: TrackerDataSource {
    public func currentUserLocation() -> CSLocation? {
        return CSLocation(longitude: 0.0, latitude: 0.0)
    }
    
    @objc public func currentNTPTimestamp() -> Date? {
        return Date()
    }
}

extension AnalyticsManager: TrackerDelegate {
    public func getHealthEvent(event: HealthTrackerDTO) {
        print("\(event.eventName ?? ""): \(event)")
    }
    
    @objc public func openEventVisualizer(onController: UIViewController) {
        let viewController = EventVisualizerLandingViewController()
        viewController.hidesBottomBarWhenPushed = true
        let navVC = UINavigationController(rootViewController: viewController)
        navVC.modalPresentationStyle = .overCurrentContext
        navVC.navigationBar.barTintColor = UIColor.white
        navVC.navigationBar.tintColor = UIColor.black
        onController.present(navVC, animated: true, completion: nil)
    }
}

extension AnalyticsManager {
    private func url() -> URL? {
        return URL(string: "enter-your-url-here.com")
    }
    
    private func urlRequest(headerParamaters: [String: String]) -> URLRequest? {
        
        guard let url = self.url() else { return nil }
        var urlRequest = URLRequest(url: url)
        let allHeaders: [String: String] = headerParamaters

        urlRequest.allHTTPHeaderFields = allHeaders
        return urlRequest
    }
    
    private func createHeader() -> [String: String] {
        let integrationApiKey = "" // Add API key here
        if let credentialsData = integrationApiKey.data(using: String.Encoding.utf8) {
            let base64CredentialsString = credentialsData.base64EncodedString()
        
            return ["Authorization": "Basic \(base64CredentialsString)",
                "X-UniqueId": "\(UIDevice.current.identifierForVendor?.uuidString ?? "")"]
        } else {
            return [:]
        }
    }
}
