// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated during code gen stage using `CorrespondsTo` annotation.
// Copyright © 2020 Gojek. All rights reserved.

import Foundation

@objcMembers
public class ClickstreamContractFactory {

    public static func constructContract(eventName: String,
                         properties: [String: Any]) -> Message? {
        switch eventName {
        
        case "pg gopay", "pg select atm transfer", "GP KYC Upgrade Dialog Displayed", "GP KYC Launched", "GP KYC Homescreen Displayed", "GP KYC Camera Opened", "GP KYC Document Viewed", "GP KYC Document Preview Viewed", "GP KYC Selfie Viewed", "GP KYC Selfie Preview Viewed", "GP KYC All Documents Viewed", "GP KYC Image Capture Mode Change Viewed", "GP KYC Selfie Prepare Screen Viewed", "GP KYC Selfie Prepare Wait Screen Viewed", "GP KYC View Document Screen Viewed", "GP KYC Form Viewed", "GP KYC Form Review Viewed", "GP KYC One KYC Blocked", "GP KYC Challenge Viewed", "GP KYC Status Widget Viewed", "GP KYC FE Permission Ask Viewed", "GP KYC System Permission Ask Viewed", "GP KYC Status Screen Viewed", "GP KYC Consent Screen Viewed", "GP KYC User Details Viewed", "GP KYC ML Model Download Error Dialog Shown", "GP KYC Homescreen Redirect Widget Shown", "GP KYC Document Uploading Screen Viewed", "GP KYC Document Upload Failure Screen Viewed":
            return Midtrans_Clickstream_Products_Events_Ui_Page(properties: properties, eventName: eventName)
        
        default:
            return nil
        }
    }
}

