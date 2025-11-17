import 'package:betweener_app/core/helpers/context_extenssion.dart';
import 'package:betweener_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/helpers/api_response.dart';
import '../../core/util/assets.dart';
import '../../core/util/constants.dart';
import '../../view_models/followers_provider.dart';
import '../Friend/view_friend.dart';

class CustomUserDataContainer extends StatelessWidget {
  const CustomUserDataContainer({
    super.key,
    required this.user,
    required this.isUser,
  });

  final UserClass user;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundImage: AssetImage(AssetsData.profileIcon),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email ?? '',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (isUser)
                      Text(
                        '+9700000000',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: isUser
                              ? const FriendCount()
                              : FollowButton(userId: user.id!),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // NOTE: Update User is not implemented in the API yet.
        // if (isUser)
        //   Positioned(
        //     top: 8,
        //     right: 8,
        //     child: IconButton(
        //       onPressed: () {},
        //       icon: const Icon(Icons.edit, color: Colors.white),
        //     ),
        //   ),
      ],
    );
  }
}
class FollowButton extends StatelessWidget {
  final int userId;

  const FollowButton({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Consumer<FollowersProvider>(
      builder: (context, provider, _) {
        final bool isFollowing = provider.isFollowing(userId);

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isFollowing
                ? null
                : () {
              provider.followingList.add(userId);
              provider.addFollow(userId.toString());

              context.showSnackBar(
                message: "Followed!",
                error: false,
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.grey.shade200;
                }
                return kSecondaryColor;
              }),
            ),

            // style: ElevatedButton.styleFrom(
            //   backgroundColor: isFollowing ?  kSecondaryColor : Colors.grey[300],
            // ),
            child: Text(
              isFollowing ? 'Following' : 'Follow',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        );
      },
    );
  }
}



class FriendCount extends StatelessWidget {
  const FriendCount({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FollowersProvider>(
      builder: (context, provider, _) {
        final api = provider.followersResponse;

        if (api == null || api.status == Status.LOADING) {
          return
            CircularProgressIndicator();
        }
        if (api.status == Status.ERROR) {
          return Text(
            'Error: ${api.message}',
            style: Theme.of(context).textTheme.bodySmall,
          );
        }

        final data = api.data!;

        return Row(
          children: [
            Expanded(
              child:
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewFriend(
                        follow: "Followers",
                        followList: data.followers,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Followers ${data.followersCount ?? 0}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewFriend(
                        follow: "Following",
                        followList: data.following,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Following ${data.followingCount ?? 0}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),

            ),
          ],
        );
      },
    );
  }
}
