// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: midtrans/clickstream/meta/Device.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

///platform="ios,android"

import Foundation
import SwiftProtobuf

public class Midtrans_Clickstream_Meta_Device {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///ios android
  public var platform: String = String()

  public var osVersion: String = String()

  public var network: String = String()

  ///RMX1941 for android, ios iPhone8,2
  public var model: String = String()

  ///Realme, Apple
  public var manufacturer: String = String()

  ///Realme, Apple
  public var brand: String = String()

  public var screenHeight: String = String()

  public var screenWidth: String = String()

  public var deviceID: String = String()

  ///tablet or mobile
  public var deviceType: String = String()

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  required public init() {}
}

#if swift(>=5.5) && canImport(_Concurrency)
extension Midtrans_Clickstream_Meta_Device: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "midtrans.clickstream.meta"

extension Midtrans_Clickstream_Meta_Device: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".Device"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "platform"),
    2: .standard(proto: "os_version"),
    3: .same(proto: "network"),
    4: .same(proto: "model"),
    5: .same(proto: "manufacturer"),
    6: .same(proto: "brand"),
    7: .standard(proto: "screen_height"),
    8: .standard(proto: "screen_width"),
    9: .standard(proto: "device_id"),
    10: .standard(proto: "device_type"),
  ]

  public func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.platform) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.osVersion) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.network) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.model) }()
      case 5: try { try decoder.decodeSingularStringField(value: &self.manufacturer) }()
      case 6: try { try decoder.decodeSingularStringField(value: &self.brand) }()
      case 7: try { try decoder.decodeSingularStringField(value: &self.screenHeight) }()
      case 8: try { try decoder.decodeSingularStringField(value: &self.screenWidth) }()
      case 9: try { try decoder.decodeSingularStringField(value: &self.deviceID) }()
      case 10: try { try decoder.decodeSingularStringField(value: &self.deviceType) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.platform.isEmpty {
      try visitor.visitSingularStringField(value: self.platform, fieldNumber: 1)
    }
    if !self.osVersion.isEmpty {
      try visitor.visitSingularStringField(value: self.osVersion, fieldNumber: 2)
    }
    if !self.network.isEmpty {
      try visitor.visitSingularStringField(value: self.network, fieldNumber: 3)
    }
    if !self.model.isEmpty {
      try visitor.visitSingularStringField(value: self.model, fieldNumber: 4)
    }
    if !self.manufacturer.isEmpty {
      try visitor.visitSingularStringField(value: self.manufacturer, fieldNumber: 5)
    }
    if !self.brand.isEmpty {
      try visitor.visitSingularStringField(value: self.brand, fieldNumber: 6)
    }
    if !self.screenHeight.isEmpty {
      try visitor.visitSingularStringField(value: self.screenHeight, fieldNumber: 7)
    }
    if !self.screenWidth.isEmpty {
      try visitor.visitSingularStringField(value: self.screenWidth, fieldNumber: 8)
    }
    if !self.deviceID.isEmpty {
      try visitor.visitSingularStringField(value: self.deviceID, fieldNumber: 9)
    }
    if !self.deviceType.isEmpty {
      try visitor.visitSingularStringField(value: self.deviceType, fieldNumber: 10)
    }
    try unknownFields.traverse(visitor: &visitor)
  }
}

public extension Midtrans_Clickstream_Meta_Device {
         
    init(properties: inout [String:Any],
         eventName: String,
         product:Midtrans_Clickstream_Products_Common_Product? = .generic) {

         self.init(properties: &properties,
                  eventName: eventName,
                  product: product, propertyPath: "")
    }
         
    internal init(properties: inout [String:Any],
         eventName: String,
         product:Midtrans_Clickstream_Products_Common_Product? = .generic, propertyPath: String = "") {

         
    }
}