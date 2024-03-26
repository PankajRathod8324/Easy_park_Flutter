import 'package:easy_park_app/view/home/vehicle.dart';
import 'package:flutter/material.dart';

class FullDetailsScreen extends StatelessWidget {
  FullDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 26, vertical: 14),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "Parking Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage("assets/img/deatils.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                height: 176,
                width: 368,
              ),
              SizedBox(height: 28),
              Padding(
                padding: EdgeInsets.only(left: 23, right: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Parking Lot of San Manolia",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "9569, Trantow Courts, San Manolia",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 31,
                      width: 21,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/imgBookmarkPrimary"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 60, top: 9, bottom: 9),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 37),
              Row(
                children: [
                  _buildDetailChip("2 km", Icons.location_on),
                  _buildDetailChip("8 am to 10 am", Icons.access_time),
                  _buildDetailChip("Valet", Icons.local_parking),
                ],
              ),
              SizedBox(height: 36),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 353,
                  child: CustomReadMoreText(
                    text:
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s...",
                    trimLines: 7,
                    colorClickableText: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 13),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: Column(
                  children: [
                    Text(
                      "\$2.02 per hour",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    // Additional details can be added here
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add cancel button functionality
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add book parking button functionality
                      Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => VehicleScreen()));
                    },
                    child: Text("Book Parking"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("Parking Details"),
    );
  }

  Widget _buildDetailChip(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon),
      label: Text(label),
      backgroundColor: Colors.blue,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FullDetailsScreen(),
  ));
}

class CustomReadMoreText extends StatefulWidget {
  final String text;
  final int trimLines;
  final Color colorClickableText;

  CustomReadMoreText({
    required this.text,
    required this.trimLines,
    required this.colorClickableText,
  });

  @override
  _CustomReadMoreTextState createState() => _CustomReadMoreTextState();
}

class _CustomReadMoreTextState extends State<CustomReadMoreText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.zero, // Added to remove default margin
          child: Text(
            isExpanded ? widget.text : _getTrimmedText(),
            maxLines: isExpanded ? null : widget.trimLines,
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(
            isExpanded ? 'Read less' : 'Read more',
            style: TextStyle(color: widget.colorClickableText),
          ),
        ),
      ],
    );
  }

  String _getTrimmedText() {
    String trimmedText = widget.text;
    if (widget.text.length > widget.trimLines) {
      trimmedText = widget.text.substring(0, widget.trimLines) + '...';
    }
    return trimmedText;
  }
}
