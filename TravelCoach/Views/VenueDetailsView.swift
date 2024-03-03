
import SwiftUI
import LonginusSwiftUI

struct VenueDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var chatAPIViewModel: ChatAPIViewModel = ChatAPIViewModel()
    @StateObject var placesViewModel: PlacesViewModel = PlacesViewModel()
    var keyword: String = ""
    
    init(_ keyword: String) {
        self.keyword = keyword
    }
    
    var body: some View {
        ScrollView {
            
            VStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    
                    VStack {
                        
                        Text(self.chatAPIViewModel.venueInfo?.venueName ?? "")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.bold)
                        
                        Text(self.placesViewModel.places.first?.formatted_address ?? "")
                            .foregroundColor(.gray.opacity(0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.caption)
                            .isHidden(self.chatAPIViewModel.venueInfo?.venueDescription == nil)
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
            }
            .padding()
            
            VStack {
                
                Text(self.chatAPIViewModel.venueInfo?.venueDescription ?? "")
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.leading)
                    .padding()
                
                TabView {
                    ForEach(self.placesViewModel.places) { place in
                        VStack {
//                            VStack(alignment: .leading) {
//                                Text(place.name.uppercased())
//                                    .font(.system(size: 17)).bold()
//                                    .foregroundColor(Color.teal)
//                                
//                                Text(place.formatted_address)
//                                    .font(.system(size: 14))
//                                    .foregroundColor(.black.opacity(0.6))
//                            }
//                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            LGImage(source: URL(string: "\(place.icon)")) {
                                Image(systemName: "photo.artframe")
                                    .resizable()
                                    .scaledToFit()
                                    .background(Color.gray)
                                    .cardStyleBordered()
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                            .background(Color.gray)
                            .cornerRadius(8)
                            
                        }
                        .cornerRadius(12)
                        .padding()
                        //.tag(index) // Ensure each page can be uniquely identified
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 210)
                .frame(maxWidth: .infinity)
                
                Button(action: {
                    print("Custom icon button tapped")
                }) {
                    HStack {
                        Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.teal)
                        
                        Text("Move this event to another day")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cardStyleBordered()
                }
                
                Button(action: {
                    print("Custom icon button tapped")
                }) {
                    HStack {
                        Image(systemName: "pencil.slash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                        
                        Text("Remove this event from my trip")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cardStyleBordered()
                }
                                    
            }
            .padding()
            
        }
        .onAppear {
            self.chatAPIViewModel.getChatGPTContent(qType: .getVenueDetails(location: self.keyword))
            self.placesViewModel.searchLocation(with: self.keyword.searchSanitized())
        }
    }
}

#Preview {
    VenueDetailsView("Hagia Sophia, Istanbul, Turkey")
}
