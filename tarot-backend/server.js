const express = require('express');
const cors = require('cors');
const { GoogleGenerativeAI } = require('@google/generative-ai');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Initialize Gemini API
// Replace 'YOUR_API_KEY' with your actual Gemini API key
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || 'YOUR_API_KEY');

// Tarot reading endpoint
app.post('/api/tarot', async(req, res) => {
    try {
        const { question, spread, cards } = req.body;

        if (!question || !cards || !Array.isArray(cards)) {
            return res.status(400).json({ error: 'Question and cards are required' });
        }

        // Initialize the model
        const model = genAI.getGenerativeModel({ model: 'gemini-pro' });

        // Build spread-specific positions
        const spreadPositions = getSpreadPositions(spread, cards);

        // Create a tarot-themed prompt
        const prompt = `You are a mystical tarot card reader with deep insight and wisdom. 

A person has asked you: "${question}"

They have drawn the following cards in a ${spread || 'tarot'} spread:
${spreadPositions}

Provide a comprehensive tarot reading that:
1. Interprets each card in its specific position
2. Explains the card's traditional meaning
3. Relates the card's energy to their question
4. Weaves all the cards together into a cohesive narrative
5. Offers practical guidance and wisdom
6. Maintains a mystical, insightful, and compassionate tone

Structure your response with clear sections for each card position, then provide an overall synthesis and guidance.`;

        // Generate response
        const result = await model.generateContent(prompt);
        const response = await result.response;
        const text = response.text();

        res.json({ response: text });
    } catch (error) {
        console.error('Error calling Gemini API:', error);
        res.status(500).json({
            error: 'Failed to generate tarot reading',
            details: error.message
        });
    }
});

// Helper function to format card positions based on spread type
function getSpreadPositions(spread, cards) {
    const positions = {
        singleCard: ['Card: '],
        threeCard: ['Past: ', 'Present: ', 'Future: '],
        love: [
            'You: ',
            'Your Partner/Potential Partner: ',
            'The Relationship: ',
            'Guidance: '
        ],
        celticCross: [
            'Present Situation: ',
            'Challenge: ',
            'Past: ',
            'Future: ',
            'Above (Goal/Aspiration): ',
            'Below (Foundation): ',
            'Advice: ',
            'External Influences: ',
            'Hopes and Fears: ',
            'Outcome: '
        ]
    };

    const spreadPositions = positions[spread] || positions.threeCard;

    return cards
        .map((card, index) => `${spreadPositions[index] || `Card ${index + 1}: `}${card}`)
    .join('\n');
}

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'ok', message: 'Tarot backend is running' });
});

app.listen(PORT, () => {
  console.log(`🔮 Tarot backend server running on port ${PORT}`);
  console.log(`API endpoint: http://localhost:${PORT}/api/tarot`);
});