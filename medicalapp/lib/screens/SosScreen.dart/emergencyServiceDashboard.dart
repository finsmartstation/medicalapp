import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'emergencyServiceContactList.dart';

class EmergencyServicesDashboard extends StatefulWidget {
  const EmergencyServicesDashboard({super.key});

  @override
  State<EmergencyServicesDashboard> createState() =>
      _EmergencyServicesDashboardState();
}

class _EmergencyServicesDashboardState
    extends State<EmergencyServicesDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        leading: IconButton(
            onPressed: (() {
              Navigator.pop(context);
            }),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title: const Text(
          "Emergency Service",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(60),
              topRight: Radius.circular(60),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            const Text(
              "Create Emergency Profile",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const Text(
              "For quick access during an emergency,add emergency contact",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 10),
            ),
            const SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EmergencyServicesContact()));
              },
              child: Container(
                height: 80,
                width: 350,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 2,
                        spreadRadius: 1.0,
                      )
                    ],
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Center(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      radius: 30,
                      child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 25,
                          child: Icon(
                            Icons.person,
                            color: Colors.black,
                          )),
                    ),
                    title: const Text(
                      "Manage Contact",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                    trailing: CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      radius: 25,
                      child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                          )),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () async {
                const url = "tel:102";
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Container(
                height: 80,
                width: 350,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 2,
                        spreadRadius: 1.0,
                      )
                    ],
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Center(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      radius: 30,
                      child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 25,
                          child: Icon(
                            Icons.medical_services_outlined,
                            color: Colors.black,
                          )),
                    ),
                    title: Column(
                      children: const [
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          "Call Ambulance",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, color: Colors.black),
                        ),
                        Text(
                          "Tap her to dial 102",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 13),
                        )
                      ],
                    ),
                    trailing: CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      radius: 25,
                      child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                          )),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
