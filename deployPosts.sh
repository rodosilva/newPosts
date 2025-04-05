#!/usr/bin/env bash

# This script will compare the posts created on Obsidian (located in the current directory)
# with the posts already published on my blog (located in "/home/rodrigo/myblog/content/en/posts")

# ==============================================================================
# Variables
# ==============================================================================
posts=""
publishedPosts=""
publishedPostsDirectory="/home/rodrigo/myblog/content/en/posts"
newPosts=""

# ==============================================================================
# Functions
# ==============================================================================
runCopyOver() {
  echo "=============================="
  echo "Copying over the new posts..."
  while read -r line
  do
    echo -e "Deploying the post: \n$line"
    mkdir $publishedPostsDirectory/"$line"
    cp "$line"/* $publishedPostsDirectory/"$line"/
    mv $publishedPostsDirectory/"$line"/*.md $publishedPostsDirectory/"$line"/index.md
    echo -e "$banner\r\r$(cat $publishedPostsDirectory/"$line"/index.md)" > $publishedPostsDirectory/"$line"/index.md
    sed -i -E 's/ReplaceWithTheTitle/'"$line"'/g' $publishedPostsDirectory/"$line"/index.md
    rsync -av $publishedPostsDirectory/"$line"/ "$line"/
  done <<< "$newPosts"

}

runRsync() {
  echo "=============================="
  echo "Running rsync..."
  for p in $posts
  do
    echo -e "Syncing the post: \n$p"
    rsync -av "$p"/ $publishedPostsDirectory/"$p"/
  done
}

# ==============================================================================
# Getting the titles of the posts created on Obsidian
# ==============================================================================
posts=$(ls -l | grep -E '^d' | awk '{print $9, $10}')
echo "=============================="
echo -e "Posts are: \n$posts"
echo -e "$posts" > /tmp/posts.txt

# ==============================================================================
# Getting the existing posts on my blog: https://rodosilva.github.io/myblog/posts/
# ==============================================================================
publishedPosts=$(ls -l $publishedPostsDirectory | grep -E '^d' | awk '{print $9, $10}')
echo "=============================="
echo -e "Published Posts are: \n$publishedPosts"
echo -e "$publishedPosts" > /tmp/publishedPosts.txt

# ==============================================================================
# Comparing the posts
echo "=============================="
echo "Comparing the posts:"
newPosts=$(comm -23 /tmp/posts.txt /tmp/publishedPosts.txt)
echo -e "New Posts are: \n$newPosts"

# ==============================================================================
# Creating the banner for the new posts
# ==============================================================================
echo "=============================="
echo "Creating the banner for the new posts:"
year=$(date +"%Y")
month=$(date +"%m")
day=$(date +"%d")
time=$(date +"%T")
banner=$(cat <<EOF
+++
date = '${year}-${month}-${day}T${time}-05:00'
title = 'ReplaceWithTheTitle'
+++
EOF
)
echo -e "The banner is: \n$banner"

# ==============================================================================
# Deploying the new posts
# ==============================================================================
echo "=============================="
echo "Navigating through the new posts:"

if [[ -z "$newPosts" ]]; then
  echo "There are no new posts to deploy..."
  echo "Proceeding to rsync..."
  runRsync

else
  echo "There are new posts to deploy..."
  echo "Proceeding to copy over..."
  runCopyOver
fi
