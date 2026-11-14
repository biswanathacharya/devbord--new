#!/bin/bash

# DevBoard Frontend - Docker Build and Run Script
# This script builds and runs the containerized frontend application

set -e  # Exit on error

echo "🐳 DevBoard Frontend - Docker Build & Run"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Build the image
echo -e "\n${YELLOW}Building Docker image...${NC}"
docker build -t devboard-frontend:latest .
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Build successful${NC}"
else
    echo -e "${RED}✗ Build failed${NC}"
    exit 1
fi

# Stop any existing containers
echo -e "\n${YELLOW}Checking for existing containers...${NC}"
CONTAINER_ID=$(docker ps -q -f "ancestor=devboard-frontend:latest" 2>/dev/null || true)
if [ ! -z "$CONTAINER_ID" ]; then
    echo -e "${YELLOW}Stopping existing container: $CONTAINER_ID${NC}"
    docker stop "$CONTAINER_ID" > /dev/null
    sleep 1
fi

# Run the container
echo -e "\n${YELLOW}Starting container...${NC}"
docker run -d \
    --name devboard-frontend \
    -p 4173:4173 \
    --restart unless-stopped \
    devboard-frontend:latest

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Container started successfully${NC}"
    echo -e "\n${GREEN}=========================================="
    echo "Container Details:"
    echo "=========================================="
    echo "Name:     devboard-frontend"
    echo "Image:    devboard-frontend:latest"
    echo "Port:     http://localhost:4173"
    echo "Status:   Running"
    echo -e "==========================================${NC}\n"
    
    # Wait a moment and check status
    sleep 2
    docker ps -f "name=devboard-frontend"
    
    echo -e "\n${GREEN}✓ Frontend is ready at: http://localhost:4173${NC}"
else
    echo -e "${RED}✗ Failed to start container${NC}"
    exit 1
fi
