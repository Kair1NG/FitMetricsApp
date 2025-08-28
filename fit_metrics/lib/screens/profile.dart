import 'package:fit_metrics/common/widgets/appBar.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(icon: Icons.person, title: 'Profile'),
      body: Container(
        margin: EdgeInsets.only(
          top: 20.0,
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
        ),
        child: Column(
          children: [
            Container(
              height: 150,
              width: screenWidth * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.0),
              child: Row(
                // placeholder info
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color.fromARGB(255, 30, 100, 255),
                    child: Text(
                      'JD',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    // Uncomment for profile image
                    // backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'John Doe',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'john.doe@example.com',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      print('Edit profile pressed');
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 20,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            // profile card
            SizedBox(height: 20),
            Container(
              constraints: BoxConstraints(
                minHeight: screenHeight * .4,
                minWidth: screenWidth * 0.9,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              // placeholder info
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 15),
                    child: Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Gender', style: TextStyle(color: Colors.grey)),
                    subtitle: Text(
                      'Male',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Height', style: TextStyle(color: Colors.grey)),
                    subtitle: Text(
                      '180 cm',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Weight', style: TextStyle(color: Colors.grey)),
                    subtitle: Text(
                      '75 kg',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Age', style: TextStyle(color: Colors.grey)),
                    subtitle: Text(
                      '30 years',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
