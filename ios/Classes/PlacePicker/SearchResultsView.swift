import SwiftUI

struct SearchResultsView: View {
    let onSelect: (Place) -> Void
    let searchState: SearchState
    let config: SearchResultConfig
    
    var body: some View {
        VStack(spacing: 0) {
            switch searchState {
            case .initial:
                noResultsMessage("")
                
            case .searching:
                noResultsMessage("Searching...")
                
            case .found(let places):
                if #available(iOS 17.0, *) {
                    List {
                        ForEach(places) {item in
                            searchResultItem(item)
                                .padding(config.itemPadding)
                                .listRowInsets(config.itemMargin)
                                .listRowSeparator(.hidden, edges: .all)
                                .background(
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .fill(config.itemBackgroundColor)
                                                    
                                            )
                                .listRowBackground(Color.clear)
                        }
                        
                    }
                    .contentMargins(.top, 16)
                    .listStyle(.plain)

                    
                } else {
                    List {
                        ForEach(places) {item in
                            searchResultItem(item)
                                .padding(config.itemPadding)
                                .listRowInsets(config.itemMargin)
                                .listRowSeparator(.hidden, edges: .all)
                                .background(
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .fill(config.itemBackgroundColor)
                                                    
                                            )
                                .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)
                }
                
            case .notFound:
                noResultsMessage("The place you're searching for was not found.")
            }
        }
//        .keyboardAwarePadding()
        .background(config.backgroundColor)
    }
    
    private func searchResultItem(_ place: Place) -> some View {
        Button {
             onSelect(place)
        } label: {
            Text(place.name)
                .font(.system(size: config.itemTextStyle.fontSize,
                            weight: config.itemTextStyle.fontWeight))
                .foregroundColor(config.itemTextStyle.foregroundColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                
        }
            
     }
    
    
        
    private func noResultsMessage(_ message: String) -> some View {
        VStack {
            Text(message)
                .font(.system(size: config.itemTextStyle.fontSize,
                              weight: config.itemTextStyle.fontWeight))
                .foregroundColor(config.itemTextStyle.foregroundColor)
                .padding()
                .padding(.top, 120)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }

    

//    private func noResultsMessage(_ message: String) -> some View {
//        Text(message)
//            .font(.system(size: config.itemTextStyle.fontSize,
//                         weight: config.itemTextStyle.fontWeight))
//            .foregroundColor(.gray)
//            .padding()
//            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//            
//    }
}




