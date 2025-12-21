import 'package:flutter/material.dart';
import 'package:enerlink_mobile/models/community.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:enerlink_mobile/screens/community_detail.dart';
import 'package:enerlink_mobile/screens/community_join_confirmation.dart';

class CommunityCard extends StatelessWidget {
  final Community community;
  final bool isJoined;
  final VoidCallback? onTap;
  final VoidCallback? onJoinTap;

  const CommunityCard({
    super.key, 
    required this.community, 
    this.isJoined = false, 
    this.onTap,
    this.onJoinTap,
  });

  @override
  Widget build(BuildContext context) {
    final fields = community.fields;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover Image
          if (fields.coverUrls != null && fields.coverUrls!.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: fields.coverUrls!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            )
          else
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: const Center(
                child: Text('No Image', style: TextStyle(color: Colors.white)),
              ),
            ),

          // Card Content
          InkWell(
            onTap: onTap ?? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommunityDetailPage(community: community),
                ),
              );
            },
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and City
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          fields.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D47A1),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isJoined)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withAlpha((255 * 0.1).round()),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Joined',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fields.city,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    fields.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // Footer with members and actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.people_alt_outlined, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${fields.totalMembers} Members',
                            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (!isJoined)
                            ElevatedButton(
                              onPressed: onJoinTap ?? () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CommunityJoinConfirmationPage(community: community),
                                  ),
                                );
                                if (result == true) {
                                  // TODO: Refresh parent widget if needed
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Berhasil bergabung dengan komunitas!")),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                textStyle: const TextStyle(fontSize: 12),
                              ),
                              child: const Text('Gabung'),
                            )
                          else
                            const Text(
                              'Sudah Bergabung',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
