#!/bin/bash
set -e

USERNAME="manjinderdevops"
IMAGE_NAME="devops-automation-exercise"
VERSION_FILE="VERSION"

BUMP_TYPE=${1:-patch}

usage() {
  echo "Usage: $0 [BUMP_TYPE]"
  echo
  echo "BUMP_TYPE (optional):"
  echo "  major   Increment the major version (e.g., 1.2.3 → 2.0.0)"
  echo "  minor   Increment the minor version (e.g., 1.2.3 → 1.3.0)"
  echo "  patch   Increment the patch version (default, e.g., 1.2.3 → 1.2.4)"
  echo
  echo "Example:"
  echo "  $0 patch   # Default behavior"
  echo "  $0 minor   # Increment minor version"
  echo "  $0 major   # Increment major version"
  exit 1
}

# Try and get current version from VERSION file if available
if [ ! -f "$VERSION_FILE" ]; then
  echo "0.0.0" > "$VERSION_FILE"
fi
CURRENT_VERSION=$(cat "$VERSION_FILE" | tr -d '[:space:]')

#handle edge case if an empty VERSION file exists
if [ -z "$CURRENT_VERSION" ]; then
  echo "VERSION file is empty. Setting to 0.0.0"
  echo "0.0.0" > "$VERSION_FILE"
fi
CURRENT_VERSION=$(cat "$VERSION_FILE" | tr -d '[:space:]')

IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"

case "$BUMP_TYPE" in
  major)
    ((MAJOR++))
    MINOR=0
    PATCH=0
    ;;
  minor)
    ((MINOR++))
    PATCH=0
    ;;
  patch)
    ((PATCH++))
    ;;
  *)
    echo "Invalid bump type: $BUMP_TYPE (use: major, minor, patch)"
    usage
    ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"
printf "%s" "$NEW_VERSION" > "$VERSION_FILE"

echo "Bumping version: $CURRENT_VERSION → $NEW_VERSION"

# Generate version info file
echo "Generating version.json..."
cat <<EOF > src/version.json
{
  "version": "$NEW_VERSION",
  "build_time": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF

docker build -t $USERNAME/$IMAGE_NAME:$NEW_VERSION . --platform=linux/amd64 

docker push $USERNAME/$IMAGE_NAME:$NEW_VERSION

docker tag $USERNAME/$IMAGE_NAME:$NEW_VERSION $USERNAME/$IMAGE_NAME:latest
docker push $USERNAME/$IMAGE_NAME:latest

IMAGE="$USERNAME/$IMAGE_NAME:$NEW_VERSION"

echo "Done! Pushed version: $NEW_VERSION"
echo "Image: $IMAGE"

# Manual approval to invoke create_deploy_pr.py
read -p "Invoke the deployment PR script (../helper_scripts/create_deploy_pr.py)? (yes/no): " CONFIRMATION
if [[ "$CONFIRMATION" == "yes" ]]; then
  echo "Invoking deployment PR script..."
  python3 ../helper_scripts/create_deploy_pr.py "$IMAGE"
else
  echo "Skipping deployment PR script invocation."
fi