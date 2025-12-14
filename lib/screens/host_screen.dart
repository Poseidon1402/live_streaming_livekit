import 'package:flutter/cupertino.dart';
import 'package:livekit_client/livekit_client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final roomOptions = RoomOptions(adaptiveStream: true, dynacast: true);
  LocalVideoTrack? localVideoTrack;
  static const url = "wss://livestream-q5sk4tqa.livekit.cloud";
  static const token =
      "eyJhbGciOiJIUzI1NiJ9.eyJ2aWRlbyI6eyJyb29tSm9pbiI6dHJ1ZSwicm9vbSI6InF1aWNrc3RhcnQtcm9vbSJ9LCJpc3MiOiJBUElqRERTNUJ0azNLaksiLCJleHAiOjE3NjU2NDMyNTcsIm5iZiI6MCwic3ViIjoicXVpY2tzdGFydC11c2VybmFtZSJ9.82uA9JvoBMygNg9gH0v5k91JCg2f9hrT5yhDefoiOGA";

  final room = Room();

  @override
  void initState() {
    room
        .connect(url, token, roomOptions: roomOptions)
        .then((_) async {
          await room.localParticipant?.setCameraEnabled(true);
          await room.localParticipant?.setMicrophoneEnabled(true);
          LocalVideoTrack.createCameraTrack().then(
            (track) => setState(() => localVideoTrack = track),
          );
          // await room.localParticipant?.publishTrack(localVideoTrack);
        })
        .catchError((error) {
          // Handle connection error
          debugPrint('Error connecting to room: $error');
        });
    super.initState();
  }

  @override
  void dispose() {
    // Release resources
    room.dispose();
    localVideoTrack?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Home Screen')),
      child: Visibility(
        visible: localVideoTrack != null,
        child: localVideoTrack != null
            ? VideoTrackRenderer(localVideoTrack!, fit: VideoViewFit.cover)
            : Center(child: CupertinoActivityIndicator()),
      ),
    );
  }
}
