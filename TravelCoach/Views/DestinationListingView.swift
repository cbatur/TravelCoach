
import SwiftUI
import SwiftData

struct DestinationCollectionView: View {
    
    var destinations: [Destination] = []
    var tripGroup: TripGroup = .activeTrips
    var deleteDestination: (Destination) -> Void
    
    var body: some View {
        if destinations.count > 0 {
            
            Text(tripGroup.title)
                .font(.custom("Gilroy-Bold", size: 26))
                .foregroundColor(tripGroup.foreColor)
                .padding(.top, 7)
            
            ForEach(destinations) { destination in
                NavigationLink(value: destination) {
                    HStack {
                        DestinationIconDataView(iconData: destination.icon, size: 80)
                        VStack(alignment: .leading) {
                            if destination.itinerary.count == 0 {
                                Text("INCOMPLETE")
                                    .font(.caption)
                                    .padding(4)
                                    .padding(.leading, 5)
                                    .padding(.trailing, 5)
                                    .background(.orange)
                                    .foregroundColor(.white)
                                    .font(.custom("Bevellier-Bold", size: 20))
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.gray.opacity(0.6), lineWidth: 0.5)
                                    )
                            }
                            
                            Text(destination.name)
                                .font(.custom("Gilroy-Medium", size: 18))
                                .foregroundColor(tripGroup.headerColor)
                            
                            Text("\(destination.startDate.formatted(date: .abbreviated, time: .omitted)) - \(destination.endDate.formatted(date: .abbreviated, time: .omitted))")
                                .font(.custom("Gilroy-Regular", size: 15))
                        }
                    }
                }
            }
            .onDelete(perform: deleteDestinations)
        }
    }
    
    func deleteDestinations(_ indexSet: IndexSet) {
        for index in indexSet {
            let destination = destinations[index]
            deleteDestination(destination)
        }
    }
}

struct DestinationListingView: View {
    let groups: [TripGroup] = [.activeTrips, .upcomingTrips, .pastTrips]
    
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Destination.priority, order: .reverse), SortDescriptor(\Destination.name)]) var destinations: [Destination]
    
    var body: some View {
        
        if destinations.count == 0 {
            VStack {
                Image("icon_luggage_alt")
                    .resizable()
                    .scaledToFit()
                
                Text("...and let's get you to places")
                    .font(.custom("Boska-Regular", size: 26))
                    .foregroundColor(.black)
                    .lineLimit(nil)
            }
        }
        
        if destinations.count > 0 {
            List {
                ForEach(groups, id: \.self) { trip in
                    DestinationCollectionView(destinations: filterDestinations(with: destinations, tripGroup: trip), tripGroup: trip, deleteDestination: { destination in
                        deleteSelectedDestination(destination)
                    })
                }
            }
        }
    }
    
    init(sort: SortDescriptor<Destination>, searchString: String) {
        //let now = Date.now
        _destinations = Query(filter: #Predicate {
            if searchString.isEmpty {
                return true
            } else {
                return $0.name.localizedStandardContains(searchString)
                //$0.date > now
            }
            
        }, sort: [sort])
    }
    
    func deleteSelectedDestination(_ destination: Destination) {
        modelContext.delete(destination)
    }
}

#Preview {
    DestinationListingView(sort: SortDescriptor(\Destination.startDate), searchString: "")
}

func filterDestinations(
    with destinations:[Destination],
    tripGroup: TripGroup
) -> [Destination] {
    
    let active = destinations.filter { $0.startDate <= Date() && $0.endDate >= Date() }
    let upcoming = destinations.filter { $0.startDate > Date() }
    let past = destinations.filter { $0.endDate < Date() }

    switch tripGroup {
    case .activeTrips:
        return Array(active)
    case .upcomingTrips:
        return Array(upcoming)
    case .pastTrips:
        return Array(past)
    }
}
