import { useState } from "react"

export default function NoteForm({ onAdd }) {
  const [title, setTitle] = useState("")
  const [content, setContent] = useState("")
  const [err, setErr] = useState("")

  const submit = async () => {
    if (!title.trim() || !content.trim()) {
      setErr("Both fields are required")
      return
    }
    setErr("")
    await onAdd(title.trim(), content.trim())
    setTitle("")
    setContent("")
  }

  return (
    <div className="note-form">
      {err && <p className="form-error">{err}</p>}
      <input
        id="note-title-input"
        value={title}
        onChange={e => setTitle(e.target.value)}
        placeholder="Title"
      />
      <textarea
        id="note-content-input"
        value={content}
        onChange={e => setContent(e.target.value)}
        placeholder="Content"
        rows={3}
      />
      <button id="add-note-btn" onClick={submit}>Add Note</button>
    </div>
  )
}
