
import SwiftUI
import SwiftData

struct SearchDestinationView: View {
    @StateObject var chatAPIViewModel: ChatAPIViewModel = ChatAPIViewModel()
    @StateObject private var viewModel = GooglePlacesViewModel()
    @StateObject var placesViewModel: PlacesViewModel = PlacesViewModel()

    @Bindable var destination: Destination
    @State private var searchCity = ""
    
    init(destination: Destination) {
        _destination = Bindable(wrappedValue: destination)
    }
    
    func reloadIcon() {
        self.placesViewModel.searchLocation(with: destination.name.searchSanitized() + "+photos")
    }
    
    func handlePlaceImageChanged() {
        DispatchQueue.main.async { [self] in
            guard let icon = self.placesViewModel.places.randomElement()?.icon else { return }
            self.chatAPIViewModel.downloadImage(from: icon)
        }
    }
    
    var body: some View {
        //ScrollView {
        LoadingView(message: .constant(self.chatAPIViewModel.loadingMessage)) {
            VStack {
                                
                Button {
                    self.updateTrip()
                } label: {
                    Text("UPDATE")
                        .padding(6)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                        .cardStyle(.teal)
                        .accessibilityLabel("Update")
                }
                
                Text(chatAPIViewModel.loadingMessage ?? "")
                    .foregroundColor(.red)
                    .font(.headline).bold()
   
                VStack {
                    DatePicker("Start Date", selection: $destination.startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $destination.endDate, displayedComponents: .date)
                }
            }
            .onChange(of: chatAPIViewModel.itineraries) { oldValue, newValue in
                self.populateEvents(newValue)
            }
            .onChange(of: chatAPIViewModel.imageData) { oldData, newData in
                destination.icon = newData
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
    
    private func clearText() {
        searchCity = ""
        viewModel.resetSearch()
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func updateTrip() {
        self.reloadIcon()
        self.chatAPIViewModel.getChatGPTContent(qType: .getDailyPlan(city: destination.name, dateRange: parseDateRange()), isMock: false)
    }
    
    func parseDateRange() -> String {
        let dateRange = "\(destination.startDate.formatted(date: .long, time: .omitted)) and \(destination.endDate.formatted(date: .long, time: .omitted))"
        return dateRange
    }
    
    // Assign itinerary details from API to SWIFTData Persistent Cache
    func populateEvents(_ itineries: [DayItinerary]) {
        destination.itinerary = []
        for item in itineries {
            var events = [EventItem]()
            for event in item.activities {
                events.append(EventItem(
                    index: event.index,
                    title: event.title,
                    categories: event.categories
                ))
            }
            
            destination.itinerary.append(
                Itinerary(
                    index: item.index,
                    title: item.title,
                    date: item.date,
                    activities: events
                ))
        }
    }
}
