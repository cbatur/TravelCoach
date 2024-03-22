
import SwiftUI

struct SelectFlightResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var aviationEdgeViewmodel: AviationEdgeViewmodel = AviationEdgeViewmodel()
    @State private var futureFlightsParams: AEFutureFlightParams
    @State private var flightCheckList: FlightChecklist
    @State private var isRotating = false

    init(
        flightCheckList: FlightChecklist,
        futureFlightsParams: AEFutureFlightParams
    ) {
        self.flightCheckList = flightCheckList
        self.futureFlightsParams = futureFlightsParams
    }
    
    var body: some View {
        VStack {
            BannerWithDismiss(
                dismiss: dismiss,
                headline: "Flight Search Results".uppercased(),
                subHeadline: subHeaderCities()
            )
            .padding()
            .padding(.top, 10)
            
            if let d = flightCheckList.departureCity, let a = flightCheckList.arrivalCity {
                HStack {
                    AirportCardBasic(airport: d)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    Text("➔")
                        .font(.largeTitle)
                        .foregroundColor(.gray.opacity(0.6))
                        .frame(width: 50)
                    Spacer()
                    AirportCardBasic(airport: a)
                        .frame(maxWidth: .infinity) 
                }
            }
            
            Group {
                if aviationEdgeViewmodel.loading {
                    
                    Image("spinning_logo_trans")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(0.7)
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(isRotating ? 360 : 0))
                        .animation(Animation.linear(duration: 3).repeatForever(autoreverses: false), value: isRotating)
                        .onAppear() {
                            self.isRotating = true
                        }
                    
                } else if aviationEdgeViewmodel.travelData.items.isEmpty {
                    
                    VStack {
                        Image("empty_screen_airport")
                            .resizable()
                            .scaledToFit()
                            .background(Color.clear)
                        Text("No flights found for \n\(aviationEdgeViewmodel.travelData.title)")
                            .font(.custom("Gilroy-Medium", size: 25))
                            .foregroundColor(Color.wbPinkMediumAlt)
                    }
                    .padding(.leading, 45)
                    .padding(.trailing, 45)
                    .frame(alignment: .center)
                    
                } else {
                    ReservationsView(aviationEdgeViewmodel.travelData)
                }
            }
            
            Spacer()
        }
        .background(Color.gray.opacity(0.11))
        .onAppear{
            searchFutureFlights()
        }
    }
}

// SelectFlightResultsView Methods
extension SelectFlightResultsView {
    
    func searchFutureFlights() {
        self.aviationEdgeViewmodel.resetSearchFlights()

        self.aviationEdgeViewmodel.getFutureFlights(
            futureFlightsParams,
            flightChecklist: flightCheckList
        )
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func subHeaderCities() -> String {
        return "\(flightCheckList.departureCity?.nameAirport ?? "") ➔  \(flightCheckList.arrivalCity?.nameAirport ?? "")"
    }
}
