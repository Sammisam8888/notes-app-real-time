const express = require("express")
const http = require("http")
const { Server } = require("socket.io")
const mongoose = require("mongoose")
const cors = require("cors")
require("dotenv").config()

const app = express()
const server = http.createServer(app)
const io = new Server(server, {
  cors: { origin: "http://localhost:5173", methods: ["GET", "POST", "DELETE"] }
})

app.use(cors({ origin: "http://localhost:5173" }))
app.use(express.json())

mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log("mongo connected"))
  .catch(err => console.error(err))

app.use("/notes", require("./routes/notes")(io))

io.on("connection", (socket) => {
  console.log("client connected:", socket.id)
  socket.on("disconnect", () => console.log("client left:", socket.id))
})

server.listen(process.env.PORT, () => {
  console.log(`server on ${process.env.PORT}`)
})
