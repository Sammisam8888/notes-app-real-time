export default function NoteCard({ note, onDelete }) {
    const formatted = new Date(note.createdAt).toLocaleString("en-IN", {
        dateStyle: "medium",
        timeStyle: "short"
    })

    return (
        <div className="note-card">
            <div className="note-header">
                <h3>{note.title}</h3>
                <button onClick={() => onDelete(note._id)}>Delete</button>
            </div>
            <p>{note.content}</p>
            <span className="note-ts">{formatted}</span>
        </div>
    )
}
