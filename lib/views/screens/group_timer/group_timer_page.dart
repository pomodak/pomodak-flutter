import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodak/config/constants/cdn_images.dart';
import 'package:pomodak/view_models/auth_view_model.dart';
import 'package:pomodak/view_models/group_timer_view_model.dart';
import 'package:provider/provider.dart';

class GroupTimerPage extends StatefulWidget {
  const GroupTimerPage({super.key});

  @override
  State<GroupTimerPage> createState() => _GroupTimerPageState();
}

class _GroupTimerPageState extends State<GroupTimerPage> {
  GroupTimerViewModel? _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<GroupTimerViewModel>(context, listen: false);

    _connectToSocket();
  }

  void _connectToSocket() async {
    final accessToken = await Provider.of<AuthViewModel>(context, listen: false)
        .getAccessToken();
    if (accessToken != null && mounted) {
      _viewModel?.connectAndListen(accessToken: accessToken);
    }
  }

  @override
  void dispose() {
    _viewModel?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Group Timer',
          style: TextStyle(fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: Consumer<GroupTimerViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.members.isEmpty) {
            return const Center(child: Text("No members connected."));
          }
          return ListView.builder(
            itemCount: viewModel.members.length,
            itemBuilder: (context, index) {
              final member = viewModel.members[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                    member.imageUrl == ""
                        ? CDNImages.newMember["mascot"]!
                        : member.imageUrl,
                  ),
                ),
                title: Text(member.nickname),
                subtitle: Text('Joined: ${member.joinedAtUTC}'),
              );
            },
          );
        },
      ),
    );
  }
}
