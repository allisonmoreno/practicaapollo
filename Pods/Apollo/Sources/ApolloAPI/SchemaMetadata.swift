/// A protocol that a generated GraphQL schema should conform to.
///
/// The generated schema metadata is the source of information about the generated types in the
/// schema. It is used to map each object in a `GraphQLResponse` to the ``Object`` type
/// representing the response object.
public protocol SchemaMetadata {

  /// A ``SchemaConfiguration`` that provides custom configuration for the generated GraphQL schema.
  static var configuration: SchemaConfiguration.Type { get }

  /// Maps each object in a `GraphQLResponse` to the ``Object`` type representing the
  /// response object.
  ///
  /// > Note: This function will be generated by the code generation engine. You should never
  /// alter the generated implementation or implement this function manually.
  ///
  /// - Parameter typename: The value of the `__typename` field of the response object.
  /// - Returns: An ``Object`` type representing the response object if the type is known to the
  /// schema. If the schema does not include a known ``Object`` with the given ``Object/typename``,
  /// returns `nil`.
  static func objectType(forTypename typename: String) -> Object?
}

extension SchemaMetadata {

  /// A convenience function for getting the ``Object`` type representing a response object.
  ///
  /// Calls the ``objectType(forTypename:)`` function with the value of the objects `__typename`
  /// field.
  ///
  /// - Parameter object: A ``JSONObject`` dictionary representing an object in a GraphQL response.
  /// - Returns: An ``Object`` type representing the response object if the type is known to the
  /// schema. If the schema does not include a known ``Object`` with the given ``Object/typename``,
  /// returns `nil`.
  @inlinable public static func graphQLType(for object: JSONObject) -> Object? {
    guard let typename = object["__typename"] as? String else {
      return nil
    }
    return objectType(forTypename: typename) ??
    Object(typename: typename, implementedInterfaces: [])
  }

  /// Resolves the ``CacheReference`` for an object in a GraphQL response to be used by
  /// `NormalizedCache` mechanisms.
  ///
  /// Maps the type of the `object` using the ``graphQLType(for:)`` function, then gets the
  /// ``CacheKeyInfo`` for the `object` using the ``SchemaConfiguration/cacheKeyInfo(for:object:)``
  /// function.
  /// Finally, this function transforms the ``CacheKeyInfo`` into the correct ``CacheReference``
  /// for the `NormalizedCache`.
  ///
  /// - Parameter object: A ``JSONObject`` dictionary representing an object in a GraphQL response.
  /// - Returns: The ``CacheReference`` for the `object` to be used by
  /// `NormalizedCache` mechanisms.
  @inlinable public static func cacheKey(for object: JSONObject) -> CacheReference? {
    guard let type = graphQLType(for: object),
          let info = configuration.cacheKeyInfo(for: type, object: object) else {
      return nil
    }
    return CacheReference("\(info.uniqueKeyGroup ?? type.typename):\(info.id)")
  }
}
