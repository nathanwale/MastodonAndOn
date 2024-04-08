//
//  JsonFileLoader.swift
//  Mastodon
//
//  Created by Nathan Wale on 8/9/2023.
//

import Foundation

/**
    Helpers to load JSON files
 */
struct JsonLoader
{
    /// Local documents directory
    static let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    /// Default decoder
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .mastodon
        return decoder
    }
    
    /// Default encoder
    static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
    
    ///
    /// Load JSON from local URL
    /// - url: URL pointing to local file
    ///
    static func fromLocalUrl<T: Decodable>(_ url: URL) -> T
    {
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            fatalError("Error loading: \(error)")
        }
        
        return fromData(data)
    }
    
    ///
    /// Load JSON from filename
    /// - filename: Name of file to load
    ///
    static func fromFileName<T: Decodable>(_ filename: String) -> T
    {
        guard let fileUrl = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find filename: \(filename)")
        }
        
        return fromLocalUrl(fileUrl)
    }
    
    ///
    /// Load JSON from string
    /// - jsonString: JSON data as a String
    ///
    static func fromString<T: Decodable>(_ jsonString: String) -> T
    {
        guard let data: Data = jsonString.data(using: .utf8)
        else {
            fatalError("Could not load string as Data: \n\(jsonString)")
        }

        return fromData(data)
    }
    
    ///
    /// Decode JSON from Data object
    /// - data: Swift Data object to decode
    ///
    static func fromData<T: Decodable>(_ data: Data) -> T
    {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse: \(error)")
        }
    }
    
    ///
    /// URL for document with name
    ///
    static func documentUrl(name: String) -> URL
    {
        documentDirectoryUrl.appendingPathComponent("\(name).json")
    }
    
    ///
    /// Encode to document directory
    ///
    static func toDocuments(_ encodable: any Encodable, name: String)
    {
        do {
            let url = documentUrl(name: name)
            let data = try encoder.encode(encodable)
            try data.write(to: url)
        } catch {
            fatalError("Couldn't save object to documents: \(error.localizedDescription)")
        }
    }
    
    ///
    /// Deccode from document directory
    ///
    static func fromDocuments<T: Decodable>(name: String) -> T
    {
        let url = documentUrl(name: name)
        return fromLocalUrl(url)
    }
}
