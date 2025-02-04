import express from 'express';
import TelegramBot from 'node-telegram-bot-api';
import jwt from 'jsonwebtoken';
import { createClient } from '@supabase/supabase-js';
import cors from 'cors';
import dotenv from 'dotenv';
import bcrypt from 'bcryptjs';

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(cors());

// Initialize Supabase client
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_ANON_KEY
);

// Initialize Telegram bot
const bot = new TelegramBot(process.env.TELEGRAM_BOT_TOKEN, { polling: true });

// JWT Secret
const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key';

// Helper function to generate JWT
const generateToken = (userId) => {
  return jwt.sign({ id: userId }, JWT_SECRET, { expiresIn: '24h' });
};

// Authentication middleware
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Access token required' });
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ error: 'Invalid or expired token' });
    }
    req.user = user;
    next();
  });
};

// User Routes
app.post('/api/auth/signup', async (req, res) => {
  const { email, password, name, age, userType } = req.body;

  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    
    const { data: user, error } = await supabase
      .from('users')
      .insert([
        { 
          email,
          password: hashedPassword,
          name,
          age,
          user_type: userType
        }
      ])
      .single();

    if (error) throw error;

    const token = generateToken(user.id);
    res.json({ token });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

app.post('/api/auth/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    const { data: user, error } = await supabase
      .from('users')
      .select('*')
      .eq('email', email)
      .single();

    if (error || !user) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const token = generateToken(user.id);
    res.json({ token });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Content Routes
app.get('/api/movies', authenticateToken, async (req, res) => {
  const { genre, search } = req.query;
  let query = supabase.from('movies').select('*');
  
  if (genre) {
    query = query.eq('genre', genre);
  }
  
  if (search) {
    query = query.ilike('title', `%${search}%`);
  }

  const { data, error } = await query;
  
  if (error) {
    return res.status(500).json({ error: error.message });
  }
  
  res.json(data);
});

app.get('/api/anime', authenticateToken, async (req, res) => {
  const { genre, search } = req.query;
  let query = supabase.from('anime').select('*');
  
  if (genre) {
    query = query.eq('genre', genre);
  }
  
  if (search) {
    query = query.ilike('title', `%${search}%`);
  }

  const { data, error } = await query;
  
  if (error) {
    return res.status(500).json({ error: error.message });
  }
  
  res.json(data);
});

// Dashboard Routes
app.get('/api/dashboard/watchlist', authenticateToken, async (req, res) => {
  const { data, error } = await supabase
    .from('watchlist')
    .select(`
      *,
      movie:movies(*)
    `)
    .eq('user_id', req.user.id);

  if (error) {
    return res.status(500).json({ error: error.message });
  }

  res.json(data);
});

app.post('/api/dashboard/watchlist', authenticateToken, async (req, res) => {
  const { movieId } = req.body;

  const { data, error } = await supabase
    .from('watchlist')
    .insert([
      { user_id: req.user.id, movie_id: movieId }
    ]);

  if (error) {
    return res.status(500).json({ error: error.message });
  }

  res.json(data);
});

// Start server
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});