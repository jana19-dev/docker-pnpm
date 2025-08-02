# Setup Instructions

This guide will help you set up automated Docker image builds and pushes to Docker Hub using GitHub Actions.

## Prerequisites

1. **GitHub Account**: You need a GitHub account to create the repository
2. **Docker Hub Account**: You need a Docker Hub account (username: `jana19`)
3. **Git**: Git should be installed on your local machine

## Step 1: Create GitHub Repository

1. Go to [GitHub](https://github.com) and sign in
2. Click "New repository" or go to https://github.com/new
3. Set repository name: `pnpm-docker`
4. Make it **Public** (required for free Docker Hub automated builds)
5. Initialize with README: **No** (we already have files)
6. Click "Create repository"

## Step 2: Create Docker Hub Access Token

1. Go to [Docker Hub](https://hub.docker.com) and sign in
2. Click on your username → **Account Settings**
3. Go to **Security** → **Access Tokens**
4. Click **New Access Token**
5. Give it a name: `github-actions-pnpm`
6. Set permissions: **Read, Write, Delete**
7. Click **Generate** and **copy the token** (you won't see it again!)

## Step 3: Configure GitHub Secrets

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add the following secret:
   - **Name**: `DOCKER_HUB_ACCESS_TOKEN`
   - **Value**: Paste the Docker Hub access token you copied

## Step 4: Push Code to GitHub

Run these commands in your terminal:

```bash
cd /Users/rajakumaj/Dev/docker-images/pnpm

# Initialize git repository
git init

# Add all files
git add .

# Commit files
git commit -m "Initial commit: pnpm Docker images with automated builds"

# Add GitHub remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/pnpm-docker.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 5: Verify Automation

1. **Check GitHub Actions**: Go to your repository → **Actions** tab
2. You should see a workflow running called "Build and Push PNPM Docker Image"
3. **Check Docker Hub**: Go to https://hub.docker.com/r/jana19/pnpm
4. After the workflow completes, you should see new images

## Step 6: Manual Trigger (Optional)

You can manually trigger a build:

1. Go to **Actions** → **Build and Push PNPM Docker Image**
2. Click **Run workflow**
3. Check "Force build even if no new version available"
4. Click **Run workflow**

## Available Images

After setup, these images will be available:

- `jana19/pnpm:24-alpine` - Node.js 24.x.x with pnpm (Production - ~192MB)
- `jana19/pnpm:24` - Node.js 24.x.x with pnpm (Development - ~1.15GB)

> **Note**: When Node.js 25 is released, `25-alpine` and `25` tags will be automatically added.

## Usage Examples

```bash
# Production use (Alpine)
FROM jana19/pnpm:24-alpine
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

# Development use (Standard)
FROM jana19/pnpm:24
COPY package.json pnpm-lock.yaml ./
RUN pnpm install
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm build

# Run commands (Alpine - Production)
docker run --rm -v $(pwd):/app -w /app jana19/pnpm:24-alpine pnpm install

# Run commands (Standard - Development)
docker run --rm -v $(pwd):/app -w /app jana19/pnpm:24 pnpm install
```

## Automation Schedule

- **Weekly builds**: Every Sunday at 2 AM UTC
- **On code changes**: When Dockerfile or workflows change
- **Manual triggers**: Can be triggered anytime

## Troubleshooting

### Build Fails
- Check if Docker Hub access token is correct
- Verify the token has write permissions
- Check GitHub Actions logs for detailed errors

### Images Not Updating
- GitHub Actions may have rate limits
- Check if the workflow is enabled
- Verify the repository is public

### Permission Errors
- Make sure Docker Hub token has `Read, Write, Delete` permissions
- Check if the `jana19` username is correct in the workflow

## Local Development

```bash
# Build locally (Alpine variant - default)
./build.sh 24 alpine
npm run build:24-alpine

# Build locally (Standard variant)
./build.sh 24 standard
npm run build:24-standard

# Test locally (Alpine)
./test.sh 24 alpine
npm run test:alpine

# Test locally (Standard)
./test.sh 24 standard
npm run test:standard
```

## Support

If you encounter issues:
1. Check GitHub Actions logs
2. Verify Docker Hub permissions
3. Test local builds first
4. Check if base Node.js images are available
