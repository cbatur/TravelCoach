
import SwiftUI
import LonginusSwiftUI
import Popovers

struct DailyPlanView: View {
    @StateObject var chatAPIViewModel: ChatAPIViewModel = ChatAPIViewModel()
    var city: String = "Dublin, Ireland"
    var isMock: Bool = false
    @State private var proceedToReservations = false
    
    var body: some View {
        LoadingView(message: .constant(self.chatAPIViewModel.loadingMessage)) {
        
            ScrollView {
                VStack {
                    HStack {
                        VStack {
                            Text("7-Day \(self.city.split(separator: ",").map(String.init).first ?? "Itinerary")".uppercased())
                                .font(.system(size: 22)).bold()
                                .foregroundColor(Color.pink)
                            
                            Text("May 10 - May 16, 2024")
                                .font(.system(size: 14))
                                .foregroundColor(.black.opacity(0.6))
                        }
                        Spacer()
                        Text("Edit")
                            .foregroundColor(.accentColor)
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        LGImage(source: URL(string: "\(self.chatAPIViewModel.backgroundLocationImageUrl ?? "")"), placeholder: {
                            Image("patterns")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .edgesIgnoringSafeArea(.all)
                        })
                        .onProgress(progress: { (data, expectedSize, _) in })
                        .onCompletion(completion: { (image, data, error, cacheType) in })
                        .cancelOnDisappear(true)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: self.chatAPIViewModel.backgroundLocationImageUrl == nil ? 0 : 200)
                        .background(Color.gray)
                    }
                    .cardStyle()
                    
                    Button {
                        proceedToReservations = true
                    } label: {
                        ReservationsCardView()
                    }
                }
                .padding()
            }
            .navigationDestination(isPresented: $proceedToReservations) {
                //ReservationsView()
            }
            .onAppear {
                self.chatAPIViewModel.getChatGPTContent(qType: .getDailyPlan(city: self.city, dateRange: "May 10 - May 16, 2024"), isMock: isMock)
            }
        }
    }
}

struct ItineraryFormDayView: View {
    let day: DayItinerary
    let city: String
    @State var venueName: IdentifiableString?
    @State var launchVenueDetail: Bool = false

    func isLink(_ activity: Activity) -> Bool {
        if activity.categories.contains("checkin") || activity.categories.contains("checkout") {
            return false
        } else {
            return true
        }
    }
    
    var body: some View {
        Section("\(day.title) .\(day.index)") {
            ForEach(day.activities, id: \.self) { activity in
                Button {
                    self.venueName = IdentifiableString(value: "\(activity.title), \(self.city)")
                    DispatchQueue.main.async {
                        self.launchVenueDetail = self.venueName != nil
                    }
                } label: {
                    HStack(alignment: .center) {
                        Image(systemName: activity.categories.count > 0 ?
                              Icon(rawValue: activity.categories.first ?? "dot.square")?.system ?? "dot.square" :
                        "dot.square")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(alignment: .center)
                        
                        Button {
                            self.venueName = IdentifiableString(value: "\(activity.title), \(self.city)")
                            DispatchQueue.main.async {
                                self.launchVenueDetail = self.venueName != nil
                            }
                        } label: {
                            Text("\(activity.title) .\(activity.index)")
                                .foregroundColor(.black.opacity(0.6))
                                .fontWeight(isLink(activity) ? .bold : .regular)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
            }
        }
        .sheet(item: $venueName) { item in
            VenueDetailsView(item.value)
        }
    }
}

struct ItineraryDayView: View {
    let day: DayItinerary
    let city: String
    @State var venueName: IdentifiableString?
    @State var launchVenueDetail: Bool = false

    func isLink(_ activity: Activity) -> Bool {
        if activity.categories.contains("checkin") || activity.categories.contains("checkout") {
            return false
        } else {
            return true
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(day.title.uppercased())
                .foregroundColor(.accentColor).bold()
                .font(.headline)
                .padding(.bottom, 5)
            Divider()
            ForEach(day.activities, id: \.self) { activity in
                HStack(alignment: .center) {
                    Image(systemName: activity.categories.count > 0 ?
                          Icon(rawValue: activity.categories.first ?? "dot.square")?.system ?? "dot.square" :
                    "dot.square")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .frame(alignment: .center)
                    
                    Button {
                        self.venueName = IdentifiableString(value: "\(activity.title), \(self.city)")
                        DispatchQueue.main.async {
                            self.launchVenueDetail = self.venueName != nil
                        }
                    } label: {
                        Text("\(activity.title)")
                            .foregroundColor(.black.opacity(0.6))
                            .fontWeight(isLink(activity) ? .bold : .regular)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding(6)
            }
        }
        .sheet(item: $venueName) { item in
            VenueDetailsView(item.value)
        }
    }
}

struct IdentifiableString: Identifiable {
    let id: UUID = UUID()
    var value: String
}

struct ReservationsCardView: View {
    var body: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "airplane")
                        .font(.system(size: 15))
                        .foregroundColor(Color.accentColor.opacity(0.7))

                    Text("Reservations".uppercased())
                        .font(.system(size: 20)).bold()
                        .foregroundColor(Color.accentColor.opacity(0.7))
                }
                
                Text("Hotels and Accommodation")
                    .font(.system(size: 14))
                    .foregroundColor(.black.opacity(0.6))
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 24))
                .foregroundColor(.gray.opacity(0.4))
        }
        .padding()
    }
}

#Preview {
    DailyPlanView()
}

