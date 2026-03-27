import { useState, useEffect, useCallback } from "react"
import { fetchNotes, createNote, deleteNote } from "../api/notes"
import { useSocket } from "./useSocket"

export const useNotes = () => {
    const [notes, setNotes] = useState([])
    const [loading, setLoading] = useState(false)
    const [error, setError] = useState("")
    const [search, setSearch] = useState("")

    const load = useCallback(async (query = "") => {
        setLoading(true)
        setError("")
        try {
            const res = await fetchNotes(query)
            setNotes(res.data)
        } catch {
            setError("Failed to fetch notes")
        } finally {
            setLoading(false)
        }
    }, [])

    useEffect(() => {
        load()
    }, [load])

    useEffect(() => {
        const timer = setTimeout(() => load(search), 500)
        return () => clearTimeout(timer)
    }, [search, load])

    useSocket("noteAdded", (note) => {
        setNotes(prev => [note, ...prev])
    })

    useSocket("noteDeleted", (id) => {
        setNotes(prev => prev.filter(n => n._id !== id))
    })

    const add = async (title, content) => {
        await createNote({ title, content })
    }

    const remove = async (id) => {
        await deleteNote(id)
    }

    return { notes, loading, error, search, setSearch, add, remove }
}
