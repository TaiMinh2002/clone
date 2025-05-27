import 'package:flutter/material.dart';
import 'package:instagram/core/models/user.dart';
import 'package:instagram/feature/profile/data/profile_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  bool isLoading = true;
  String? error;
  final _profileService = ProfileService();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final userData = await _profileService.getCurrentUser();
      setState(() {
        user = userData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text('Error: $error'));
    }

    if (user == null) {
      return const Center(child: Text('No user data available'));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: user?.image != null
                    ? NetworkImage(user!.image!)
                    : null,
                child: user?.image == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoCard(
              title: 'Personal Information',
              children: [
                _buildInfoRow(
                  'Name',
                  '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
                ),
                _buildInfoRow('Username', user?.username ?? 'N/A'),
                _buildInfoRow('Email', user?.email ?? 'N/A'),
                _buildInfoRow('Phone', user?.phone ?? 'N/A'),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              title: 'Location',
              children: [
                _buildInfoRow('Address', user?.address?.address ?? 'N/A'),
                _buildInfoRow('City', user?.address?.city ?? 'N/A'),
                _buildInfoRow('Country', user?.address?.country ?? 'N/A'),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              title: 'Work Information',
              children: [
                _buildInfoRow('Company', user?.company?.name ?? 'N/A'),
                _buildInfoRow('Position', user?.company?.title ?? 'N/A'),
                _buildInfoRow('Department', user?.company?.department ?? 'N/A'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
