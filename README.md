# KeychainHelper

A nice wrapper for comfortable work with a keychain

## Usage

First you need to define a model that conforming 'KeychainCredential'

```swift
import KeychainHelper

struct MyData: KeychainCredential {
    var sevice: String = "app_service"
    var account: String = "app_account"
    var dataForSave: Int?
}
```
Next, you just need to create an instance of ‘KeychainManager’ and call the save method from it

```swift
import KeychainHelper

let keychainManager = KeychainManager()
let dataToSave = MyData(dataForSave: 20)
keychainManager.save(dataToSave)
```

For reading, also use this model

```swift
import KeychainHelper

let keychainManager = KeychainManager()
let myData = keychainManager.read(MyData(), type: MyData.self)
print(myData.dataForSave ?? 0)
```

That's all!

## Installation

### Swift Package Manager

To integrate KeychainHelper into your Xcode project using Swift Package Manager, add it to the dependencies value of your `Package.swift`:

```swift
dependencies: [
    .package(
        url: "https://github.com/vplatonovv/KeychainHelper.git",
        from: "1.0.0"
    )
]
```
