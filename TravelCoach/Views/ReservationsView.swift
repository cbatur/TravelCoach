
import SwiftUI

struct ReservationsView: View {
    var travelData: [TravelSection] = []
    @State var hideEmptyScreen: Bool = true
    
    init(_ travelData: [TravelSection]) {
        self.travelData = travelData
        hideEmptyScreen = travelData.count == 0
    }
    
    var body: some View {
        NavigationView {
            VStack {

                Image("no-flights-found-b")
                    .resizable()
                    .scaledToFit()
                    .background(Color.white)
                
                List {
                    ForEach(travelData) { section in
                        Section(header: Text(section.title)) {
                            ForEach(section.items) { item in
                                HStack {
                                    VStack {
                                        Text(item.scheduledTime)
                                            .fontWeight(.semibold)
                                    }
                                    Image(systemName: item.iconName)
                                    VStack(alignment: .leading) {
                                        Text(item.title.uppercased())
                                            .fontWeight(.semibold)
                                        Text(item.subtitle)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct TravelSection: Identifiable {
    let id: UUID = UUID()
    let title: String
    let items: [TravelItem]
}

struct TravelItem: Identifiable {
    let id: UUID = UUID()
    let iconName: String
    let title: String
    let subtitle: String
    let scheduledTime: String
}
