
import SwiftUI
import Combine

struct AllEventsSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Bindable var destination: Destination
    @StateObject var mockServices: MockServices = MockServices()
    @StateObject var eventSelectionViewModel: EventSelectionViewModel = EventSelectionViewModel()
    @StateObject var chatAPIViewModel: ChatAPIViewModel = ChatAPIViewModel()

    init(destination: Destination) {
        _destination = Bindable(wrappedValue: destination)
    }
    
    func parseDateRange() -> String {
        let dateRange = "\(destination.startDate.formatted(date: .long, time: .omitted)) and \(destination.endDate.formatted(date: .long, time: .omitted))"
        return dateRange
    }
    
    var body: some View {
        VStack {
            VStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    
                    VStack {
                        CityTitleBannerView(cityName: destination.name)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
                
                Text("Events and Activities")
                    .foregroundColor(.wbPinkMedium)
                    .font(.custom("Satoshi-Bold", size: 25))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            
            Form {
                if chatAPIViewModel.loadingMessage != nil {
                    Text(chatAPIViewModel.loadingMessage ?? "")
                        .foregroundColor(.red)
                        .font(.headline).bold()
                } else {
                    ForEach(self.chatAPIViewModel.allEvents, id: \.self) { item in
                        AllEventItem(viewModel: eventSelectionViewModel, item: item)
                    }
                }
            }
        }
        .onAppear {
            self.chatAPIViewModel.getChatGPTContent(qType: .getAllEvents(city: destination.name, dateRange: parseDateRange()), isMock: false)
        }
        
    }
}

struct AllEventItem: View {
    @ObservedObject var viewModel: EventSelectionViewModel
    var item: EventCategory

    var body: some View {
        Section(header: HStack {
            Text(item.category)
                .font(.custom("Satoshi-Bold", size: 19))
                .foregroundColor(.gray3)
            Spacer()
            Button(action: {
                viewModel.toggleCategorySelection(item)
            }) {
                Image(systemName: viewModel.isCategorySelected(item) ? "checkmark.square" : "square")
                    .font(.largeTitle)
                    .foregroundColor(viewModel.isCategorySelected(item) ? Color.wbPinkMedium : .gray)
            }
        }) {
            ForEach(item.events, id: \.self) { event in
                Button(action: {
                    viewModel.toggleEventSelection(event)
                }) {
                    HStack {
                        
                        DestinationIconView(image: Image("dublin"), size: 60)
                        
                        Text(event)
                            .foregroundColor(viewModel.isEventSelected(event) ? .black : .black.opacity(0.6))
                            .fontWeight(viewModel.isEventSelected(event) ? .bold : .regular)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Image(systemName: viewModel.isEventSelected(event) ? "checkmark.square" : "square")
                            .font(.headline)
                            .foregroundColor(viewModel.isCategorySelected(item) ? Color.wbPinkMedium : .gray)
                    }
                }
            }
        }
    }
}

class EventSelectionViewModel: ObservableObject {
    //@Bindable var destination: Destination
    @Published var selectedEvents: Set<String> = []

//    init(destination: Destination) {
//        _destination = Bindable(wrappedValue: destination)
////        guard let events = destination.allEvents else { return }
////        selectedEvents = events
//    }
    
    // Assume `allEvents` is populated with your `AllEvents` data
    //var allEvents: AllEvents = AllEvents(categories: [])

    func isEventSelected(_ event: String) -> Bool {
        selectedEvents.contains(event)
    }

    func toggleEventSelection(_ event: String) {
        if selectedEvents.contains(event) {
            selectedEvents.remove(event)
        } else {
            selectedEvents.insert(event)
        }
    }

    func toggleCategorySelection(_ category: EventCategory) {
        let categoryEvents = Set(category.events)
        let selectedCategoryEvents = selectedEvents.intersection(categoryEvents)
        if selectedCategoryEvents.count == categoryEvents.count {
            // All events in category are selected, so unselect them
            selectedEvents.subtract(categoryEvents)
        } else {
            // Not all events are selected, so select all
            selectedEvents.formUnion(categoryEvents)
        }
    }

    func isCategorySelected(_ category: EventCategory) -> Bool {
        let categoryEvents = Set(category.events)
        return !categoryEvents.isDisjoint(with: selectedEvents)
    }
    
    func setAllEventsToDestination() {
        //self.destination.allEvents = self.selectedEvents
    }
}
