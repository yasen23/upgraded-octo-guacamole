CREATE TABLE users (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  email TEXT NOT NULL,
  username TEXT NOT NULL,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  location TEXT
);

CREATE TABLE promises (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  status INTEGER NOT NULL,
  title TEXT NOT NULL,
  body TEXT,
  completed_reference TEXT,
  user_id INTEGER NOT NULL, 
  FOREIGN KEY(user_id) REFERENCES users(id)
);
