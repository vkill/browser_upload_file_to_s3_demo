Browser upload file to s3 demo
======

### Run

1. Export env variables

    export AWS_ACCESS_KEY_ID=**********
    export AWS_SECRET_ACCESS_KEY=**********
    export AWS_S3_BUCKET=**********

2. Config S3 CORS like this

    <?xml version="1.0" encoding="UTF-8"?>
    <CORSConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
        <CORSRule>
            <AllowedOrigin>*</AllowedOrigin>
            <AllowedMethod>GET</AllowedMethod>
            <AllowedMethod>POST</AllowedMethod>
            <AllowedMethod>PUT</AllowedMethod>
            <MaxAgeSeconds>3000</MaxAgeSeconds>
            <AllowedHeader>*</AllowedHeader>
        </CORSRule>
    </CORSConfiguration>

3. Init Rails app

    rake db:create
    rake db:migrate
    
4. Run Rails app

    rails s

