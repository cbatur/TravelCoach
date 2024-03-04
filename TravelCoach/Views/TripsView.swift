
import SwiftUI
import SwiftData

struct MainTabbedView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    
    var body: some View {
        ZStack{
            
            TabView(selection: $selectedSideMenuTab) {
                TripsView(presentSideMenu: $presentSideMenu)
                    .tag(0)
                AccountView(presentSideMenu: $presentSideMenu)
                    .tag(1)
                AccountView(presentSideMenu: $presentSideMenu)
                    .tag(2)
                AccountView(presentSideMenu: $presentSideMenu)
                    .tag(3)
            }
            
            SideMenu(
                isShowing: $presentSideMenu,
                content: AnyView(
                    SideMenuView(
                        selectedSideMenuTab: $selectedSideMenuTab,
                        presentSideMenu: $presentSideMenu
                    )
                )
            )
        }
    }
}

struct TripsView: View {
    @Binding var presentSideMenu: Bool
    
    @Environment(\.modelContext) var modelContext
    @State private var path = [Destination]()
    @State private var sortOrder = SortDescriptor(\Destination.startDate)
    @State private var launchNewDestination = false
    @State private var dataFromChild: (String?, String?)
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                DestinationListingView(sort: sortOrder, searchString: "")
                    .isHidden(self.path.count > 0)
                
                AddDestinationButton()
                    .onTapGesture {
                        self.launchNewDestination = true
                    }
            }
            .navigationTitle("My Trips".uppercased())
            .navigationDestination(for: Destination.self, destination: TripDetailsView.init)
            .sheet(isPresented: $launchNewDestination) {
                AddNewDestinationView { data in
                    self.dataFromChild = data                    
                }
            }
            .onChange(of: self.dataFromChild.0) { oldData, newData in
                guard let city = self.dataFromChild.0, let googlePlaceId = self.dataFromChild.1 else { return }
                self.addDestination(name: city, googlePlaceId: googlePlaceId)
            }
            .navigationBarItems(leading:
                Button{
                    presentSideMenu.toggle()
                } label: {
                    Image("menu")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
            )
        }
    }
    
    func addDestination(name: String, googlePlaceId: String) {
        let destination = Destination(name: name)
        destination.googlePlaceId = googlePlaceId
        destination.startDate = Date.daysFromToday(1)
        destination.endDate = Date.daysFromToday(1)
        modelContext.insert(destination)
        //path = [destination]
    }
}
