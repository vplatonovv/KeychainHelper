import Foundation

/**
 Manager for working with Keychain keys.
 
 The manager allows you to save, read and delete data from the Keychain. To use the KeychainManager methods, you need to create an instance of the class.
 */
public final class KeychainManager {
    
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    /**
     Initializes an instance of the KeychainManager class with default classes of decoder/encoder.
     */
    public init() {
        self.encoder = JSONEncoder()
        self.encoder.outputFormatting = .prettyPrinted
        self.decoder = JSONDecoder()
    }
    
    /**
     Initializes an instance of the KeychainManager class.
     
     - Parameters:
     - encoder: For encode saving data.
     - decoder: For decode saved data.
     */
    public init(encoder: JSONEncoder, decoder: JSONDecoder) {
        self.encoder = encoder
        self.encoder.outputFormatting = .prettyPrinted
        self.decoder = decoder
    }
    
    /**
     Deletes data from Keychain.
     
     - Parameter item: A data element.
     */
    public func delete(_ item: KeychainCredential) {
        let query = [
            kSecAttrService: item.service,
            kSecAttrAccount: item.account,
            kSecClass: kSecClassGenericPassword,
        ] as [CFString : Any] as CFDictionary
        
        SecItemDelete(query)
    }
    
    /**
     Saves data in Keychain.
     
     - Parameter item: Data object.
     */
    public func save<T: Codable & KeychainCredential>(_ item: T) {
        do {
            let data = try encoder.encode(item)
            save(data, item)
        } catch {
            assertionFailure("Fail to encode item for keychain: \(error)")
        }
    }
    
    /**
     Reads data from Keychain.
     
     - Parameters:
     - item: A data item.
     - type: Data type.
     
     - Returns: A value of type T.
     */
    public func read<T: Codable>(_ item: KeychainCredential, type: T.Type) -> T? {
        guard let data = read(item) else { return nil }
        do {
            let item = try decoder.decode(type, from: data)
            return item
        } catch {
            assertionFailure("Fail to decode item for keychain: \(error)")
            return nil
        }
    }
    
    /**
     Updates the data in the Keychain.
     
     - Parameters:
     - data: New data to update.
     - item: A data item.
     */
    public func update(_ data: Data, _ item: KeychainCredential) {
        let query = [
            kSecAttrService: item.service,
            kSecAttrAccount: item.account,
            kSecClass: kSecClassGenericPassword,
        ] as [CFString : Any] as CFDictionary
        
        let attributesToUpdate = [kSecValueData: data] as CFDictionary
        SecItemUpdate(query, attributesToUpdate)
    }
}

private extension KeychainManager {
    
    /**
     Reads data from Keychain.
     
     - Parameter item: A data element.
     
     - Returns: A value of the Data type.
     */
    func read(_ item: KeychainCredential) -> Data? {
        let query = [
            kSecAttrService: item.service,
            kSecAttrAccount: item.account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as [CFString : Any] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    /**
     Saves data in Keychain.
     
     - Parameters:
     - data: Data to save.
     - item: A data item.
     */
    func save(_ data: Data, _ item: KeychainCredential) {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: item.service,
            kSecAttrAccount: item.account,
        ] as [CFString : Any] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            update(data, item)
        }
    }
}
