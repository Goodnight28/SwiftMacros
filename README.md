# Swift Macros

This repository provides four powerful Swift macros to simplify boilerplate code when working with Swift types: `AutoEquatable`, `AutoHashable`, `AutoInit`, and `AutoChangable`.

## Installation

To use these macros in your project, add the package to your `Package.swift` file:

```swift
.package(url: "https://github.com/Goodnight28/SwiftMacros.git", from: "1.0.0")
```

Then, add the required dependencies to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: ["SwiftMacros"]
)
```

## Macros Overview

### `@AutoEquatable`
Generates `Equatable` conformance for structs, classes, and enums.

You can exclude specific properties from comparison by marking them with `@ExcludeEquatable`.

#### Example:
```swift
@AutoEquatable
struct User {
    let id: Int
    let name: String
    @ExcludeEquatable var callback: () -> Void
}
```

Generated code:
```swift
extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        guard lhs.id == rhs.id else { return false }
        guard lhs.name == rhs.name else { return false }
        return true
    }
}
```

### `@AutoHashable`
Generates `Hashable` conformance for structs, classes, and enums.

You can exclude specific properties from hash calculation by marking them with `@ExcludeHashable`.

#### Example:
```swift
@AutoHashable
struct User {
    let id: Int
    let name: String
    @ExcludeHashable var sessionToken: String
}
```

Generated code:
```swift
extension User: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}
```

### `@AutoInit`
Generates an initializer for structs and classes based on their properties.

You can exclude specific properties from the generated initializer by marking them with `@ExcludeInit`.

#### Example:
```swift
@AutoInit
struct User {
    let id: Int
    let name: String
    @ExcludeInit let createdAt: Date
}
```

Generated code:
```swift
struct User {
    ...
    
    init(
        id: Int,
        name: String
    ) {
        self.id = id
        self.name = name
    }
}
```

### `@AutoChangable`
Creates a `changing` method that returns a copy of the object with modified properties.

You can exclude specific properties from modification by marking them with `@ExcludeChangable`.

#### Example:
```swift
@AutoChangable
struct User {
    let id: Int?
    let name: String
    @ExcludeChangable let createdAt: Date
}
```

Generated code:
```swift
struct User {
    ...

    func changing(
        id: Int?? = nil,
        name: String? = nil
    ) -> User {
        User(
            id: id ?? self.id, 
            name: name ?? self.name
        )
    }
}
```

## License

This project is licensed under the MIT License.

