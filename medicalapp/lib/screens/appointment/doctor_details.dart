import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:avatar_glow/avatar_glow.dart';
class DoctorDetails extends StatefulWidget {
  const DoctorDetails({super.key});

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blue.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 2))
                  ],
                  color:Colors.blue[900]),
            ),
          ],
        ),
        Positioned(
          top: 100,
          left: 40,
          right: 40,
          child: Container(
            width: 150,
            height: 150,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const AvatarGlow(
              endRadius: 300.0 ,
              glowColor: Colors.blue,
              child: CircleAvatar(
                        radius: 65,
                        child: ClipOval(
                          child: Image(
                            image:
                             CachedNetworkImageProvider("https://cdn-icons-png.flaticon.com/512/147/147285.png"
                                       ),
                                      
                            fit: BoxFit.cover,
                            width: 140,
                            height: 140,
                          ),
                        ),
                      ),
            ),
          ),
        ),
        
        Positioned(
          top: 420,
          left: 20,
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Name",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Email",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Specialization",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Designation",
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
      ]),

      
    );
  }
}