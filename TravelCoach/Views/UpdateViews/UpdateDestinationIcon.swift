
import SwiftUI
import SwiftData

struct UpdateDestinationIcon: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var chatAPIViewModel: ChatAPIViewModel = ChatAPIViewModel()
    @StateObject var googlePlacesViewModel: GooglePlacesViewModel = GooglePlacesViewModel()
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible())]

    @Bindable var destination: Destination
    
    init(destination: Destination) {
        _destination = Bindable(wrappedValue: destination)
    }
    
    func loadPhotodByGooglePlacesId() {
        self.googlePlacesViewModel.fetchPlaceDetails(placeId: destination.googlePlaceId ?? "")
    }
    
    var body: some View {
        VStack {
            HStack {
                CityTitleBannerView(cityName: destination.name)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20, alignment: .leading)
            }
        }
        .padding()
        .background(
            DestinationIconDataView(iconData: destination.icon)
        )
        .cardStyle()
        
        ScrollView {
            VStack {
                Text(chatAPIViewModel.loadingMessage ?? "")
                    .foregroundColor(.red)
                    .font(.headline).bold()
                
                LazyVGrid(columns: columns) {
                    ForEach(self.googlePlacesViewModel.photosData, id: \.self) { place in
                        Button {
                            self.chatAPIViewModel.downloadImage(from: place)
                        } label: {
                            
                            RemoteIconCellView(with: place)
                        }
                    }
                }
            }
            .padding()
            .onAppear() {
                self.loadPhotodByGooglePlacesId()
            }
            .onChange(of: chatAPIViewModel.imageData) { oldData, newData in
                destination.icon = newData
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}
