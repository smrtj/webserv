import React, { useState, useEffect } from 'react';

const quizQuestions = [
  {
    question: 'What is SMRT\u2019s core value?',
    options: ['Innovation', 'Profit', 'Speed'],
    correct: 'Innovation',
  },
  {
    question: 'What builds reliable solutions?',
    options: ['Speed', 'Trust', 'Fun'],
    correct: 'Trust',
  },
];

const Quiz = ({ setIsLoading, setError }) => {
  const [answers, setAnswers] = useState({});
  const [score, setScore] = useState(null);

  useEffect(() => {
    setIsLoading(true);
    setTimeout(() => {
      setIsLoading(false);
    }, 500);
  }, [setIsLoading]);

  const handleAnswer = (questionIndex, option) => {
    setAnswers({ ...answers, [questionIndex]: option });
  };

  const submitQuiz = async () => {
    try {
      const res = await fetch('/api/quiz/score', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ answers }),
      });
      const data = await res.json();
      if (data.error) throw new Error(data.error);
      setScore(data.score);
    } catch (error) {
      setError(error.message);
    }
  };

  return (
    <div className="mt-4 p-4 bg-white rounded-lg shadow">
      {quizQuestions.map((q, i) => (
        <div key={i} className="mb-4">
          <p className="font-bold">{q.question}</p>
          {q.options.map((option, j) => (
            <button
              key={j}
              onClick={() => handleAnswer(i, option)}
              className={`p-2 m-1 rounded ${answers[i] === option ? 'bg-smrt-green-600 text-white' : 'bg-gray-200'}`}
            >
              {option}
            </button>
          ))}
        </div>
      ))}
      <button onClick={submitQuiz} className="p-2 bg-smrt-green-600 text-white rounded">
        Submit Quiz
      </button>
      {score !== null && (
        <p className="mt-2">Your score: {score}/{quizQuestions.length}</p>
      )}
    </div>
  );
};

export default Quiz;
