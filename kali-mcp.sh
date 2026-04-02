#!/bin/bash
# kali-mcp.sh — Start/Stop Kali MCP Server on-demand

DIR="$(cd "$(dirname "$0")" && pwd)"

case "${1:-start}" in
  start)
    echo "Starting Kali MCP Server..."
    docker compose -f "$DIR/docker-compose.yml" up -d --build
    echo "Waiting for server..."
    for i in {1..15}; do
      if curl -s http://127.0.0.1:5050/ >/dev/null 2>&1; then
        echo "Kali MCP Server ready at http://127.0.0.1:5050"
        exit 0
      fi
      sleep 2
    done
    echo "Server started but may still be initializing. Check: docker logs kali-mcp-server"
    ;;
  stop)
    echo "Stopping Kali MCP Server..."
    docker compose -f "$DIR/docker-compose.yml" down
    echo "Stopped."
    ;;
  status)
    docker compose -f "$DIR/docker-compose.yml" ps
    ;;
  logs)
    docker compose -f "$DIR/docker-compose.yml" logs -f
    ;;
  *)
    echo "Usage: kali-mcp.sh {start|stop|status|logs}"
    exit 1
    ;;
esac
