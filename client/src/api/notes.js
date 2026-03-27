import axios from "axios"

const api = axios.create({ baseURL: "http://localhost:5000" })

export const fetchNotes = (search = "") =>
    api.get("/notes", { params: search ? { search } : {} })

export const createNote = (data) => api.post("/notes", data)

export const deleteNote = (id) => api.delete(`/notes/${id}`)
