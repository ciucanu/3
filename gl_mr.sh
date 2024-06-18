#!/bin/bash

# Variables
GITLAB_URL="https://gitlab.example.com"
PRIVATE_TOKEN="your_private_token"
PROJECT_ID="123" # Replace with your project ID
SOURCE_BRANCH="feature-branch"
TARGET_BRANCH="main"
TITLE="Merge Request Title"
DESCRIPTION="Description of the merge request"

# API endpoint
API_URL="$GITLAB_URL/api/v4/projects/$PROJECT_ID/merge_requests"

# Curl command to create merge request
response=$(curl -s --request POST "$API_URL" \
  --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" \
  --header "Content-Type: application/json" \
  --data "{
    \"source_branch\": \"$SOURCE_BRANCH\",
    \"target_branch\": \"$TARGET_BRANCH\",
    \"title\": \"$TITLE\",
    \"description\": \"$DESCRIPTION\"
  }")

# Output the response
echo "Response from GitLab:"
echo "$response"
