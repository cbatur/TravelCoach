
import SwiftUI

struct _TabItineraryView: View {
    @Bindable var destination: Destination
    @StateObject var chatAPIViewModel: ChatAPIViewModel = ChatAPIViewModel()

    @State private var dateEntryLaunched = true
    @State private var launchAllEvents = false
    @State private var isAnimating = false
    
    init(destination: Destination) {
        _destination = Bindable(wrappedValue: destination)
    }
    
    var body: some View {
        
        VStack {
            if chatAPIViewModel.loadingMessage != nil {
                VStack {
                    ImageAnimate()

                    Text(chatAPIViewModel.loadingMessage ?? "Please Wait...")
                        .font(.custom("Bevellier-Regular", size: 20))
                        .foregroundColor(Color.wbPinkMedium)
                        .padding()
                        .opacity(isAnimating ? 0 : 1)
                        .onAppear {
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
                }
                .isHidden(destination.itinerary.count == 0)
                .cardStyle(.clear)
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
   
                           HStack {
                               Button {
//                                   destination.startDate = startDate
//                                   destination.endDate = endDate
                                   self.updateTrip()
                               } label: {
                                   Text("UPDATE ITINERARY")
                                       .font(.custom("Satoshi-Bold", size: 15))
                                       .padding(7)
                                       .background(.white)
                                       .foregroundColor(.wbPinkMedium)
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
                                       .foregroundColor(.wbPinkMedium)
                                       .cornerRadius(5)
                               }
                               .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, alignment: .center)
                           }
                       }
                       .animation(.easeInOut(duration: 0.3), value: dateEntryLaunched)
                       .padding()
                   }
               }
               .padding()
               .cardStyle(.black.opacity(0.5))
               
           }
        }
        .onChange(of: chatAPIViewModel.itineraries) { oldValue, newValue in
            self.populateEvents(newValue)
        }
        .sheet(isPresented: $launchAllEvents) {
            AllEventsSelectionView(destination: destination)
        }   
        
    }
}

extension _TabItineraryView {
    
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
}
