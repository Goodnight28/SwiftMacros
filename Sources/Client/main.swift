import SwiftMacros

@AutoChangable
@AutoEquatable
@AutoHashable
class SomeClass {
    @ExcludeChangable
    @ExcludeEquatable
    @ExcludeHashable
    let value_1 = ""
    let value_2: String?
}
