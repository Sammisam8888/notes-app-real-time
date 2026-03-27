# Real-time Notes App

MERN stack notes app with Socket.IO for real-time sync across multiple clients. Add a note in one tab, it shows up in every other tab instantly. Delete it, gone everywhere.

## Stack

- **Backend:** Node.js, Express, MongoDB (Mongoose), Socket.IO
- **Frontend:** React (Vite), Axios, socket.io-client
- **Styling:** Vanilla CSS, dark theme

## How it works

- REST API handles CRUD (`POST /notes`, `GET /notes`, `DELETE /notes/:id`)
- Socket.IO sits on top of the same HTTP server and broadcasts `noteAdded` / `noteDeleted` events to all connected clients
- React hooks (`useSocket`, `useNotes`) manage state and socket subscriptions
- Search uses MongoDB regex with a 500ms debounce on the client side
- Validation runs on both client (NoteForm) and server (POST route)

## Project structure

```
server/
  models/note.js        Mongoose schema
  routes/notes.js       REST routes, takes io as param
  index.js              Entry point
  .env                  Config

client/src/
  api/notes.js          Axios instance
  hooks/useSocket.js    Socket singleton + event hook
  hooks/useNotes.js     State management + socket listeners
  components/
    NoteForm.jsx        Form with validation
    SearchBar.jsx       Search input
    NoteCard.jsx        Card display
  App.jsx               Root component
  index.css             Styles
```

## Setup

**Prerequisites:** Node.js v18+, MongoDB running on localhost:27017

### Quick start (Linux/macOS)

```bash
chmod +x run.sh
./run.sh
```

### Quick start (Windows)

```powershell
.\run.ps1
```

### Manual

```bash
# backend
cd server
npm install
npm run dev

# frontend (separate terminal)
cd client
npm install
npm run dev
```

Open http://localhost:5173. Try it in two tabs side by side.

## API

```
POST   /notes              { title, content } -> 201
GET    /notes              -> all notes, newest first
GET    /notes?search=term  -> filtered by title/content (regex, case-insensitive)
DELETE /notes/:id          -> 200
```

Socket events: `noteAdded` (full note object), `noteDeleted` (note id string).

## Environment

`server/.env`:
```
PORT=5000
MONGO_URI=mongodb://localhost:27017/notesapp
```

## License

MIT
