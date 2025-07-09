import React, { useState, useContext } from 'react';
import { SiteModeContext } from '../context/SiteModeContext';

const KoTeChat = () => {
  const { isEmployeeMode } = useContext(SiteModeContext);
  const [message, setMessage] = useState('');
  const [response, setResponse] = useState('');

  const voiceId = isEmployeeMode ? 'friendly-voice-id' : 'professional-voice-id';

  const sendMessage = async () => {
    try {
      const res = await fetch('/api/elevenlabs/tts', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ text: message, voiceId }),
      });
      const data = await res.json();
      if (data.error) throw new Error(data.error);
      setResponse(data.url);
    } catch (error) {
      console.error('Chat error:', error);
      setResponse('');
    }
  };

  return (
    <div className="p-4 bg-smrt-green-100 rounded-lg">
      <h2 className="text-xl font-bold">Chat with KoTe</h2>
      <input
        type="text"
        value={message}
        onChange={(e) => setMessage(e.target.value)}
        className="p-2 w-full mt-2 rounded"
        placeholder="Ask KoTe anything..."
      />
      <button onClick={sendMessage} className="p-2 mt-2 bg-smrt-green-600 text-white rounded">
        Send
      </button>
      {response && <audio src={response} controls className="mt-2" />}
    </div>
  );
};

export default KoTeChat;
