
import SwiftUI

struct _TabOverviewView: View {
    @Bindable var destination: Destination
    @StateObject var placesViewModel: PlacesViewModel = PlacesViewModel()
    @StateObject var chatAPIViewModel: ChatAPIViewModel = ChatAPIViewModel()

    init(destination: Destination) {
        _destination = Bindable(wrappedValue: destination)
    }
    
//    func isSameDay() -> Bool {
//        if Calendar.current.isDate(self.startDate, inSameDayAs: self.endDate) {
//            return true
//        } else {
//            return false
//        }
//    }
    
    func handlePlaceImageChanged() {
        DispatchQueue.main.async { [self] in
            guard let icon = self.placesViewModel.places.randomElement()?.icon else { return }
            self.chatAPIViewModel.downloadImage(from: icon)
        }
    }
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    func enableDateUpdate() -> Bool {
        if destination.startDate == destination.endDate {
            return false
        } else if self.startDate > self.endDate {
            return false
        } else {
            return true
        }
    }
    
    func changeDatesAndReset() {
        destination.startDate = startDate
        destination.endDate = endDate
        
        destination.itinerary = []
    }
    
    var body: some View {
        VStack {
            VStack {
                Button(action: {
                    //self.dateEntryLaunched = false
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
                
                Button {
                    self.changeDatesAndReset()
                } label: {
                    Text("UPDATE DATES")
                        .font(.custom("Satoshi-Bold", size: 15))
                        .padding(7)
                        .background(.white)
                        .foregroundColor(.wbPinkMedium)
                        .cornerRadius(5)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, alignment: .center)
    
            }
            .padding()

        }
        .onChange(of: placesViewModel.places) { oldData, newData in
            self.handlePlaceImageChanged()
        }
        .onAppear {
            if destination.icon == nil {
                self.placesViewModel.reloadIcon(destination: destination)
            }
            
            self.startDate = destination.startDate
            self.endDate = destination.endDate
            
            //self.setDateState()
        }
    }
}
