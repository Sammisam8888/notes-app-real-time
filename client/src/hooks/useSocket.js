import { useEffect, useRef } from "react"
import { io } from "socket.io-client"

const BACKEND_BASE_URL = process.env.BACKEND_BASE_URL || "http://localhost:5000"
const socket = io(BACKEND_BASE_URL, { autoConnect: true })

export const useSocket = (event, handler) => {
  const savedHandler = useRef(handler)

  useEffect(() => {
    savedHandler.current = handler
  }, [handler])

  useEffect(() => {
    const listener = (...args) => savedHandler.current(...args)
    socket.on(event, listener)
    return () => socket.off(event, listener)
  }, [event])

  return socket
}
