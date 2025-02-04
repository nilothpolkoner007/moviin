/*
  # Add Anime Table and Update Users

  1. New Tables
    - `anime`
      - `id` (uuid, primary key)
      - `title` (text)
      - `description` (text)
      - `genre` (text)
      - `episodes` (integer)
      - `season` (text)
      - `video_url` (text)
      - `thumbnail_url` (text)
      - `created_at` (timestamp)

  2. Updates
    - Add new columns to users table
      - `name` (text)
      - `email` (text, unique)
      - `password` (text)
      - `age` (integer)
      - `user_type` (text)

  3. Security
    - Enable RLS on anime table
    - Add policies for authenticated users
*/

-- Anime table
CREATE TABLE IF NOT EXISTS anime (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  genre text,
  episodes integer,
  season text,
  video_url text,
  thumbnail_url text,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE anime ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read anime"
  ON anime
  FOR SELECT
  TO authenticated
  USING (true);

-- Add new columns to users table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'users' AND column_name = 'name'
  ) THEN
    ALTER TABLE users 
      ADD COLUMN name text,
      ADD COLUMN email text UNIQUE,
      ADD COLUMN password text,
      ADD COLUMN age integer,
      ADD COLUMN user_type text;
  END IF;
END $$;