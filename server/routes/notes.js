const express = require("express")
const Note = require("../models/note")

const router = express.Router()

module.exports = (io) => {

  router.post("/", async (req, res) => {
    const { title, content } = req.body
    if (!title?.trim() || !content?.trim()) {
      return res.status(400).json({ error: "Title and content are required" })
    }
    const note = await Note.create({ title, content })
    io.emit("noteAdded", note)
    res.status(201).json(note)
  })

  router.get("/", async (req, res) => {
    const { search } = req.query
    const filter = search
      ? {
          $or: [
            { title: { $regex: search, $options: "i" } },
            { content: { $regex: search, $options: "i" } }
          ]
        }
      : {}
    const notes = await Note.find(filter).sort({ createdAt: -1 })
    res.json(notes)
  })

  router.delete("/:id", async (req, res) => {
    const note = await Note.findByIdAndDelete(req.params.id)
    if (!note) return res.status(404).json({ error: "Note not found" })
    io.emit("noteDeleted", req.params.id)
    res.json({ id: req.params.id })
  })

  return router
}
