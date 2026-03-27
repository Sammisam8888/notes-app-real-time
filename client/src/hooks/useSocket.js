import { useEffect, useRef } from "react"
import { io } from "socket.io-client"

const socket = io("http://localhost:5000", { autoConnect: true })

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
