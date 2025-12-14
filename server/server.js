// server.js
import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import { AccessToken } from 'livekit-server-sdk';

// Fix CORS issues

const createToken = async () => {
  // If this room doesn't exist, it'll be automatically created when the first
  // participant joins
  const roomName = 'quickstart-room';
  // Identifier to be used for participant.
  // It's available as LocalParticipant.identity with livekit-client SDK

  const at = new AccessToken(process.env.LIVEKIT_API_KEY, process.env.LIVEKIT_API_SECRET, {
    identity: `${Date.now()}`, // Let JS side assign a random identity using datetime
    // Token to expire after 100 minutes
    ttl: '100m',
  });
  at.addGrant({ roomJoin: true, room: roomName, canPublish: true, });

  return await at.toJwt();
};

const app = express();
const port = 3000;

app.use(cors({
  origin: '*',  // Allow all origins
  methods: ['GET', 'POST'],
}));

app.get('/getToken', async (req, res) => {
  res.send(await createToken());
});

app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});