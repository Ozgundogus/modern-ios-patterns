#if canImport(SwiftUI)
import BrewDomain
import SwiftUI

public struct RoastPicker: View {
    @Binding private var roast: Roast?

    public init(roast: Binding<Roast?>) {
        _roast = roast
    }

    public var body: some View {
        Picker("Roast", selection: $roast) {
            Text("All").tag(Roast?.none)
            ForEach(Roast.allCases) { roast in
                Text(roast.displayName).tag(Roast?.some(roast))
            }
        }
        .pickerStyle(.segmented)
    }
}
#endif
