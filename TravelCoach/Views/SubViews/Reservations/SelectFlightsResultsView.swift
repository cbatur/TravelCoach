
import SwiftUI

struct SelectFlightResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var aviationEdgeViewmodel: AviationEdgeViewmodel = AviationEdgeViewmodel()
    @State private var futureFlightsParams: AEFutureFlightParams
    @State private var flightCheckList: FlightChecklist

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
                    
                    Text("➔")
                        .font(.largeTitle)
                        .foregroundColor(.gray.opacity(0.6))
                        .frame(width: 50)
                    
                    AirportCardBasic(airport: a)
                        .frame(maxWidth: .infinity) 
                }
            }
            
            ReservationsView(self.aviationEdgeViewmodel.travelData)
                .isHidden(self.aviationEdgeViewmodel.travelData.isEmpty)

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
