
import SwiftUI

struct RecentFlightSearchesView: View {
    @ObservedObject var aviationEdgeViewmodel: AviationEdgeViewmodel
    @State private var cachedFlights: [FlightChecklist] = []
    var onSelectAction: (FlightChecklist) -> Void
    
    init(_ vm: AviationEdgeViewmodel, onSelectAction: @escaping (FlightChecklist) -> Void) {
        self.aviationEdgeViewmodel = vm
        self.onSelectAction = onSelectAction
    }
    
    func reloadCachedFlights() {
        cachedFlights = aviationEdgeViewmodel.getCachedFlightsSearch()
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Recent Searches".uppercased())
                    .font(.custom("Gilroy-Medium", size: 14))
                    .foregroundColor(.gray)
                Spacer()
                Text("Clear")
                    .font(.custom("Gilroy-Medium", size: 14))
                    .foregroundColor(.accentColor)
                    .onTapGesture {
                        aviationEdgeViewmodel.clearCachedFlightSearches()
                    }
            }
            Divider()
            VStack {
                ForEach(cachedFlights) { f in
                    VStack(alignment: .leading) {
                        Text("\(f.departureCity?.codeIataAirport ?? "") ➔ \(f.departureCity?.nameAirport ?? "")")
                            .font(.headline)
                        Text("\(f.arrivalCity?.codeIataAirport ?? "") ➔ \(f.arrivalCity?.nameAirport ?? "")")
                            .font(.headline)
                        Text("\(f.flightDate ?? Date(), style: .date)")
                            .font(.subheadline)
                    }
                    .onTapGesture {
                        onSelectAction(f)
                    }
                    .padding(.bottom, 5)
                    Divider()
                }
            }
        }
        .padding()
        .onAppear{
            reloadCachedFlights()
        }
    }
}
