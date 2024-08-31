# A STEP UP

# Hosting a Flutter Web Project using XAMPP on Windows

This documentation provides step-by-step instructions to host a Flutter web project using XAMPP on a Windows environment.

## Prerequisites

- Flutter installed on your machine.
- XAMPP installed on your machine.

## Step 1: Build the Flutter Web Project

First, navigate to your Flutter project directory and build the web project.
**foldername** is the name of the folder which your build located on htdocs

```sh
flutter build web --web-renderer html  --base-href "/foldername/"
```

## Step 2: Create .htaccess file

Create or update the .htaccess file in your foldername directory to rewrite all requests to index.html.Replace the foldername with your folder name.

```html
<IfModule mod_rewrite.c>
  RewriteEngine On RewriteBase /foldername/ RewriteRule ^index\.html$ - [L]
  RewriteCond %{REQUEST_FILENAME} !-f RewriteCond %{REQUEST_FILENAME} !-d
  RewriteRule . /foldername/index.html [L]
</IfModule>
```
