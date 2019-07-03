# Set subscription
az account set --subscription 94fbadf8-645b-426b-8455-4de8b5a74bb5

# Set resourcegroup and location
resourceGroupName=Flask-resourcegroup-$RANDOM
location=westeurope

# Set an admin login and password for your database
adminlogin=SqlAdmin
password="ChangeYourAdminPassword1"

# The logical server name has to be unique in the system
servername=server-10002
DBURL="server-10002.postgres.database.azure.com"

# The ip address range that you want to allow to access your DB
startip=0.0.0.0
endip=0.0.0.0

# )Optional) Set name of App Service Plan and Web App
planName=SampleAppServicePlan
webappname=Flask-EPAM-Test-App-$RANDOM

# (Optional) Set Repository URL
repoUrl= https://github.com/Xangliev/Devops-epam-app.git

# Create a resource group
az group create --name $resourceGroupName --location $location

# Create a logical server in the resource group
az postgres server create --name $servername --resource-group $resourceGroupName --location $location --admin-user $adminlogin --admin-password $password --sku-name B_Gen5_1

# Configure a firewall rule for the server
az postgres server firewall-rule create --resource-group $resourceGroupName --server-name $servername --start-ip-address $startip --end-ip-address $endip --name allow-all-azure-ip

# Create new database and user credentials
PGPASSWORD=$password psql -h $DBURL -U $adminlogin@$servername --file='db.sql' postgres

# Connect to new database with user credentials and insert inital values
PGPASSWORD='Interforaewg098!' psql -h $DBURL -U 'api_db_user'@$servername -d 'api_db' --file='db1.sql'

# Steps for deploying web app, with load balancing and CD from Github Source enabled
# Create webapp from local git
az webapp up -n $webappname -g $resourceGroupName -l $location --plan $planName
# Enable Load Balancing
az appservice plan update --number-of-workers 2 --resource-group $resourceGroupName --name $planName
# Enable CD from Repository
az webapp deployment source config --repo-url $repoUrl --resource-group $resourceGroupName --name $webappname