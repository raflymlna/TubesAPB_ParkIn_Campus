import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';

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
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get(),
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

                const SizedBox(height: 20),

                CircleAvatar(
                  radius: 60,
                  backgroundColor: const Color(0xFF800000),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  data['full_name'] ?? 'No Name',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                _buildProfileCard(
                  icon: Icons.email,
                  title: AppLocalizations.of(context)!.email,
                  subtitle: data['email'] ?? '-',
                ),

                const SizedBox(height: 16),

                _buildProfileCard(
                  icon: Icons.phone,
                  title: AppLocalizations.of(context)!.phoneNumber,
                  subtitle: data['phone'] ?? '-',
                ),

                const SizedBox(height: 30),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.vehicleInformation,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('vehicles')
                      .where('userId',
                          isEqualTo: user.uid)
                      .snapshots(),
                  builder:
                      (context, vehicleSnapshot) {

                    if (vehicleSnapshot
                            .connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child:
                            CircularProgressIndicator(),
                      );
                    }

                    if (!vehicleSnapshot.hasData ||
                        vehicleSnapshot
                            .data!.docs.isEmpty) {
                      return const Text(
                        "No vehicle registered",
                      );
                    }

                    final vehicles =
                        vehicleSnapshot.data!.docs;

                    return Column(
                      children:
                          vehicles.map((vehicle) {

                        final vehicleData =
                            vehicle.data()
                                as Map<String, dynamic>;

                        return Column(
                          children: [

                            _buildProfileCard(
                              icon: Icons.pin,
                              title: AppLocalizations.of(context)!.licensePlate,
                              subtitle:
                                  vehicleData[
                                          'licensePlate'] ??
                                      '-',
                            ),

                            const SizedBox(
                                height: 16),

                            _buildProfileCard(
                              icon: Icons
                                  .directions_car,
                              title: AppLocalizations.of(context)!.vehicleType,
                              subtitle:
                                  vehicleData[
                                          'type'] ??
                                      '-',
                            ),

                            const SizedBox(
                                height: 16),

                            _buildProfileCard(
                              icon:
                                  Icons.car_repair,
                              title: AppLocalizations.of(context)!.brandModel,
                              subtitle:
                                  "${vehicleData['brand'] ?? ''} ${vehicleData['model'] ?? ''}",
                            ),

                            const SizedBox(
                                height: 20),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 20),

Consumer<LanguageProvider>(
  builder: (context, provider, child) {
    return DropdownButton<String>(
      value: provider.locale.languageCode,

      isExpanded: true,

      items: const [
        DropdownMenuItem(
          value: 'en',
          child: Text('English'),
        ),
        DropdownMenuItem(
          value: 'id',
          child: Text('Bahasa Indonesia'),
        ),
      ],

      onChanged: (value) {
        provider.changeLanguage(value!);
      },
    );
  },
),

const SizedBox(height: 20),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await FirebaseAuth.instance
                          .signOut();
                    },
                    icon: const Icon(Icons.logout),
                    label: Text(
                      AppLocalizations.of(context)!.logout,
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

  static Widget _buildProfileCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF800000)
                  .withOpacity(0.1),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color:
                  const Color(0xFF800000),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}