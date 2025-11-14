/*
  # Create users management table

  1. New Tables
    - `app_users`
      - `id` (uuid, primary key)
      - `username` (text, unique) - Username for login
      - `password_hash` (text) - Hashed password
      - `display_name` (text) - Display name for the user
      - `role` (text) - User role (admin or employee)
      - `is_active` (boolean) - Whether the user is active
      - `created_at` (timestamptz) - When the user was created
      - `updated_at` (timestamptz) - Last update timestamp
      
  2. Security
    - Enable RLS on `app_users` table
    - Add policy for authenticated users to read their own data
    - Add policy for admin users to manage all users
    
  3. Important Notes
    - Passwords will be hashed on the client side before storing
    - Only admin users can create, edit, or delete users
    - All users can read their own information
*/

CREATE TABLE IF NOT EXISTS app_users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  username text UNIQUE NOT NULL,
  password_hash text NOT NULL,
  display_name text NOT NULL,
  role text NOT NULL CHECK (role IN ('admin', 'employee')),
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE app_users ENABLE ROW LEVEL SECURITY;

-- Policy for users to read their own data
CREATE POLICY "Users can read own data"
  ON app_users
  FOR SELECT
  TO authenticated
  USING (username = current_setting('app.current_user', true));

-- Policy for admin users to read all users
CREATE POLICY "Admins can read all users"
  ON app_users
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM app_users
      WHERE username = current_setting('app.current_user', true)
      AND role = 'admin'
    )
  );

-- Policy for admin users to insert new users
CREATE POLICY "Admins can insert users"
  ON app_users
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM app_users
      WHERE username = current_setting('app.current_user', true)
      AND role = 'admin'
    )
  );

-- Policy for admin users to update users
CREATE POLICY "Admins can update users"
  ON app_users
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM app_users
      WHERE username = current_setting('app.current_user', true)
      AND role = 'admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM app_users
      WHERE username = current_setting('app.current_user', true)
      AND role = 'admin'
    )
  );

-- Policy for admin users to delete users
CREATE POLICY "Admins can delete users"
  ON app_users
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM app_users
      WHERE username = current_setting('app.current_user', true)
      AND role = 'admin'
    )
  );

-- Insert default users
INSERT INTO app_users (username, password_hash, display_name, role, is_active)
VALUES 
  ('admin', 'paradero', 'Administrador', 'admin', true),
  ('empleado', 'paradero', 'Empleado', 'employee', true)
ON CONFLICT (username) DO NOTHING;