
import SwiftUI
import SwiftData

struct UpdateDestinationIcon: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var chatAPIViewModel: ChatAPIViewModel = ChatAPIViewModel()
    @StateObject var placesViewModel: PlacesViewModel = PlacesViewModel()
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible())]

    @Bindable var destination: Destination
    let iconCategories = ["City", "History", "Art", "Streets", "Skyline", "Photo"]
    @State private var selection: String = "Streets"
    
    init(destination: Destination) {
        _destination = Bindable(wrappedValue: destination)
    }
    
    func loadIcons() {
        self.placesViewModel.searchLocation(with: destination.name.searchSanitized() + "+" + self.selection)
    }
    
    var body: some View {
        
        VStack {
            HStack {
                HStack {
                    Image(destination.name.split(separator: ",").map(String.init).last?.replacingOccurrences(of: " ", with: "") ?? "")
                        .resizable()
                        .frame(width: 26, height: 18)
                    
                    Text(destination.name.split(separator: ",").map(String.init).first ?? "")
                        .font(.custom("Satoshi-Regular", size: 25))
                        .foregroundColor(.white) +
                    Text(destination.name.split(separator: ",").map(String.init).last ?? "")
                        .font(.custom("Satoshi-Bold", size: 25))
                        .foregroundColor(.white)
                }
                .padding(8)
                .cardStyle(.black.opacity(0.6))
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20, alignment: .leading)
            }
            
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(iconCategories, id: \.self) { option in
                            Text(option.uppercased())
                                .font(.custom("Satoshi-Bold", size: 13))
                                .padding(7)
                                .background(
                                    self.selection.uppercased() == option.uppercased() ? Color.wbPinkMedium : Color.clear
                                )
                                .foregroundColor(
                                    self.selection.uppercased() == option.uppercased() ? Color.white : Color.black
                                )
                                .cornerRadius(5)
                                .onTapGesture {
                                    self.selection = option
                                    self.loadIcons()
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(7)
            .cardStyle(.white.opacity(0.7))
        }
        .padding()
        .background(
            DestinationIconView(iconData: destination.icon)
        )
        .cardStyle()
        
        ScrollView {
            VStack {
                Text(chatAPIViewModel.loadingMessage ?? "")
                    .foregroundColor(.red)
                    .font(.headline).bold()
                
                LazyVGrid(columns: columns) {
                    ForEach(self.placesViewModel.places) { place in
                        Button {
                            self.chatAPIViewModel.downloadImage(from: place.icon)
                        } label: {
                            RemoteIconCellView(with: place.icon)
                        }
                    }
                }
   
            }
            .padding()
            .onAppear() {
                self.loadIcons()
            }
            .onChange(of: chatAPIViewModel.imageData) { oldData, newData in
                destination.icon = newData
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}
