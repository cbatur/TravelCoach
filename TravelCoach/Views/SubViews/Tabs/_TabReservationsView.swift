
import SwiftUI

struct _TabReservationsView: View {
    @Bindable var destination: Destination
    @State private var displayBottomToolbar = true
    @State private var flightManageViewDisplay = false

    init(destination: Destination) {
        _destination = Bindable(wrappedValue: destination)
    }
    
    var body: some View {
        VStack {
            Text("Reservations")
                .cardStyle(.gray)
            //ReservationsView()
            
            VStack {
                VStack {
                    if self.displayBottomToolbar == false {
    
                        Text("Dates Entered Here")
                            .font(.custom("Satoshi-Bold", size: 15))
                            .padding(7)
                            .background(.white)
                            .foregroundColor(.wbPinkMedium)
                            .cornerRadius(5)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, alignment: .center)
                        .onTapGesture {
                            self.displayBottomToolbar = true
                        }
                        .animation(.easeInOut(duration: 0.3), value: displayBottomToolbar)
    
                    } else {
    
                        VStack {
                            Button(action: {
                                self.displayBottomToolbar = false
                            }) {
                                HStack {
                                    Image(systemName: "chevron.down")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.gray)
                                }
                            }
    
                            HStack {
                                Button {
                                    flightManageViewDisplay = true
                                } label: {
                                    Text("ADD FLIGHT")
                                        .font(.custom("Satoshi-Bold", size: 15))
                                        .padding(7)
                                        .background(.white)
                                        .foregroundColor(.wbPinkMedium)
                                        .cornerRadius(5)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, alignment: .center)
    
                                Button {
                                    //self.launchAllEvents = true
                                } label: {
                                    Text("PERSONALIZE")
                                        .font(.custom("Satoshi-Bold", size: 15))
                                        .padding(7)
                                        .background(.white)
                                        .foregroundColor(.wbPinkMedium)
                                        .cornerRadius(5)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, alignment: .center)
                            }
                        }
                        .animation(.easeInOut(duration: 0.3), value: displayBottomToolbar)
                        .padding()
                    }
                }
                .padding()
                .cardStyle(.black.opacity(0.5))
            }
        }
        .sheet(isPresented: $flightManageViewDisplay) {
            FlightManageView(destination: destination)
        }
    }
}

