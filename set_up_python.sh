#!/bin/bash

# Variables à personnaliser
GITHUB_USER="youruser"
PROJECT_NAME="my_project"

# Repos GitHub
CORE_HELPERS_REPO="https://github.com/$GITHUB_USER/core_helpers.git"
DEV_HELPERS_REPO="https://github.com/$GITHUB_USER/dev_helpers.git"

# Crée la structure
mkdir -p "$PROJECT_NAME/src" "$PROJECT_NAME/tests"
cd "$PROJECT_NAME" || exit

# Fichiers initiaux
touch README.md requirements.txt .gitignore
echo -e ".venv/\n__pycache__/\n*.pyc\ndev_helpers/" > .gitignore

# Environnement virtuel
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip

# Git init + submodule
git init
git submodule add "$CORE_HELPERS_REPO" src/core_helpers
git clone "$DEV_HELPERS_REPO" dev_helpers

# Dockerfile
cat <<EOF > Dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python", "src/main.py"]
EOF

# docker-compose.yml
cat <<EOF > docker-compose.yml
version: '3.8'
services:
  app:
    build: .
    volumes:
      - .:/app
    command: python src/main.py
EOF

echo "✅ Setup complete for project: $PROJECT_NAME"
echo "👉 Activate your venv with 'source .venv/bin/activate'"