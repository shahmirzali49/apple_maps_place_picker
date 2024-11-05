
import SwiftUI
import MapKit
import Combine

// MARK: - View
struct PlacePickerIos15View: View {
    @StateObject private var viewModel: PlacePickerIos15ViewModel
    @State private var isPresented = false
    @FocusState private var isFocused: Bool
    
    private let searchBarConfig: SearchBarConfig
    private let addressViewConfig: AddressViewConfig
    private let centerMarkerConfig: CenterMarkerConfig
    private let searchResultConfig: SearchResultConfig
    private let onPlaceSelected: (Place) -> Void
    private let showAddressView: Bool
    private let showDefaultCenterMarker: Bool
    private let onSearchStateChanged: (Bool) -> Void
 
    init(initialLocation: CLLocationCoordinate2D, config: [String: Any]?, 
         onPlaceSelected: @escaping (Place) -> Void,
         onLocationUpdated: @escaping (Place) -> Void,
         onSearchStateChanged: @escaping (Bool) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: PlacePickerIos15ViewModel(initialLocation: initialLocation, onLocationUpdated: onLocationUpdated))
        
        let configDict = config ?? [:]
        self.searchBarConfig = SearchBarConfig(from: configDict["searchBarConfig"] as? [String: Any])
        self.addressViewConfig = AddressViewConfig(from: configDict["addressViewConfig"] as? [String: Any])
        self.centerMarkerConfig = CenterMarkerConfig(from: configDict["centerMarkerConfig"] as? [String: Any])
        self.searchResultConfig = SearchResultConfig(from: configDict["searchResultConfig"] as? [String: Any])
        self.showAddressView = configDict["showAddressView"] as? Bool ?? true
        self.showDefaultCenterMarker = configDict["showDefaultCenterMarker"] as? Bool ?? true
        self.onPlaceSelected = onPlaceSelected
        self.onSearchStateChanged = onSearchStateChanged
     }
    
    var body: some View {
        VStack(spacing: 0) {

            CustomSearchBar(
                text: $viewModel.searchText,
                isPresented: $isPresented, 
                shouldPerformSearch: $viewModel.shouldPerformSearch,
                isFocused: $isFocused,
                config: searchBarConfig
            ).onChange(of: isPresented) { newValue in
//                print("onChange isPresent \(newValue)")
                onSearchStateChanged(newValue)
            }
           
            ZStack {
                MapViewRepresentable(
                    region: viewModel.region,
                    onRegionChange: viewModel.updateRegion
                )
                
                if showDefaultCenterMarker && viewModel.searchText.isEmpty {
                    VStack(spacing: 0) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: centerMarkerConfig.markerSize))
                            .foregroundColor(centerMarkerConfig.markerColor)
                        
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.caption)
                            .foregroundColor(centerMarkerConfig.markerColor)
                            .offset(x: 0, y: -5)
                    }
                    .padding(.bottom, 150)
                }
                
                
                if isPresented {
                    SearchResultsView(
                        onSelect: { place in
                            viewModel.selectPlace(place)
                            withAnimation {
                                $isFocused.wrappedValue = false
                                isPresented = false
                            }
                        },
                        searchState: viewModel.searchState,
                        config: searchResultConfig
                    )
                    .opacity(isPresented ? 1 : 0)
                    .transition(.opacity)
                }
                
                if showAddressView && viewModel.searchText.isEmpty && !isPresented {
                    VStack {
                        Spacer()
                        AddressView(
                            place: viewModel.currentPlace,
                            config: addressViewConfig,
                            onConfirm: onPlaceSelected
                        )
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .ignoresSafeArea(.keyboard)
    }
    
}
