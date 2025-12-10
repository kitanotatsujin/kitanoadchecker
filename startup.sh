#!/bin/sh

# Railway Startup Script
# This script handles one-time setup and then starts the application

echo "🚀 Starting application..."

# Check if we need to run vector DB setup (one-time only)
# Support both RUN_VECTOR_SETUP and SETUP_VECTOR_DB for compatibility
if [ "$RUN_VECTOR_SETUP" = "true" ] || [ "$SETUP_VECTOR_DB" = "true" ]; then
  echo "📦 Running Vector DB setup (one-time)..."
  echo "   This will populate ChromaDB with knowledge base embeddings."
  echo "   CHROMA_URL: ${CHROMA_URL}"
  echo "   Using internal Railway network for faster connection."

  # Run setup script
  npm run setup:vector-db

  if [ $? -eq 0 ]; then
    echo "✅ Vector DB setup completed successfully!"
    echo "⚠️  IMPORTANT: Remove RUN_VECTOR_SETUP environment variable to prevent re-running on next deployment."
  else
    echo "❌ Vector DB setup failed!"
    echo "⚠️  Application will start anyway, but RAG search will return 0 results."
  fi
else
  echo "ℹ️  Skipping Vector DB setup (RUN_VECTOR_SETUP not set)"
fi

# Start the Next.js application
echo "🎯 Starting Next.js server..."
npm start
