#!/bin/bash

apt update -y
apt install nginx -y

#Enable/start nginx
systemctl enable nginx
systemctl start nginx

# Create portfolio content
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Portfolio</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
      text-align: center;
      padding: 50px;
    }
    h1 {
      color: #333;
    }
    p {
      font-size: 18px;
      color: #666;
    }
    a {
      color: #007BFF;
      text-decoration: none;
    }
  </style>
</head>
<body>
  <h1>Hi, I'm XXXXXXX</h1>
  <p>DevOps · Cloud · Software Engineer</p>
  <p>
    <a href="https://google.com" target="_blank">Blog</a> |
  </p>
</body>
</html>
EOF