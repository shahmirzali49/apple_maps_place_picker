import 'package:apple_maps_place_picker/apple_maps_place_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Place? _selectedPlace;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_selectedPlace != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selected Place Details:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AddressDetailRow(
                      label: 'Address:',
                      value: _selectedPlace!.address ?? 'N/A',
                    ),
                    AddressDetailRow(
                      label: 'Latitude:',
                      value: _selectedPlace!.latitude.toStringAsFixed(6),
                    ),
                    AddressDetailRow(
                      label: 'Longitude:',
                      value: _selectedPlace!.longitude.toStringAsFixed(6),
                    ),
                    AddressDetailRow(
                      label: 'Name:',
                      value: _selectedPlace!.name,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.blue,
                ),
                onPressed: () async {
                  final result = await Navigator.push<Place?>(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PlacePickerPage()),
                  );

                  if (result != null) {
                    setState(() {
                      _selectedPlace = result;
                    });
                  }
                },
                icon: const Icon(Icons.place),
                label: Text(
                    _selectedPlace == null ? 'Select Place' : 'Change Place'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlacePickerPage extends StatelessWidget {
  const PlacePickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Picker'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AppleMapsPlacePicker(
          initialLatitude: 40.37818,
          initialLongitude: 49.83991,
          // config: PlacePickerConfig(
          //   searchBarConfig: SearchBarConfig(
          //     hintText: 'Search place',
          //     leadingIconColor: Colors.white,
          //     textFieldTextStyle: const TextStyle(
          //       fontSize: 16,
          //       fontWeight: FontWeight.bold,
          //     ),
          //     textFieldBackgroundColor: Colors.grey.shade400,
          //     padding: const PaddingModel(
          //       top: 10,
          //       left: 10,
          //       bottom: 10,
          //       right: 10,
          //     ),
          //     backgroundColor: Colors.white,
          //     cancelButtonText: 'Cancel',
          //     cancelButtonTextColor: Colors.red,
          //   ),
          //   searchResultConfig: SearchResultConfig(
          //     itemTextStyle: const TextStyle(
          //       fontSize: 16,
          //       fontWeight: FontWeight.bold,
          //       color: Colors.black87,
          //     ),
          //     backgroundColor: Colors.grey.shade100,
          //     itemPadding: const PaddingModel(
          //       top: 24,
          //       left: 16,
          //       bottom: 24,
          //       right: 16,
          //     ),
          //     itemMargin: PaddingModel.symmetric(
          //       vertical: 12,
          //       horizontal: 16,
          //     ),
          //   ),
          //   addressViewConfig: const AddressViewConfig(
          //     addressPadding: PaddingModel(
          //       top: 6,
          //       left: 18,
          //       bottom: 6,
          //       right: 18,
          //     ),
          //     backgroundColor: Colors.white,
          //     confirmButtonText: 'Tesdiqle',
          //     addressTextStyle: TextStyle(
          //       fontSize: 18,
          //       fontWeight: FontWeight.w300,
          //     ),
          //     confirmButtonStyle: ButtonStyleModel(
          //       backgroundColor: Colors.blue,
          //       textStyle: TextStyle(
          //         fontSize: 16,
          //         fontWeight: FontWeight.normal,
          //         color: Colors.white,
          //       ),
          //       cornerRadius: 12,
          //       padding: PaddingModel(
          //         left: 12,
          //         right: 12,
          //         top: 12,
          //         bottom: 12,
          //       ),
          //     ),
          //   ),
          //   centerMarkerConfig: const CenterMarkerConfig(
          //     markerColor: Colors.red,
          //     markerSize: 30,
          //   ),
          // ),
          onPlaceSelected: (Place place) {
            print('Selected place address: ${place.address}');
            Navigator.pop(context, place);
          },
          // customMarker: Container(
          //   width: 50,
          //   height: 50,
          //   margin: EdgeInsets.only(bottom: 100),
          //   decoration: const BoxDecoration(
          //     color: Colors.amber,
          //     shape: BoxShape.circle,
          //   ),
          // ),
          // customBottomAddressViewBuilder: (Place? place) {
          //   return Material(
          //     child: Container(
          //       color: Colors.white,
          //       width: double.maxFinite,
          //       padding: const EdgeInsets.all(16),
          //       child: SafeArea(
          //         child: Column(children: [
          //           Text(
          //             place == null ? '' : place.address ?? 'not found',
          //             style: TextStyle(
          //               fontSize: 16,
          //               fontWeight: FontWeight.bold,
          //             ),
          //             maxLines: 2,
          //             textAlign: TextAlign.center,
          //           ),
          //           const SizedBox(height: 16),
          //           ElevatedButton(
          //             onPressed: () {
          //               print("place: $place");
          //             },
          //             child: Text('Confirm'),
          //           ),
          //         ]),
          //       ),
          //     ),
          //   );
          // },
        ),
      ),
    );
  }
}

class AddressDetailRow extends StatelessWidget {
  const AddressDetailRow({
    super.key,
    required this.label,
    required this.value,
  });
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
