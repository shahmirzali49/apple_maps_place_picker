# Apple Maps Place Picker

[![pub package](https://img.shields.io/pub/v/apple_maps_place_picker.svg)](https://pub.dev/packages/apple_maps_place_picker)
[![likes](https://img.shields.io/pub/likes/apple_maps_place_picker?logo=dart)](https://pub.dev/packages/apple_maps_place_picker/score)
[![popularity](https://img.shields.io/pub/popularity/apple_maps_place_picker?logo=dart)](https://pub.dev/packages/apple_maps_place_picker/score)
[![Flutter Platform](https://img.shields.io/badge/platform-ios-blue.svg)](https://pub.dev/packages/apple_maps_place_picker)

A Flutter plugin that provides a customizable place picker using Apple Maps. This plugin allows users to search for and select locations using Apple's native MapKit framework.

**Note:** This plugin is iOS-only as it uses Apple Maps.

All features provided by the plugin, including place search and geocode location , are completely free to use without requiring any additional API keys or incurring extra costs. Unlike Google Maps, where features like place search are paid, Apple offers these functionalities at no charge, making it a cost-effective solution for iOS apps. For more information, refer to the [official Apple Developer Forum discussion](https://forums.developer.apple.com/forums/thread/127493). 


## Screenshots

### Light & Dark & Preview

| <img src="https://raw.githubusercontent.com/shahmirzali49/apple_maps_place_picker/refs/heads/main/assets/light_theme.png" alt="light" width="210"> | <img src="https://raw.githubusercontent.com/shahmirzali49/apple_maps_place_picker/refs/heads/main/assets/dark_theme.png" alt="dark" width="210"> | <img src="https://raw.githubusercontent.com/shahmirzali49/apple_maps_place_picker/refs/heads/main/assets/preview.gif" alt="preview" width="210"> | 
|:---:|:---:|:---:|

## Features

- 🗺️ Native Apple Maps integration
- 🔍 Built-in place search functionality
- 📍 Custom marker support
- 🎬 Custom bottom address view
- 🎨 Customizable UI components
- 🎯 Precise location selection

### Prerequisites

1. iOS 15.0 or higher
2. Flutter 3.3.10 or higher
3. Valid Apple Developer account for MapKit usage

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  apple_maps_place_picker: ^0.1.0
```

## Usage

### Basic Implementation

```dart
AppleMapsPlacePicker(
  initialLatitude: 40.37818,
  initialLongitude: 49.83991,
  onPlaceSelected: (Place place) {
    print('Selected place: ${place.address}');
  },
)
```
### Full Customization

```dart
AppleMapsPlacePicker(
  initialLatitude: 40.37818,
  initialLongitude: 49.83991,
  config: PlacePickerConfig(
    searchBarConfig: SearchBarConfig(
      hintText: 'Search place',
      textFieldTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: Colors.white,
    ),
    searchResultConfig: SearchResultConfig(
      itemTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      backgroundColor: Colors.grey[100],
    ),
    addressViewConfig: AddressViewConfig(
      confirmButtonText: 'Confirm',
      addressTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w300,
      ),
    ),
  ),
  onPlaceSelected: (Place place) {
    print('Selected place: ${place.address}');
  },
)
```

### Custom Marker

```dart
AppleMapsPlacePicker(
  initialLatitude: 40.37818,
  initialLongitude: 49.83991,
  onPlaceSelected: (Place place) {
    print('Selected place: ${place.address}');
  },
  customMarker: Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      color: Colors.blue,
      shape: BoxShape.circle,
    ),
  ),
)
```

### Custom Bottom Address View

```dart
AppleMapsPlacePicker(
  initialLatitude: 40.37818,
  initialLongitude: 49.83991,
  onPlaceSelected: (Place place) {
    print('Selected place: ${place.address}');
  },
  customBottomSheet: (Place? place) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(place?.address ?? 'Not found'),
          ElevatedButton(
            onPressed: () {
              // Handle confirmation
            },
            child: Text('Confirm Location'),
          ),
        ],
      ),
    );
  },
)
```

## TODO

Upcoming features and improvements:

- [ ] Add "My Location" button functionality
- [ ] Implement custom map styles support
- [ ] Support for custom search UI

## Example

For a complete example, check the [example](https://github.com/shahmirzali49/apple_maps_place_picker/tree/main/example) directory.

## Contributing

Contributions are welcome! If you find a bug or want a feature, please open an issue. 

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Shahmirzali Huseynov ([Linkedin](https://www.linkedin.com/in/sahmirzeli))