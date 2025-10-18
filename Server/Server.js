// server.js
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const nodemailer = require('nodemailer');
const session = require('express-session');
const { createClient } = require('@supabase/supabase-js');
const { MongoClient } = require('mongodb');
const bcrypt = require('bcrypt');
require('dotenv').config();

const app = express();
const port = 3000;

// ─────────────────────────────────────────────────────
// Initialize Supabase
const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_ANON_KEY);

// ─────────────────────────────────────────────────────
// MongoDB Connection
let mongoDb;
MongoClient.connect(process.env.MONGODB_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(client => {
    mongoDb = client.db(); // Default DB from connection string
    console.log('✅ MongoDB connected successfully');
  })
  .catch(err => {
    console.error('❌ MongoDB connection error:', err.message);
    process.exit(1); // Exit on failure
  });

// ─────────────────────────────────────────────────────
// Middleware
app.set('trust proxy', 1);

const allowedOrigins = [
  'http://127.0.0.1:5501',
  'http://localhost:5501',
  'http://localhost:3000',
  'http://127.0.0.1:5500',
  'http://localhost:5500',
];

app.use(cors({
  origin: function (origin, callback) {
    if (!origin || allowedOrigins.includes(origin)) return callback(null, true);
    return callback(new Error('Not allowed by CORS'));
  },
  credentials: true,
}));

app.use(express.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use(session({
  secret: process.env.SESSION_SECRET || 'secret',
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: false,
    maxAge: 24 * 60 * 60 * 1000,
    sameSite: 'lax',
    httpOnly: true,
  },
  name: 'sessionId',
}));

// ─────────────────────────────────────────────────────
// Debug Sessions
app.use((req, res, next) => {
  console.log('Session:', req.sessionID);
  next();
});

// ─────────────────────────────────────────────────────
// Register Route
app.post('/register', async (req, res) => {
  const { name, surname, email, password, age, gender, phone, country, marital_status, next_of_kin } = req.body;

  if (!name || !surname || !email || !password) {
    return res.status(400).json({ message: 'Please fill all required fields.' });
  }

  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    return res.status(400).json({ message: 'Invalid email format.' });
  }

  if (password.length < 6) {
    return res.status(400).json({ message: 'Password too short.' });
  }

  try {
    // Supabase Auth
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: { name, surname },
      },
    });

    if (error || !data?.user) {
      console.error('Supabase signup error:', error);
      return res.status(500).json({ message: error?.message || 'Supabase error' });
    }

    // MongoDB User Insert
    const usersCollection = mongoDb.collection('users');
    const existing = await usersCollection.findOne({ email });

    if (existing) {
      return res.status(400).json({ message: 'Email already exists in MongoDB.' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    await usersCollection.insertOne({
      name,
      surname,
      email,
      password: hashedPassword,
      age: age || null,
      gender: gender || null,
      phone: phone || null,
      country: country || null,
      marital_status: marital_status || null,
      next_of_kin: next_of_kin || null,
      user_id: data.user.id,
      created_at: new Date(),
    });

    res.status(200).json({ message: 'Registration successful. Check your email.' });
  } catch (err) {
    console.error('Registration error:', err);
    res.status(500).json({ message: 'Registration failed due to network error.', error: err.message });
  }
});

// ─────────────────────────────────────────────────────
// Login Route
app.post('/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    const { data: authData, error: authError } = await supabase.auth.signInWithPassword({ email, password });

    if (authError || !authData?.session) {
      return res.status(401).json({ message: 'Invalid credentials.' });
    }

    const userData = await mongoDb.collection('users').findOne({ user_id: authData.user.id });

    if (!userData) {
      return res.status(404).json({ message: 'User profile not found.' });
    }

    req.session.userId = authData.user.id;
    req.session.userEmail = email;
    req.session.userData = userData;

    res.status(200).json({
      message: 'Login successful',
      user: {
        ...authData.user,
        profile: userData,
      },
    });
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ message: 'Login failed due to server error.' });
  }
});

// ─────────────────────────────────────────────────────
// Email Transport
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.GMAIL_USER,
    pass: process.env.GMAIL_PASS,
  },
});

transporter.verify((error, success) => {
  if (error) console.error('Email error:', error);
  else console.log('✅ Email transporter ready');
});

// ─────────────────────────────────────────────────────
// Server Start
app.listen(port, () => {
  console.log(`🚀 Server running at http://localhost:${port}`);
  console.log('🔐 Env loaded:', {
    SUPABASE_URL: process.env.SUPABASE_URL ? '✔️' : '❌',
    SUPABASE_ANON_KEY: process.env.SUPABASE_ANON_KEY ? '✔️' : '❌',
    MONGODB_URI: process.env.MONGODB_URI ? '✔️' : '❌',
    GMAIL_USER: process.env.GMAIL_USER ? '✔️' : '❌',
  });
});
