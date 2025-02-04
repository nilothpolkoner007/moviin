/*
  # Initial Schema Setup for StreamFlix

  1. New Tables
    - `users`
      - `id` (uuid, primary key)
      - `telegram_id` (text, unique)
      - `created_at` (timestamp)
    - `otp_codes`
      - `id` (uuid, primary key)
      - `telegram_id` (text)
      - `code` (text)
      - `expires_at` (timestamp)
    - `movies`
      - `id` (uuid, primary key)
      - `title` (text)
      - `description` (text)
      - `genre` (text)
      - `duration` (interval)
      - `release_year` (integer)
      - `video_url` (text)
      - `thumbnail_url` (text)
      - `created_at` (timestamp)
    - `watchlist`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references users)
      - `movie_id` (uuid, references movies)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users
*/

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  telegram_id text UNIQUE NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own data"
  ON users
  FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

-- OTP codes table
CREATE TABLE IF NOT EXISTS otp_codes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  telegram_id text NOT NULL,
  code text NOT NULL,
  expires_at timestamptz NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE otp_codes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Service role can manage OTP codes"
  ON otp_codes
  FOR ALL
  TO service_role
  USING (true);

-- Movies table
CREATE TABLE IF NOT EXISTS movies (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  genre text,
  duration interval,
  release_year integer,
  video_url text,
  thumbnail_url text,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE movies ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read movies"
  ON movies
  FOR SELECT
  TO authenticated
  USING (true);

-- Watchlist table
CREATE TABLE IF NOT EXISTS watchlist (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  movie_id uuid REFERENCES movies(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  UNIQUE(user_id, movie_id)
);

ALTER TABLE watchlist ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage their watchlist"
  ON watchlist
  FOR ALL
  TO authenticated
  USING (auth.uid() = user_id);