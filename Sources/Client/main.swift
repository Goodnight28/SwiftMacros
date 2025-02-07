import SwiftMacros

@AutoChangable
@AutoEquatable
@AutoHashable
@AutoInit
class SomeClass {
    @ExcludeChangable
    @ExcludeEquatable
    @ExcludeHashable
    @ExcludeInit
    let value_1 = ""
    let value_2: String?
}
