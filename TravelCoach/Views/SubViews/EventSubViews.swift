
import SwiftUI

struct EventView: View {
    let day: Itinerary
    let city: String
    @State var venueName: IdentifiableString?
    @State var launchVenueDetail: Bool = false

    func isLink(_ activity: EventItem) -> Bool {
        if activity.categories.contains("checkin") || activity.categories.contains("checkout") {
            return false
        } else {
            return true
        }
    }
    
    var body: some View {
        Section("\(day.title) - \(day.date)") {
            ForEach(day.activities.sorted(by: { $0.index < $1.index }), id: \.self) { activity in
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
                            Text("\(activity.title)")
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
