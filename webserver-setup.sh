#! /bin/bash
# Instance Identity Metadata Reference - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-identity-documents.html
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo service httpd start  
sudo echo '<h1>Welcome to Gild Wolrd</h1>' | sudo tee /var/www/html/index.html
sudo mkdir /var/www/html/web
sudo echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>Welcome to Gild World- Demo website</h1> <p>Demo using Terraform and AWS </p> </body></html>' | sudo tee /var/www/html/web/index.html
sudo curl http://169.254.169.254/latest/dynamic/instance-identity/document -o /var/www/html/web/metadata.html


