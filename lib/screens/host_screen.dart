import 'package:flutter/cupertino.dart';
import 'package:livekit_client/livekit_client.dart';

import '../config/websocket_config.dart';
import '../data/sources/get_token_source.dart';

class HostScreen extends StatefulWidget {
  const HostScreen({super.key});

  @override
  State<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  final room = Room();
  LocalVideoTrack? localVideoTrack;

  @override
  void initState() {
    super.initState();
    _setupRoom();
  }

  void _setupRoom() async {
    try {
      String? token =
        await GetTokenFromServer('http://localhost:3000/getToken').call() ?? '';
      await room.connect(
        WebSocketConfig.serverUrl,
        token,    
      );

      await room.localParticipant?.setCameraEnabled(true);
      await room.localParticipant?.setMicrophoneEnabled(true);

      localVideoTrack = await LocalVideoTrack.createCameraTrack();
      
      if (localVideoTrack != null) {
        await room.localParticipant?.publishVideoTrack(localVideoTrack!);
        setState(() {});
      }
    } catch (error) {
      debugPrint('Error connecting to room: $error');
    }
  }

  @override
  void dispose() {
    room.dispose();
    localVideoTrack?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Host Live Stream'),
      ),
      child: Center(
        child: localVideoTrack != null
            ? VideoTrackRenderer(localVideoTrack!, fit: VideoViewFit.cover)
            : const CupertinoActivityIndicator(),
      ),
    );
  }
}