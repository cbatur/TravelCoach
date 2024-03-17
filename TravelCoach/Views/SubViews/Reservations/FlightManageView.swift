
import SwiftUI
import Popovers

struct FlightChecklist {
    let departureCity: AEAirport.AECity?
    let arrivalCity: AEAirport.AECity?
    let flightDate: Date?
}

enum AirportType {
    case departure
    case arrival
    
    var message: String {
        switch self {
        case .departure:
            return "Select your airport of departure"
        case .arrival:
            return "Select your arrival airport"
        }
    }
    
    var placeholder: String {
        switch self {
        case .departure:
            return "Departure Airport"
        case .arrival:
            return "Arrival Airport"
        }
    }
}

struct FlightManageView: View {
    @Environment(\.presentationMode) var presentationMode
    @Bindable var destination: Destination
    @StateObject var aviationEdgeViewmodel: AviationEdgeViewmodel = AviationEdgeViewmodel()
    @State private var flightDate = Date()

    @State private var launchDepartureAirport: Bool = false
    @State private var isArrivalActive: Bool = false
        
    @State private var departureCity: AEAirport.AECity?
    @State private var arrivalCity: AEAirport.AECity?
    @State private var airportType: AirportType = .departure

    init(destination: Destination) {
        _destination = Bindable(wrappedValue: destination)
    }
    
    func searchFutureFlights() {
        self.aviationEdgeViewmodel.resetSearchFlights()
        
        let futureFlightsParams = AEFutureFlightParams(
            iataCode: departureCity?.codeIataAirport ?? "",
            type: "departure",
            date: "2024-04-03"        )
        
        self.aviationEdgeViewmodel.getFutureFlights(futureFlightsParams, filterAirportCode: arrivalCity?.codeIataCity ?? "")
    }
    
    func fetchedFromChild(
        fromChild passedAirport: AEAirport.AECity,
        airportType: AirportType
    ) {
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
            return ("Departure Airport", .gray, .gray.opacity(0.2))
        }
    }
    
    private func arrivalStatus() -> (String, Color, Color) {
        if let airport = arrivalCity {
            return (airport.nameAirport, .white, .wbPinkMediumAlt)
        } else {
            return ("Arrival Airport", .gray, .gray.opacity(0.2))
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
    
    var body: some View {
        ScrollView {
            BannerWithDismiss(
                dismiss: dismiss,
                headline: "Add Flights to Trip".uppercased(),
                subHeadline: "Search For a one-way flight"
            )
            .padding()
            .padding(.top, 10)

            VStack {
                
                DatePicker("FLIGHT DATE", selection: $flightDate, in: Date()..., displayedComponents: .date)
                    .font(.custom("Satoshi-Bold", size: 15))
                    .padding(.leading, 15)
                    .foregroundColor(.gray)
                    .background(Color.white)
                    .cornerRadius(9)
                
                HStack {
                    Button {
                        launchDepartureAirport = true
                        airportType = .departure
                    } label: {
                        Text(departureStatus().0)
                            .font(.headline)
                            .foregroundColor(departureStatus().1)
                            .padding()
                            .background(departureStatus().2)
                            .cornerRadius(8)
                    }
                    
                    Button {
                        launchDepartureAirport = true
                        airportType = .arrival
                    } label: {
                        Text(arrivalStatus().0)
                            .font(.headline)
                            .foregroundColor(arrivalStatus().1)
                            .padding()
                            .background(arrivalStatus().2)
                            .cornerRadius(8)
                    }
                        
                }
                .padding()
                .cardStyle(.gray.opacity(0.2))
            }
            .padding()
           
            ReservationsView(self.aviationEdgeViewmodel.travelData)
                .isHidden(self.aviationEdgeViewmodel.travelData.isEmpty)
            
            FlightSearchCheckListView(
                flightChecklist: flightCheckList(),
                searchAction: searchFutureFlights
            )
                .isHidden(isNotReadyForSearch())
        }
        .popover(
            present: $launchDepartureAirport,
            attributes: {
                $0.position = .relative(
                    popoverAnchors: [
                        .center,
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
            TutorialViewPopover(
                present: $launchDepartureAirport,
                action: fetchedFromChild,
                airportType: airportType
            )
                .frame(maxWidth: 500, maxHeight: 600)
        }
    }
}

struct FlightSearchCheckListView: View {
    
    var flightChecklist: FlightChecklist
    var searchAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Search for Flights")
                .font(.headline)
            
            Text("\(self.flightChecklist.flightDate)")
                .font(.caption)
            
            HStack {
                VStack {
                    Text("DEPARTURE")
                        .font(.caption)
                    Text("\(flightChecklist.departureCity?.nameAirport ?? "-")")
                }
                
                VStack {
                    Text("ARRIVAL")
                        .font(.caption)
                    Text("\(flightChecklist.arrivalCity?.nameAirport ?? "-")")
                }
            }
            
            Button {
                searchAction()
            } label: {
                Text("SEARCH FOR FLIGHTS")
                    .padding()
                    .cardStyle(.wbPinkShade)
            }
            .padding(.bottom, 20)

        }
    }
}

struct TutorialViewPopover: View {
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
                    Text("\(airportType.message)")
                        .font(.custom("Gilroy-Medium", size: 16))
                        .accentColor(.blue)
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
                ForEach(viewModel.suggestions, id: \.self) { suggestion in
                    HStack {
                        Text(suggestion.codeIcaoAirport)
                        
                        Text(suggestion.nameAirport)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20, alignment: .leading)
                    }
                    .onTapGesture {
                        withAnimation(.spring()) {
                            action(suggestion, airportType)
                            present = false
                            selection = nil
                        }
                    }
                    Divider()
                }
            }
            .padding()
        }
        .background(.regularMaterial)
        .cornerRadius(16)
        .popoverShadow(shadow: .system)
        .onTapGesture {
            withAnimation(.spring()) {
                selection = nil
            }
        }
    }
}
