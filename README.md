# 📝 Real-time Notes App

A real-time collaborative notes application built with the **MERN stack** (MongoDB, Express, React, Node.js) and **Socket.IO**. Multiple browser tabs or users on the same network see notes appear and disappear live without refreshing.

---

## 🎯 Features

| Feature | Description |
|---|---|
| **Create Notes** | Add notes with title and content |
| **Delete Notes** | Remove notes with a single click |
| **Real-time Sync** | Socket.IO broadcasts changes to all connected clients instantly |
| **Search** | Filter notes by title/content with 500ms debounce and MongoDB regex |
| **Validation** | Client-side and server-side validation for empty fields |
| **Timestamps** | Each note displays its creation timestamp |
| **Loading & Error States** | Visual feedback during API calls and on failures |

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Frontend | React 19, Vite, Axios |
| Backend | Node.js, Express |
| Database | MongoDB, Mongoose |
| Real-time | Socket.IO |
| Styling | Vanilla CSS (dark glassmorphism theme) |

---

## 📁 Project Structure

```
notes-app-real-time/
├── server/
│   ├── models/
│   │   └── note.js              # Mongoose schema (title, content, createdAt)
│   ├── routes/
│   │   └── notes.js             # POST / GET / DELETE routes (takes io as param)
│   ├── index.js                 # Express + HTTP server + Socket.IO + Mongoose
│   ├── .env                     # PORT, MONGO_URI
│   └── package.json
├── client/
│   ├── src/
│   │   ├── api/
│   │   │   └── notes.js         # Axios instance + API functions
│   │   ├── hooks/
│   │   │   ├── useSocket.js     # Singleton socket + event subscription hook
│   │   │   └── useNotes.js      # All notes state, logic, socket listeners
│   │   ├── components/
│   │   │   ├── NoteForm.jsx     # Controlled inputs + validation
│   │   │   ├── SearchBar.jsx    # Search input
│   │   │   └── NoteCard.jsx     # Note display + delete + timestamp
│   │   ├── App.jsx              # Root component
│   │   ├── main.jsx             # Entry point
│   │   └── index.css            # Premium dark theme CSS
│   ├── index.html
│   ├── vite.config.js
│   └── package.json
├── run.sh                       # One-command startup (Linux/macOS)
├── run.ps1                      # One-command startup (Windows PowerShell)
├── .gitignore
└── README.md
```

---

## 🚀 Quick Start

### Prerequisites

- [Node.js](https://nodejs.org/) (v18+)
- [MongoDB](https://www.mongodb.com/) running locally on port `27017`

### Option 1: Run Script (Recommended)

**Linux / macOS:**
```bash
chmod +x run.sh
./run.sh
```

**Windows (PowerShell):**
```powershell
.\run.ps1
```

The script will:
1. Install dependencies for both server and client
2. Start the backend on `http://localhost:5000`
3. Start the frontend on `http://localhost:5173`

### Option 2: Manual Setup

```bash
# Terminal 1 — Backend
cd server
npm install
npm run dev

# Terminal 2 — Frontend
cd client
npm install
npm run dev
```

### Open the App

Navigate to **http://localhost:5173** in your browser. Open multiple tabs to see real-time sync in action.

---

## 📡 API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/notes` | Create a new note `{ title, content }` |
| `GET` | `/notes` | Fetch all notes (sorted by newest first) |
| `GET` | `/notes?search=keyword` | Search notes by title/content (regex, case-insensitive) |
| `DELETE` | `/notes/:id` | Delete a note by ID |

### Socket.IO Events

| Event | Direction | Payload |
|---|---|---|
| `noteAdded` | Server → Client | Full note object |
| `noteDeleted` | Server → Client | Note ID (string) |

---

## 🏗️ Architecture Decisions

| Decision | Why |
|---|---|
| `http.createServer(app)` instead of `app.listen` | Required for Socket.IO to attach to the same HTTP server |
| Routes accept `io` as a parameter | Avoids circular dependency issues as the project grows |
| `useRef` for socket event handlers | Prevents stale closures without re-registering socket listeners every render |
| Inline `setTimeout/clearTimeout` debounce | 3 lines of code — no reason to pull in lodash for this |
| Validation on both client and server | Defense-in-depth; client for UX, server for data integrity |
| Singleton socket in `useSocket.js` | One connection shared across all components, not one per hook call |

---

## 🔧 Environment Variables

Create `server/.env`:

```env
PORT=5000
MONGO_URI=mongodb://localhost:27017/notesapp
```

---

## 📌 What's Deliberately Left Out

These are intentionally excluded to keep scope tight:

- **Authentication** — Would add JWT middleware on routes + socket handshake auth
- **Edit functionality** — Would need PUT route + editable card state
- **Pagination** — GET route is already structured to extend with skip/limit
- **Error boundaries** — Would add in production for graceful error handling

---

## 📄 License

MIT
