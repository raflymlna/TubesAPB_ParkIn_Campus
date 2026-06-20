import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/language_provider.dart';

import 'profile_detail_page.dart';
import '../home/registrasi_kendaraan_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.profile,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          if (!snapshot.hasData ||
              !snapshot.data!.exists) {
            return const Center(
              child: Text("User data not found"),
            );
          }

          final data =
              snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [

                // PROFILE CARD
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [

                      const CircleAvatar(
                        radius: 30,
                        backgroundColor:
                            Color(0xFF800000),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['full_name'] ?? '',
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              data['phone'] ?? '',
                            ),
                          ],
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const ProfileDetailPage(),
                            ),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!
                              .viewProfile,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const SizedBox(height: 24),
                
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(AppLocalizations.of(context)!.vehicles,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const SizedBox(height: 12),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                  .collection('vehicles')
                  .where('userId', isEqualTo: user.uid)
                  .snapshots(),
                builder: (context, snapshot) {
                  
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }
                  
                  final vehicles = snapshot.data!.docs;
                  
                  if (vehicles.isEmpty) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.noVehicle,
                      ),
                    );
                  }
                  
                  return Column(
                    children: vehicles.map((doc) {
                      
                      final vehicle =
                        doc.data() as Map<String, dynamic>;

                      final type = vehicle['type']
                        .toString()
                        .toLowerCase();

                      String displayType;
                      
                    if (type.contains('motor')) {
                      displayType =
                        AppLocalizations.of(context)!.motorcycle;
                      } else if (type.contains('mobil')) {
                        displayType =
                        AppLocalizations.of(context)!.car;
                      } else {
                        displayType = vehicle['type'] ?? '';
                      }
                        
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                            BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                                Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        
                        child: Row(
                          children: [
                            
                            Icon(
                              type.contains('motor')
                                ? Icons.two_wheeler
                                : Icons.directions_car,
                              color: const Color(0xFF800000),
                              size: 34,
                            ),
                            
                            const SizedBox(width: 16),
                            
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                children: [
                                  
                                Text(
                                  vehicle['licensePlate'] ?? '-',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                
                                const SizedBox(height: 4),
                                
                                Text(
                                  '${vehicle['brand'] ?? ''} ${vehicle['model'] ?? ''}',
                                ),
                                
                                Text(
                                  displayType,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  
                   }).toList(),
                  );
                },
              ),
              const SizedBox(height: 8),

                // MANAGE VEHICLE CARD
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.directions_car,
                      color: Color(0xFF800000),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!
                          .manageVehicle,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const RegistrasiKendaraanPage(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // LANGUAGE
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.language,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Consumer<LanguageProvider>(
                  builder: (context, provider, child) {
                    return DropdownButton<String>(
                      value:
                          provider.locale.languageCode,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text('English'),
                        ),
                        DropdownMenuItem(
                          value: 'id',
                          child:
                              Text('Bahasa Indonesia'),
                        ),
                      ],
                      onChanged: (value) {
                        provider.changeLanguage(
                          value!,
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 40),

                // LOGOUT BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await FirebaseAuth.instance
                          .signOut();
                    },
                    icon: const Icon(Icons.logout),
                    label: Text(
                      AppLocalizations.of(context)!
                          .logout,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF800000),
                      foregroundColor:
                          Colors.white,
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
