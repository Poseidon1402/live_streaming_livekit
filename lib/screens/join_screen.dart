import 'package:flutter/cupertino.dart';
import 'package:livekit_client/livekit_client.dart';

import '../config/websocket_config.dart';
import '../data/sources/get_token_source.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final room = Room();
  List<RemoteParticipant> remoteParticipants = [];
  bool isConnecting = true;

  @override
  void initState() {
    super.initState();
    _setupRoom();
  }

  void _setupRoom() async {
    try {
      // Setup listener for remote participants
      room.addListener(_onRoomUpdate);

      // Get token from server
      String? token =
          await GetTokenFromServer('http://localhost:3000/getToken').call() ?? '';
      
      // Connect to the room
      await room.connect(
        WebSocketConfig.serverUrl,
        token,
      );

      setState(() {
        isConnecting = false;
        remoteParticipants = room.remoteParticipants.values.toList();
      });
    } catch (error) {
      debugPrint('Error connecting to room: $error');
      setState(() {
        isConnecting = false;
      });
    }
  }

  void _onRoomUpdate() {
    setState(() {
      remoteParticipants = room.remoteParticipants.values.toList();
    });
  }

  @override
  void dispose() {
    room.removeListener(_onRoomUpdate);
    room.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Join Live Stream'),
      ),
      child: SafeArea(
        child: isConnecting
            ? const Center(child: CupertinoActivityIndicator())
            : remoteParticipants.isEmpty
                ? const Center(
                    child: Text(
                      'Waiting for host to start streaming...',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : _buildParticipantsList(),
      ),
    );
  }

  Widget _buildParticipantsList() {
    return ListView.builder(
      itemCount: remoteParticipants.length,
      itemBuilder: (context, index) {
        final participant = remoteParticipants[index];
        return _buildParticipantView(participant);
      },
    );
  }

  Widget _buildParticipantView(RemoteParticipant participant) {
    final videoTrack = participant.videoTrackPublications.isNotEmpty
        ? participant.videoTrackPublications.first.track
        : null;

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: CupertinoColors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          if (videoTrack != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: VideoTrackRenderer(
                videoTrack,
                fit: VideoViewFit.cover,
              ),
            )
          else
            const Center(
              child: Icon(
                CupertinoIcons.person_circle,
                size: 64,
                color: CupertinoColors.systemGrey,
              ),
            ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: CupertinoColors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                participant.identity,
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}