
import SwiftUI

struct ReservationsView: View {
    var travelData: TravelSection = TravelSection(title: "", items: [])
    
    init(_ travelData: TravelSection) {
        self.travelData = travelData
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text(travelData.title)) {
                        ForEach(travelData.items) { item in
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
