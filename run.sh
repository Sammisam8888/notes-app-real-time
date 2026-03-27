#!/usr/bin/env bash

# ─────────────────────────────────────────────────────────
# run.sh — Start the Real-time Notes App (Linux / macOS)
# ─────────────────────────────────────────────────────────

set -e

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVER_DIR="$ROOT_DIR/server"
CLIENT_DIR="$ROOT_DIR/client"

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}═══════════════════════════════════════════${NC}"
echo -e "${CYAN}   📝 Real-time Notes App — Starting...   ${NC}"
echo -e "${CYAN}═══════════════════════════════════════════${NC}"
echo ""

# ── Check prerequisites ──────────────────────────────────
command -v node >/dev/null 2>&1 || { echo -e "${RED}✗ Node.js is not installed. Install it from https://nodejs.org${NC}"; exit 1; }
command -v npm >/dev/null 2>&1 || { echo -e "${RED}✗ npm is not installed.${NC}"; exit 1; }

# Check MongoDB
if command -v mongosh >/dev/null 2>&1; then
    mongosh --eval "db.runCommand({ping:1})" --quiet >/dev/null 2>&1 || {
        echo -e "${RED}✗ MongoDB is not running. Start it with: sudo systemctl start mongod${NC}"
        exit 1
    }
elif command -v mongo >/dev/null 2>&1; then
    mongo --eval "db.runCommand({ping:1})" --quiet >/dev/null 2>&1 || {
        echo -e "${RED}✗ MongoDB is not running. Start it with: sudo systemctl start mongod${NC}"
        exit 1
    }
else
    echo -e "${CYAN}⚠  mongosh/mongo CLI not found — assuming MongoDB is running on localhost:27017${NC}"
fi

echo -e "${GREEN}✓ Prerequisites OK${NC}"
echo ""

# ── Install dependencies ─────────────────────────────────
echo -e "${CYAN}→ Installing server dependencies...${NC}"
cd "$SERVER_DIR" && npm install --silent

echo -e "${CYAN}→ Installing client dependencies...${NC}"
cd "$CLIENT_DIR" && npm install --silent

echo -e "${GREEN}✓ Dependencies installed${NC}"
echo ""

# ── Start servers ────────────────────────────────────────
echo -e "${CYAN}→ Starting backend on http://localhost:5000${NC}"
cd "$SERVER_DIR" && npm run dev &
SERVER_PID=$!

echo -e "${CYAN}→ Starting frontend on http://localhost:5173${NC}"
cd "$CLIENT_DIR" && npm run dev &
CLIENT_PID=$!

echo ""
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}   ✓ App is running!                      ${NC}"
echo -e "${GREEN}   Frontend: http://localhost:5173         ${NC}"
echo -e "${GREEN}   Backend:  http://localhost:5000         ${NC}"
echo -e "${GREEN}   Press Ctrl+C to stop both servers      ${NC}"
echo -e "${GREEN}═══════════════════════════════════════════${NC}"

# ── Cleanup on exit ──────────────────────────────────────
cleanup() {
    echo ""
    echo -e "${CYAN}Shutting down...${NC}"
    kill $SERVER_PID 2>/dev/null
    kill $CLIENT_PID 2>/dev/null
    wait $SERVER_PID 2>/dev/null
    wait $CLIENT_PID 2>/dev/null
    echo -e "${GREEN}✓ Stopped${NC}"
}

trap cleanup EXIT INT TERM
wait
