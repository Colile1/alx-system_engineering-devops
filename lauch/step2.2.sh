server {
    listen 80;
    server_name colile.tech www.colile.tech;
    root /path/to/your/frontend/build;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}