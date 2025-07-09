const express = require('express');
const cors = require('cors');
const app = express();
const port = 3000;

// Hypothetical ElevenLabs SDK (replace with actual API)
const { ElevenLabs } = require('elevenlabs-js');

app.use(cors());
app.use(express.json());

// Quiz scoring endpoint
app.post('/api/quiz/score', (req, res) => {
  try {
    const { answers } = req.body;
    if (!answers || typeof answers !== 'object') {
      return res.status(400).json({ error: 'Invalid answers format' });
    }

    const correctAnswers = {
      0: 'Innovation',
      1: 'Trust',
    };
    let score = 0;
    Object.keys(answers).forEach((qIndex) => {
      if (answers[qIndex] === correctAnswers[qIndex]) score++;
    });
    res.json({ score, total: Object.keys(correctAnswers).length });
  } catch (error) {
    console.error('Quiz scoring error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// ElevenLabs text-to-speech endpoint
app.post('/api/elevenlabs/tts', async (req, res) => {
  try {
    const { text, voiceId } = req.body;
    if (!text || !voiceId) {
      return res.status(400).json({ error: 'Missing text or voiceId' });
    }

    const audio = await ElevenLabs.textToSpeech({
      text,
      voiceId,
      apiKey: process.env.ELEVENLABS_API_KEY,
    });

    res.json({ url: audio.url });
  } catch (error) {
    console.error('ElevenLabs error:', error);
    res.status(500).json({ error: 'Failed to generate audio' });
  }
});

app.listen(port, () => {
  console.log(`Backend running at http://localhost:${port}`);
});
