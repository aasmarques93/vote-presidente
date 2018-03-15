//
//  Candidate.swift
//
//  Created by Arthur Augusto Sousa Marques on 3/15/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class Candidate: Model {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let descriptionValue = "description"
    static let name = "name"
    static let currentPosition = "currentPosition"
    static let broken = "broken"
    static let id = "id"
    static let photoUrl = "photoUrl"
  }

  // MARK: Properties
  public var descriptionValue: String?
  public var name: String?
  public var currentPosition: String?
  public var broken: String?
  public var id: Int?
  public var photoUrl: String?
  public var imageData: Data?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    descriptionValue = json[SerializationKeys.descriptionValue].string
    name = json[SerializationKeys.name].string
    currentPosition = json[SerializationKeys.currentPosition].string
    broken = json[SerializationKeys.broken].string
    id = json[SerializationKeys.id].int
    photoUrl = json[SerializationKeys.photoUrl].string
    super.init(json: json)
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = descriptionValue { dictionary[SerializationKeys.descriptionValue] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = currentPosition { dictionary[SerializationKeys.currentPosition] = value }
    if let value = broken { dictionary[SerializationKeys.broken] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = photoUrl { dictionary[SerializationKeys.photoUrl] = value }
    return dictionary
  }

}
