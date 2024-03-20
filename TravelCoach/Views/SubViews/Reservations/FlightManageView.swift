
import SwiftUI
import Popovers

struct FlightManageView: View {
    @Environment(\.presentationMode) var presentationMode
    @Bindable var destination: Destination
    @StateObject var aviationEdgeViewmodel: AviationEdgeViewmodel = AviationEdgeViewmodel()
    @State private var flightDate = Date()

    @State private var launchSearchAirport: Bool = false
    @State private var launchSearchResultsView: Bool = false
    @State private var isArrivalActive: Bool = false
    @State private var enlargeSearchPanel: Bool = true
        
    @State private var departureCity: AEAirport.AECity?
    @State private var arrivalCity: AEAirport.AECity?
    @State private var airportType: AirportType = .departure

    init(destination: Destination) {
        _destination = Bindable(wrappedValue: destination)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                BannerWithDismiss(
                    dismiss: dismiss,
                    headline: "Add Flights to Trip".uppercased(),
                    subHeadline: "Search for a one-way flight"
                )
                .padding()
                .padding(.top, 10)
                
                DatePicker("FLIGHT DATE", selection: $flightDate, in: Date()..., displayedComponents: .date)
                    .font(.custom("Satoshi-Bold", size: 15))
                    .padding(.leading, 15)
                    .foregroundColor(.gray)
                    .background(Color.white)
                    .cornerRadius(9)
                
                VStack {
                    VStack {
                        HStack {
                            Button(action: {
                                enlargeSearchPanel.toggle()
                            }) {
                                HStack {
                                    Image(systemName: enlargeSearchPanel ? "chevron.up" : "chevron.down")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.gray)
                                }
                            }
                            .isHidden(isNotReadyForSearch())
                            .disabled(isNotReadyForSearch())
                            
                            Text(enlargeSearchPanel ? "" : airportCodesHeader())
                                .foregroundColor(.wbPinkMedium)
                                .font(.custom("Gilroy-Medium", size: 18))
                        }
                        
                        if (enlargeSearchPanel) {
     
                            Divider()
                            
                            HStack {
                                Image(systemName: "clock.arrow.circlepath")
                                    .foregroundColor(flightDate < Date() ? .gray.opacity(0.4) : .green)
                                    .font(.largeTitle)
                                    .frame(width: 45)
                                
                                VStack {
                                    if flightDate < Date() {
                                        Text("SELECT A FUTURE DATE")
                                            .font(.custom("Gilroy-Bold", size: 18))
                                            .foregroundColor(Color.gray)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    } else {
                                        Text(formatDateDisplay(flightDate))
                                            .font(.custom("Gilroy-Medium", size: 22))
                                            .foregroundColor(Color.green)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                
                            }
                            
                            Divider()
                            
                            HStack {
                                Button {
                                    launchSearchAirport = true
                                    airportType = .departure
                                } label: {
                                    if let departureCity = departureCity {
                                        AirportCard(airport: departureCity)
                                    } else {
                                        Image(systemName: "airplane.departure")
                                            .foregroundColor(.gray.opacity(0.4))
                                            .font(.largeTitle)
                                            .frame(width: 45)
                                        
                                        VStack {
                                            Text(departureStatus().0.uppercased())
                                                .font(.custom("Gilroy-Bold", size: 18))
                                                .foregroundColor(Color.black.opacity(0.7))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .padding()
                                        
                                        Spacer()
                                        Image(systemName: "chevron.forward")
                                            .foregroundColor(.gray)
                                            .font(.subheadline)
                                    }
                                }
                            }
                            
                            Divider()
                            
                            HStack {
                                Button {
                                    launchSearchAirport = true
                                    airportType = .arrival
                                } label: {
                                    if let arrivalCity = arrivalCity {
                                        AirportCard(airport: arrivalCity)
                                    } else {
                                        Image(systemName: "airplane.arrival")
                                            .foregroundColor(.gray.opacity(0.4))
                                            .font(.largeTitle)
                                            .frame(width: 45)
                                        
                                        VStack {
                                            Text(arrivalStatus().0.uppercased())
                                                .font(.custom("Gilroy-Bold", size: 18))
                                                .foregroundColor(Color.black.opacity(0.7))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                        }
                                        .padding()
                                        
                                        Spacer()
                                        Image(systemName: "chevron.forward")
                                            .foregroundColor(.gray)
                                            .font(.subheadline)
                                    }
                                }
                            }
                            
                            Divider()
                            
                            Button {
                                searchFutureFlights()
                            } label: {
                                Text("SEARCH FOR FLIGHTS")
                                    .padding()
                                    .cardStyle(.wbPinkShade)
                            }
                        }
                    }
                }
                .padding()
                .cardStyle(.white)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
            RecentFlightSearchesView(aviationEdgeViewmodel, onSelectAction: setChecklist)
                .isHidden(!self.aviationEdgeViewmodel.travelData.isEmpty)

        }
        .background(Color.gray.opacity(0.11))
        .opacity(launchSearchAirport ? 0.2 : 1.0)
        .popover(
            present: $launchSearchAirport,
            attributes: {
                $0.position = .relative(
                    popoverAnchors: [
                        .top,
                    ]
                )

                let animation = Animation.spring(
                    response: 0.6,
                    dampingFraction: 0.8,
                    blendDuration: 1
                )
                let transition = AnyTransition.move(edge: .bottom).combined(with: .opacity)

                $0.presentation.animation = animation
                $0.presentation.transition = transition
                $0.dismissal.mode = [.dragDown, .tapOutside]
            }
        ) {
            SearchAirportPopover(
                present: $launchSearchAirport,
                action: fetchedFromChild,
                airportType: airportType
            )
            .frame(maxWidth: 500, maxHeight: 700, alignment: .top)
        }
        .onChange(of: self.flightDate) { _, newDate in
            self.aviationEdgeViewmodel.deActivateSearch()
        }
        .onChange(of: self.aviationEdgeViewmodel.searchPerformed) { _, searchActive in
            enlargeSearchPanel = !searchActive
        }
        .onChange(of: enlargeSearchPanel) { _, value in
            if value {
                self.aviationEdgeViewmodel.deActivateSearch()
            }
        }
        .sheet(isPresented: $launchSearchResultsView) {
            let futureFlightsParams = AEFutureFlightParams(
                iataCode: departureCity?.codeIataAirport ?? "",
                type: "departure",
                date: formatDateParameter(flightDate)
            )
            
            SelectFlightResultsView(flightCheckList: flightCheckList(), futureFlightsParams: futureFlightsParams)
        }
    }
}

extension FlightManageView {
    
    func setChecklist(_ f: FlightChecklist) {
        self.departureCity = f.departureCity
        self.arrivalCity = f.arrivalCity
        self.flightDate = f.flightDate ?? Date()
        
        searchFutureFlights()
    }
    
    func searchFutureFlights() {
        launchSearchResultsView = true
    }
    
    func fetchedFromChild(
        fromChild passedAirport: AEAirport.AECity,
        airportType: AirportType
    ) {
        self.aviationEdgeViewmodel.deActivateSearch()
        
        if airportType == .arrival {
            arrivalCity = passedAirport
        } else {
            departureCity = passedAirport
        }
    }
    
    private func departureStatus() -> (String, Color, Color) {
        if let airport = departureCity {
            return (airport.nameAirport, .white, .wbPinkMediumAlt)
        } else {
            return ("Select Departure Airport", .gray, .gray.opacity(0.2))
        }
    }
    
    private func arrivalStatus() -> (String, Color, Color) {
        if let airport = arrivalCity {
            return (airport.nameAirport, .white, .wbPinkMediumAlt)
        } else {
            return ("Select Arrival Airport", .gray, .gray.opacity(0.2))
        }
    }
    
    private func flightCheckList() -> FlightChecklist {
        return FlightChecklist(
            departureCity: departureCity,
            arrivalCity: arrivalCity,
            flightDate: flightDate
        )
    }
    
    private func isNotReadyForSearch() -> Bool {
        return (
            arrivalCity == nil ||
            departureCity == nil ||
            flightDate <= Date()
        )
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func airportCodesHeader() -> String {
        guard let d = departureCity, let a = arrivalCity else {
            return ""
        }
        
        return d.codeIataCity.uppercased() + " - " + a.codeIataCity.uppercased()
    }
    
    func formatDateParameter(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }

}

public func formatDateDisplay(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
    return dateFormatter.string(from: date)
}

struct SearchAirportPopover: View {
    @StateObject var viewModel: AvionEdgeAutocompleteViewModel = AvionEdgeAutocompleteViewModel()
    
    @FocusState private var isInputActive: Bool

    @Binding var present: Bool
    @State var selection: String?
    
    var action: (AEAirport.AECity, AirportType) -> Void
    var airportType: AirportType

    private func clearText() {
        viewModel.resetSearch()
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 14) {
                HStack {
                    Image(systemName: airportType.icon)
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text("\(airportType.message)".uppercased())
                        .font(.custom("Gilroy-Medium", size: 18))
                        .foregroundColor(.black.opacity(0.8))
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 16)
                    
                    Spacer()

                    Button {
                        present = false
                        selection = nil
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 19))
                            .foregroundColor(.secondary)
                            .frame(width: 38, height: 38)
                            .background(Color(uiColor: .systemBackground))
                            .cornerRadius(19)
                    }
                }
                
                TextField(airportType.placeholder, text: $viewModel.query)
                    .focused($isInputActive)
                    .font(.subheadline)
                    .padding()
                    .foregroundColor(.gray)
                    .background(Color.white)
                    .cornerRadius(9)
                    .overlay(
                        HStack {
                            Spacer()
                            if !viewModel.query.isEmpty {
                                Button(action: clearText) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .font(.headline)
                                }
                                .padding(.trailing, 10)
                            }
                        }
                    )
            }
            .padding(24)
            
            VStack {
                ForEach(viewModel.suggestions.prefix(6), id: \.self) { airport in
                    AirportCard(airport: airport)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                action(airport, airportType)
                                present = false
                                selection = nil
                            }
                        }
                }
            }
            .padding()
        }
        .background(Color.gray7)
        .cornerRadius(16)
        .popoverShadow(shadow: .system)
        .onTapGesture {
            withAnimation(.spring()) {
                selection = nil
            }
        }
    }
}

struct AirportCard: View {
    var airport: AEAirport.AECity
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Image(airport.nameCountry)
                        .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 26, height: 26)
                            .clipShape(Circle())
                    VStack {
                        Text(airport.nameAirport)
                            .font(.custom("Gilroy-Medium", size: 19))
                            .foregroundColor(Color.black)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20, alignment: .leading)
                        
                        HStack {
                            Text("\(airport.nameCountry)")
                                .font(.custom("Gilroy-Bold", size: 17))
                                .foregroundColor(Color.gray)
                            
                            Text("\(airport.timezone)")
                                .font(.custom("Gilroy-Regular", size: 16))
                                .foregroundColor(Color.gray)
                        }
                    }
                }
            }
            .padding()
            
            Text(airport.codeIataAirport)
                .font(.custom("Gilroy-Bold", size: 20))
                .foregroundColor(Color.wbPinkMediumAlt)
        }
        .padding()
        .cardStyle(.white)
    }
}

struct AirportCardBasic: View {
    var airport: AEAirport.AECity
    
    var body: some View {
        VStack {
            HStack {
                Image(airport.nameCountry)
                    .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 26, height: 26)
                        .clipShape(Circle())
                
                Text(airport.codeIataAirport)
                    .font(.custom("Gilroy-Bold", size: 20))
                    .foregroundColor(Color.wbPinkMediumAlt)
            }
            
            Text("\(airport.nameCountry)")
                .font(.custom("Gilroy-Bold", size: 17))
                .foregroundColor(Color.gray)
        }
        .padding()
        .cardStyle(.white)
    }
}

struct FlightChecklist: Decodable, Encodable, Identifiable {
    var id = UUID()
    
    let departureCity: AEAirport.AECity?
    let arrivalCity: AEAirport.AECity?
    let flightDate: Date?
}
