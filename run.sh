#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "$0")" && pwd)"

command -v node >/dev/null 2>&1 || { echo "node not found"; exit 1; }
command -v npm >/dev/null 2>&1 || { echo "npm not found"; exit 1; }

if command -v mongosh >/dev/null 2>&1; then
    mongosh --eval "db.runCommand({ping:1})" --quiet >/dev/null 2>&1 || { echo "mongo not running"; exit 1; }
elif command -v mongo >/dev/null 2>&1; then
    mongo --eval "db.runCommand({ping:1})" --quiet >/dev/null 2>&1 || { echo "mongo not running"; exit 1; }
fi

echo "installing deps..."
cd "$ROOT/server" && npm install --silent
cd "$ROOT/client" && npm install --silent

echo "starting backend..."
cd "$ROOT/server" && npm run dev &
SPID=$!

echo "starting frontend..."
cd "$ROOT/client" && npm run dev &
CPID=$!

echo ""
echo "backend  -> http://localhost:5000"
echo "frontend -> http://localhost:5173"
echo "ctrl+c to stop"

cleanup() {
    kill $SPID $CPID 2>/dev/null
    wait $SPID $CPID 2>/dev/null
}

trap cleanup EXIT INT TERM
wait
