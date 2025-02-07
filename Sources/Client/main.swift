import SwiftMacros

@AutoChangable
@AutoHashable
class SomeClass {
    @ExcludeChangable
    @ExcludeHashable
    let value_1 = ""
    let value_2: String?
}
