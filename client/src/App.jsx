import { useNotes } from "./hooks/useNotes"
import NoteForm from "./components/NoteForm"
import NoteCard from "./components/NoteCard"
import SearchBar from "./components/SearchBar"

export default function App() {
  const { notes, loading, error, search, setSearch, add, remove } = useNotes()

  return (
    <div className="container">
      <h1>Notes</h1>
      <NoteForm onAdd={add} />
      <SearchBar value={search} onChange={setSearch} />
      {error && <p className="error">{error}</p>}
      {loading && <p className="loading">Loading...</p>}
      <div className="notes-grid">
        {notes.map(note => (
          <NoteCard key={note._id} note={note} onDelete={remove} />
        ))}
      </div>
    </div>
  )
}
