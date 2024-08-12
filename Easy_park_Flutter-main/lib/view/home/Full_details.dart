import 'dart:convert';

import 'package:easy_park_app/view/config/config.dart';
import 'package:easy_park_app/view/home/book_parking_details.dart';
import 'package:easy_park_app/view/home/choose_vehicle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FullDetails extends StatefulWidget {
  final Map<String, dynamic> matchingParkArea;

  const FullDetails({
    Key? key,
    required this.matchingParkArea,
  }) : super(key: key);
  @override
  _FullDetailsState createState() => _FullDetailsState();
}

class _FullDetailsState extends State<FullDetails> {
  late Map<String, dynamic> userData = {};
  late String username = '';
  late String date = '';
  late String rating = '';
  late String review = '';
  late String profile = '';

  int? selectedReviewId;
  // late List<Map<String, dynamic>> reviews = [];
  // late Map<String, dynamic> reviewdata = {};
  List<Map<String, dynamic>> reviewList = [];

  @override
  void initState() {
    super.initState();
    // Initialize state variables here
    print('User Data');
    // print(userData);
    getUserData();
    getReview();
  }

  Future<void> getReview() async {
    try {
      print("======================================");
      // Make a GET request to your backend endpoint
      print('$getreview?parkAreaId=${widget.matchingParkArea['id']}');

      // String temp =rr
      // '$getreview?parkAreaId=${widget.matchingParkArea['id']}';
      final response = await http.get(
          Uri.parse('$getreview?parkAreaId=${widget.matchingParkArea['id']}'));
      print('response Data ----------------------------');
      print(response);
      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the response body (assuming it's JSON)
        final responseData = json.decode(response.body);

        // Process the review details
        // For example, you can store them in a variable or update the UI with the data
        print(
            responseData); // This will print the review details to the console
        // Update the UI with the received review data
        // username = responseData['username'];
        // date = responseData['date'];
        // rating = responseData['rating'].toString();
        // review = responseData['review'];
        if (responseData is Map && responseData.containsKey('reviews')) {
          // Check if the response is a map with 'vehicles' field
          reviewList = List<Map<String, dynamic>>.from(
            responseData['reviews'] as List<dynamic>,
          );
        } else {
          // Handle the case where the response is not as expected
          reviewList = [];
        }
        if (mounted) {
          setState(() {
            // reviews = List<Map<String, dynamic>>.from(responseData);
            // print("2222222222222222222222222222");
            // print(reviews);
            // Assuming you have a variable to store the reviews
            // reviews = responseData['reviews'];
            // for (var review in responseData['reviews']) {
            //   // Print each review detail
            //   print('Review ID: ${review['_id']}');
            //   print('Username: ${review['username']}');
            //   print('Date: ${review['date']}');
            //   print('Rating: ${review['rating']}');
            //   print('Review: ${review['review']}');
            // print('----------------------------------');
          });
        }
      } else {
        // Handle error response (e.g., server error, not found)
        print(
            'Failed to fetch review details. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any exceptions that occur during the request
      print('Error fetching review details: $error');
    }
  }

  Widget buildReviewWidget(Map<String, dynamic> reviewData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Username: ${reviewData['username']}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('Date: ${reviewData['date']}'),
        Text('Rating: ${reviewData['rating']}'),
        Text('Review: ${reviewData['review']}'),
        Divider(),
      ],
    );
  }

  Future<void> getUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userEmail = prefs.getString('userEmail');
      // Retrieve user email from local storage
      // String userEmail =
      ''; // Replace with logic to get user email from local storage

      // Make HTTP GET request to fetch user data using the user's email
      final response = await http.get(Uri.parse('$getUser?email=$userEmail'));
      print('Respomse::');
      print(response.body);

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Decode the response JSON
        final userDataJson = jsonDecode(response.body);
        // Update the state with user data
        setState(() {
          userData = userDataJson;
          profile = userData.containsKey('profile')
              ? 'assets/images/user/${userData['profile']}'
              : 'assets/images/user/default_profile_image.png';
        });
      } else {
        // Handle error if request fails
        print('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the process
      print('Exception while fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(reviewdata);
    // print(username);
    // print(date);
    // print(rating);
    // print(review);
    // print(userData);
    // print('-------------------------------');
    // print(widget.matchingParkArea);
    // String temp  = widget.matchingParkArea?['slots'];
    String slots = widget.matchingParkArea?['slots'].toString() ?? '';
    String timing = widget.matchingParkArea?['timing'].toString() ?? '';
    String address = widget.matchingParkArea?['address'].toString() ?? '';
    // String pricePerHour = matchingParkArea['pricePerHour'].toString();
    String name = widget.matchingParkArea?['name'].toString() ?? '';
    List<String> images =
        List<String>.from(widget.matchingParkArea?['images'] ?? '');
    // Assuming ratings are available as double
    // double ratings = matchingParkArea['ratings'];
    String ratings = '5';
    String pricePerHour = widget.matchingParkArea?['price_per_hr'].toString() ??
        '' + ' ' + '/hours';
    String distance = '1.2 Km ';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Parking Details',
              style: TextStyle(color: Colors.black),
            ),
            IconButton(
              icon: Icon(Icons.bookmark_border),
              onPressed: () {
                // Handle bookmark button press
              },
              iconSize: 30,
              color: Colors.black,
            ),
          ], // Title color
        ),
        backgroundColor: Colors.white, // AppBar background color
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .pop(); // Navigate back when back button is pressed
          },
          color: Colors.black, // Back button color
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 200, // Height of the image slider
            child: ImageSlider(images: images),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   name,
                //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                // ),
                // SizedBox(height: 10),
                // Text(
                //   'Address: $address',
                //   style: TextStyle(fontSize: 18, color: Colors.black),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.directions_car,
                          color: Colors.pink, // Change color as needed
                        ),
                        SizedBox(width: 6),
                        Text(
                          slots, // Assuming slots is the slot number
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                      ],
                    ),

                    // SizedBox(height: 10),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // SizedBox(height: 10),
                    Text(
                      address,
                      style: TextStyle(fontSize: 13, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.pink, width: 2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.pink,
                              ),
                              SizedBox(width: 5),
                              Text(
                                distance,
                                style: TextStyle(color: Colors.pink),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.pink, width: 2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.pink,
                              ),
                              SizedBox(width: 5),
                              Text(
                                timing,
                                style: TextStyle(color: Colors.pink),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.pink, width: 2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.attach_money,
                                color: Colors.pink,
                              ),
                              SizedBox(width: 5),
                              Text(
                                pricePerHour,
                                style: TextStyle(color: Colors.pink),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Information',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),

                    // SizedBox(height: 10),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // SizedBox(height: 10),
                    Flexible(
                      // Wrap with Flexible widget
                      child: ExpandableText(
                        text:
                            '$name is conveniently located at the heart of downtown. Its address is $address. With a capacity of $slots parking slots, it offers ample space for visitors and commuters. The parking area operates $timing, ensuring accessibility at any time of day or night. Rates are competitive, priced at $pricePerHour per hour . Additionally, the parking area provides security personnel and surveillance cameras for added safety. Overall, City Center Parking offers a convenient and secure parking solution for those visiting the downtown area',
                        maxLines:
                            8, // Specify the maximum number of lines to be displayed initially
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 10),
                // Text('Address: $address'),
                // SizedBox(height: 10),
                // Text('Available Slots: $slots'),
                // SizedBox(height: 10),
                // Text('Timing: $timing'),
                // SizedBox(height: 10),
                // Text(pricePerHour),
                // SizedBox(height: 10),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Row(
                //       children: [
                //         // Facility icons
                //         Icon(Icons.security),
                //         SizedBox(width: 5),
                //         Icon(Icons.camera),
                //         SizedBox(width: 5),
                //         // Add more icons for facilities
                //       ],
                //     ),
                //     IconButton(
                //       icon: Icon(Icons.bookmark_border),
                //       onPressed: () {
                //         // Handle bookmark button press
                //       },
                //     ),
                //   ],
                // ),
                SizedBox(height: 20),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         'Reviews',
                //         style: TextStyle(
                //             fontSize: 20, fontWeight: FontWeight.bold),
                //       ),
                //       SizedBox(height: 10),
                //       Column(
                //         children: widget.matchingParkArea['reviews'] ??
                //             [].map<Widget>((review) {
                //               return buildReviewWidget(review);
                //             }).toList(),
                //       ),
                //       // Other details
                //       // ...
                //     ],
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Review',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),

                    // SizedBox(height: 10),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: reviewList.length,
                        itemBuilder: (context, index) {
                          var review = reviewList[index];
                          return TextButton(
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              // Store the ID of the selected car in local storage
                              prefs.setInt('selectedVehicleId', review['id']);

                              setState(() {
                                selectedReviewId = review['id'];
                              });
                            },
                            style: ButtonStyle(
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.transparent),
                            ),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedReviewId == review['id']
                                      ? Colors
                                          .pink // Change color based on selection
                                      : Colors.grey.withOpacity(0.5),
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Image.asset(
                                      profile,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Expanded(
                                    child: Container(
                                      color: Colors.grey.withOpacity(0.1),
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Name: ${review['username'] ?? 'Unknown Person'}',
                                            style: TextStyle(
                                              color: selectedReviewId ==
                                                      review['id']
                                                  ? Colors
                                                      .pink // Change color based on selection
                                                  : Colors.black,
                                            ),
                                          ),
                                          Text(
                                            'Date: ${review['date'] ?? 'Unknown date'}',
                                            style: TextStyle(
                                              color: selectedReviewId ==
                                                      review['id']
                                                  ? Colors
                                                      .pink // Change color based on selection
                                                  : Colors.black,
                                            ),
                                          ),
                                          Text(
                                            'Rating: ${review['rating'] ?? 'Unknown Plate'}',
                                            style: TextStyle(
                                              color: selectedReviewId ==
                                                      review['id']
                                                  ? Colors
                                                      .pink // Change color based on selection
                                                  : Colors.black,
                                            ),
                                          ),
                                          Text(
                                            'Review: ${review['review'] ?? 'Unknown Review'}',
                                            style: TextStyle(
                                              color: selectedReviewId ==
                                                      review['id']
                                                  ? Colors
                                                      .pink // Change color based on selection
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle cancel button press
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle book button press
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChooseVehicleView(
                                matchingParkArea: widget.matchingParkArea,
                                userData: userData),
                          ),
                        );
                      },
                      child: Text('Book Parking'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle style;

  ExpandableText({
    required this.text,
    required this.maxLines,
    required this.style,
  });

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          firstChild: Text(
            widget.text,
            maxLines: widget.maxLines,
            overflow: TextOverflow.ellipsis,
            style: widget.style,
          ),
          secondChild: Text(
            widget.text,
            style: widget.style,
          ),
          crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          child: Text(
            _expanded ? 'Read less' : 'Read more',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}

class ImageSlider extends StatefulWidget {
  final List<String> images;

  const ImageSlider({Key? key, required this.images}) : super(key: key);

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: widget.images.length,
      itemBuilder: (context, index) {
        return Image.asset(
          'assets/images/owners_parking/${widget.images[index]}',
          fit: BoxFit.cover,
        );
      },
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}
