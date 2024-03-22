
import SwiftUI

struct AirportCard: View {
    var airport: AEAirport.AECity
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    VStack {
                        Image(airport.nameCountry)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 26, height: 26)
                            .frame(alignment: .top)
                            .clipShape(Circle())
                        
                        Spacer()
                    }
                    VStack {
                        Text(airport.nameAirport)
                            .font(.custom("Gilroy-Medium", size: 17))
                            .foregroundColor(Color.black)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20, alignment: .leading)
                        
                        HStack {
                            Text("\(airport.nameCountry)")
                                .font(.custom("Gilroy-Bold", size: 17))
                                .foregroundColor(Color.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20, alignment: .leading)
                            
                            Text("\(airport.timezone)")
                                .font(.custom("Gilroy-Regular", size: 16))
                                .foregroundColor(Color.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20, alignment: .leading)
                        }
                    }
                }
            }
            
            Text(airport.codeIataAirport)
                .font(.custom("Gilroy-Bold", size: 20))
                .foregroundColor(Color.wbPinkMediumAlt)
        }
        .padding()
        .cardStyle(.white)
    }
}

struct AirportCardBasic: View {
    var airport: AEAirport.AECity
    
    var body: some View {
        VStack {
            HStack {
                Image(airport.nameCountry)
                    .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 23, height: 23)
                        .frame(alignment: .top)
                        .clipShape(Circle())
                
                Text(airport.codeIataAirport)
                    .font(.custom("Gilroy-Bold", size: 19))
                    .foregroundColor(Color.wbPinkMediumAlt)
            }
            
            Text("\(airport.timezone.split(separator: Character("/")).map(String.init).last ?? airport.codeIataAirport)-")
                .font(.custom("Gilroy-Medium", size: 17))
                .foregroundColor(Color.gray) +
            
            Text("\(airport.nameCountry)")
                .font(.custom("Gilroy-Bold", size: 17))
                .foregroundColor(Color.gray)
            
        }
        .padding()
        .cardStyle(.white)
        //.frame(maxWidth: .infinity)
    }
}
