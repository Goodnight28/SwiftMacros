import SwiftMacros

@AutoHashable
class SomeClass {
    @ExcludeHashable
    let value_1 = ""
    let value_2: String?
}
