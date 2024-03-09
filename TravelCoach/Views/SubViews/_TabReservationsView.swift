
import SwiftUI

struct _TabReservationsView: View {
    @Bindable var destination: Destination

    init(destination: Destination) {
        _destination = Bindable(wrappedValue: destination)
    }
    
    var body: some View {
        VStack {
            Text("Reservations")
            //ReservationsView()
        }
    }
}

