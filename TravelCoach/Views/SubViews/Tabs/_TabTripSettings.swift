
import SwiftUI

struct _TabTripSettings: View {
    @Bindable var destination: Destination

    init(destination: Destination) {
        _destination = Bindable(wrappedValue: destination)
    }
    
    var body: some View {
        Text("Trip Settings")
    }
}
