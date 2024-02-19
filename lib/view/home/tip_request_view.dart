import 'package:easy_park_app/common/color_extension.dart';
import 'package:easy_park_app/view/home/run_ride_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';


class TipRequestView extends StatefulWidget {
  const TipRequestView({super.key});

  @override
  State<TipRequestView> createState() => _TipRequestViewState();
}

class _TipRequestViewState extends State<TipRequestView> with OSMMixinObserver {
  bool isOpen = true;

  late MapController controller;
  //23.02756018230479, 72.58131973941731
  //23.02726396414328, 72.5851928489523

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = MapController(
      initPosition:
          GeoPoint(latitude: 22.6916018230479, longitude: 72.8634973941731),
    );

    controller.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          OSMFlutter(
            controller: controller,
            osmOption: OSMOption(
                enableRotationByGesture: true,
                zoomOption: const ZoomOption(
                  initZoom: 8,
                  minZoomLevel: 3,
                  maxZoomLevel: 19,
                  stepZoom: 1.0,
                ),
                staticPoints: [],
                roadConfiguration: const RoadOption(
                  roadColor: Colors.blueAccent,
                ),
                markerOption: MarkerOption(
                  defaultMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                      size: 56,
                    ),
                  ),
                ),
                showDefaultInfoWindow: false),
            onMapIsReady: (isReady) {
              if (isReady) {
                print("map is ready");
              }
            },
            onLocationChanged: (myLocation) {
              print("user location :$myLocation");
            },
            onGeoPointClicked: (myLocation) {
              print("GeoPointClicked location :$myLocation");
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ]),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "25 min",
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 25,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "\$12.50",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: TColor.secondaryText,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "4.5 KM",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: TColor.secondaryText,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/img/rate_tip.png",
                                  width: 15,
                                  height: 15,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "3.5",
                                  style: TextStyle(
                                    color: TColor.secondaryText,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                color: TColor.secondary,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            "1 Ash Park, Pembroke Dock, SA72",
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(color: TColor.primary),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            "54 Hollybank Rd, Southampton",
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: (){
                        context.push(const RunRideView() );
                      },
                      child: Container(
                        width: double.maxFinite,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: TColor.primary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "TAP TO ACCEPT",
                                  style: TextStyle(
                                    color: TColor.primaryTextW,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "15",
                                style: TextStyle(
                                  color: TColor.primaryTextW,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              )
            ],
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          context.pop();
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 25),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                  ),
                                ]),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/img/close.png",
                                  width: 25,
                                  height: 25,
                                ),
                                Text(
                                  "No Thanks",
                                  style: TextStyle(
                                      color: TColor.primaryText, fontSize: 16),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void addMarker() async {
    await controller.setMarkerOfStaticPoint(
      id: "pickup",
      markerIcon: MarkerIcon(
        iconWidget: Image.asset(
          "assets/img/pickup_pin.png",
          width: 80,
          height: 80,
        ),
      ),
    );

    await controller.setMarkerOfStaticPoint(
      id: "dropoff",
      markerIcon: MarkerIcon(
        iconWidget: Image.asset(
          "assets/img/drop_pin.png",
          width: 80,
          height: 80,
        ),
      ),
    );

    //23.02756018230479, 72.58131973941731
    //23.02726396414328, 72.5851928489523

    await controller.setStaticPosition(
        [GeoPoint(latitude: 22.6916018230479, longitude: 72.8634973941731)],
        "pickup");

    await controller.setStaticPosition(
        [GeoPoint(latitude: 22.6916018230479, longitude: 72.7634973941731)],
        "dropoff");

    loadMapRoad();
  }

  void loadMapRoad() async {
    await controller.drawRoad(
        GeoPoint(latitude: 22.6916018230479, longitude: 72.8634973941731),
        GeoPoint(latitude: 22.6916018230479, longitude: 72.7634973941731),
        roadType: RoadType.car,
        roadOption:
            const RoadOption(roadColor: Colors.blueAccent, roadBorderWidth: 3));
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
      addMarker();
    }
  }
}
