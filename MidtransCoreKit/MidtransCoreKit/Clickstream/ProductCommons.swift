//
//  ProductCommons.swift
//  ClickStream
//
//  Created by Anirudh Vyas on 10/08/20.
//  Copyright © 2020 Gojek. All rights reserved.
//

import Foundation

public protocol ProductCommons: Message {
    var meta: Midtrans_Clickstream_Meta_EventMeta { get set }
    var eventTimestamp:  Google_Protobuf_Timestamp { get set }
    var deviceTimestamp:  Google_Protobuf_Timestamp { get set }
    var eventName: String { get set }
    var product: Midtrans_Clickstream_Products_Common_Product { get set }
}
