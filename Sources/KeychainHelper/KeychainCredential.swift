import Foundation

/**
 Protocol for saving data into keycain by models
 */
public protocol KeychainCredential {
    
    var service: String { get }
    var account: String { get }
    
}

public extension KeychainCredential {
    
    var service: String {
        return "service"
    }
    
    var account: String {
        return "account"
    }
    
}
