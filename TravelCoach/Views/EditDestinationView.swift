
import SwiftUI
import SwiftData
import LonginusSwiftUI
import Popovers

struct EditDestinationView: View {
    @StateObject var chatAPIViewModel: ChatAPIViewModel = ChatAPIViewModel()
    @StateObject var placesViewModel: PlacesViewModel = PlacesViewModel()
    @Bindable var destination: Destination
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var launchSearchView = false
    @State private var launchUpdateicon = false
    @State private var dateEntryLaunched = false
    @State private var launchAllEvents = false
    
    @State private var isAnimating = false
    @State var expanding = false

    init(destination: Destination) {
        _destination = Bindable(wrappedValue: destination)
        
        if destination.name == "" {
            destination.name = "New, Destination"
        }        
    }
    
    func setDateState() {
        self.dateEntryLaunched = isSameDay()
    }
    
    func isSameDay() -> Bool {
        if Calendar.current.isDate(self.startDate, inSameDayAs: self.endDate) {
            return true
        } else {
            return false
        }
    }
    
    var iconImage: Image {
        if let iconData = destination.icon, let uiImage = UIImage(data: iconData) {
            return Image(uiImage: uiImage)
        } else {
            return Image("destination_placeholder")
        }
    }
    
    func enableDateUpdate() -> Bool {
        if destination.startDate == destination.endDate {
            return false
        } else if self.startDate > self.endDate {
            return false
        } else {
            return true
        }
    }
    
    func handlePlaceImageChanged() {
        DispatchQueue.main.async { [self] in
            guard let icon = self.placesViewModel.places.randomElement()?.icon else { return }
            self.chatAPIViewModel.downloadImage(from: icon)
        }
    }
    
    func updateTrip() {
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
    
    var body: some View {
        VStack {
            
            VStack {
                HStack {
                    Image(destination.name.split(separator: ",").map(String.init).last?.replacingOccurrences(of: " ", with: "") ?? "")
                        .resizable()
                        .frame(width: 26, height: 18)
                    
                    Text(destination.name.split(separator: ",").map(String.init).first ?? "")
                        .font(.custom("Satoshi-Regular", size: 25))
                        .foregroundColor(Color.wbPinkShade) +
                    Text(destination.name.split(separator: ",").map(String.init).last ?? "")
                        .font(.custom("Satoshi-Bold", size: 25))
                        .foregroundColor(.white)
                }
                .padding(8)
                .cardStyle(.black.opacity(0.6))
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20, alignment: .leading)
            }
            .padding(.leading, 10)
        }
        .frame(height: dateEntryLaunched ? 200 : 80)
        .animation(.easeInOut(duration: 0.3), value: dateEntryLaunched)
        .background(
            Group {
                LoadingItineraryView(
                    chatAPIViewModel: chatAPIViewModel,
                    icon: destination.icon ?? Data()
                )
                //DestinationIconView(iconData: destination.icon)
                    .animation(.easeInOut(duration: 0.3), value: dateEntryLaunched)
            }
        )
        
        Spacer()
        
        if chatAPIViewModel.loadingMessage != nil {
            VStack {
                ImageAnimate()
                
                Text(chatAPIViewModel.loadingMessage ?? "Please Wait...")
                    .font(.custom("Bevellier-Regular", size: 20))
                    .foregroundColor(Color.wbPinkMedium)
                    .padding()
                    .opacity(isAnimating ? 0 : 1) // Bind opacity to the isAnimating state variable
                    .onAppear {
                        // Start the animation when the text appears
                        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                            isAnimating = true
                        }
                    }
            }
                
        } else {
        
            Form {
                ForEach(destination.itinerary.sorted(by: { $0.index < $1.index }), id: \.self) { day in
                    EventView(day: day, city: destination.name)
                }
                .opacity(self.dateEntryLaunched ? 0.3 : 1.0)
            }
        }
 
        VStack {
            VStack {
                if self.dateEntryLaunched == false {

                    Text("Dates Entered Here")
                        .font(.custom("Satoshi-Bold", size: 15))
                        .padding(7)
                        .background(.white)
                        .foregroundColor(.wbPinkMedium)
                        .cornerRadius(5)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, alignment: .center)
                    .onTapGesture {
                        self.dateEntryLaunched = true
                    }
                    .animation(.easeInOut(duration: 0.3), value: dateEntryLaunched)
                    
                } else {
                    
                    VStack {
                        Button(action: {
                            self.dateEntryLaunched = false
                        }) {
                            HStack {
                                Image(systemName: "chevron.down")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                            .padding(5)
                            .foregroundColor(.black)
                            .background(Color.gray10)
                            .cornerRadius(9)
                        
                        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                            .padding(5)
                            .foregroundColor(.black)
                            .background(Color.gray10)
                            .cornerRadius(9)
                        
                        HStack {
                            Button {
                                destination.startDate = startDate
                                destination.endDate = endDate
                                self.updateTrip()
                            } label: {
                                Text("UPDATE ITINERARY")
                                    .font(.custom("Satoshi-Bold", size: 15))
                                    .padding(7)
                                    .background(.white)
                                    .foregroundColor(self.enableDateUpdate() ? .wbPinkMedium : .gray)
                                    .cornerRadius(5)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, alignment: .center)
                            
                            Button {
                                self.launchAllEvents = true
                            } label: {
                                Text("PERSONALIZE")
                                    .font(.custom("Satoshi-Bold", size: 15))
                                    .padding(7)
                                    .background(.white)
                                    .foregroundColor(self.enableDateUpdate() ? .wbPinkMedium : .gray)
                                    .cornerRadius(5)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, alignment: .center)
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: dateEntryLaunched)
                    .padding()
                }
            }
            .background(Color.gray8.opacity(1))
            
        }
        .onAppear {
            if destination.icon == nil {
                self.placesViewModel.reloadIcon(destination: destination)
            }
            
            self.startDate = destination.startDate
            self.endDate = destination.endDate
            
            self.setDateState()
        }
        .onChange(of: destination.itinerary) { oldData, newData in
            self.placesViewModel.reloadIcon(destination: destination)
            self.setDateState()
        }
        .onChange(of: chatAPIViewModel.imageData) { oldData, newData in
            destination.icon = newData
        }
        .onChange(of: placesViewModel.places) { oldData, newData in
            self.handlePlaceImageChanged()
        }
        .onChange(of: chatAPIViewModel.itineraries) { oldValue, newValue in
            self.populateEvents(newValue)
        }
        .sheet(isPresented: $launchSearchView) {
            SearchDestinationView(destination: destination)
        }
        .sheet(isPresented: $launchUpdateicon) {
            UpdateDestinationIcon(destination: destination)
        }
        .sheet(isPresented: $launchAllEvents) {
            AllEventsSelectionView(destination: destination)
        }        
    }
}

struct AlertViewPopoverMe: View {
    @Binding var present: Bool
    @Binding var expanding: Bool

    /// the initial animation
    @State var scaled = true

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 6) {
                Text("Alert!")
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)

                Text("Popovers has used your location 2000 times in the past 7 days.")
                    .multilineTextAlignment(.center)
            }
            .padding()

            Divider()

            Button {
                present = false
            } label: {
                Text("Ok")
                    .foregroundColor(.blue)
            }
            //.buttonStyle(Templates.AlertButtonStyle())
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .popoverShadow(shadow: .system)
        .frame(width: 260)
        .scaleEffect(expanding ? 1.05 : 1)
        .scaleEffect(scaled ? 2 : 1)
        .opacity(scaled ? 0 : 1)
        .onAppear {
            withAnimation(.spring(
                response: 0.4,
                dampingFraction: 0.9,
                blendDuration: 1
            )) {
                scaled = false
            }
        }
    }
}

struct ImageAnimate: View {
    @State private var itemPositions: [CGPoint] = [CGPoint(x: 100, y: 600), CGPoint(x: 200, y: 600), CGPoint(x: 300, y: 600)]
    @State private var luggageOffset: CGFloat = 0

    var body: some View {
        ZStack {
            Image("icon_luggage_alt")
                .resizable()
                .frame(width: 120, height: 120)
                .offset(y: luggageOffset)

            // Items to throw in the luggage
            ForEach(0..<itemPositions.count, id: \.self) { index in
                Image(systemName: "iphone") // Replace this with your item view
                    .frame(width: 50, height: 50)
                    .position(itemPositions[index])
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 1)) {
                            itemPositions[index] = CGPoint(x: 150, y: 400) // Adjust final position based on luggage location
                        }
                    }
            }
        }
        .onAppear {
            // Animate luggage appearance
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                luggageOffset = 20 // Slight move to indicate where to throw items
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Destination.self, configurations: config)
        let example = Destination(name: "Example Destination", details: "Example details go here and will automatically expand vertically as they are edited.")
        return EditDestinationView(destination: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
