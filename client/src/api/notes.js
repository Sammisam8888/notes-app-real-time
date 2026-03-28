import axios from "axios"

const BACKEND_BASE_URL = process.env.BACKEND_BASE_URL || "http://localhost:5000"
const api = axios.create({ baseURL: BACKEND_BASE_URL })

export const fetchNotes = (search = "") =>
    api.get("/notes", { params: search ? { search } : {} })

export const createNote = (data) => api.post("/notes", data)

export const deleteNote = (id) => api.delete(`/notes/${id}`)
