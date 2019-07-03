az account set --subscription 94fbadf8-645b-426b-8455-4de8b5a74bb5

# Set resourcegroup and location
resourceGroupName=Flask-resourcegroup-
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

# Set name of App Service Plan
plan=scale_out_plan

# Create a resource group
az group create --name $resourceGroupName --location $location

# Create an app service plan in the resource group
az group deployment create --name $plan --resource-group $resourceGroupName --template-uri https://raw.githubusercontent.com/Xangliev/Devops-epam-app/master/service_plan.json

# Create a logical server in the resource group
az postgres server create --name $servername --resource-group $resourceGroupName --location $location --admin-user $adminlogin --admin-password $password --sku-name B_Gen5_1

# Configure a firewall rule for the server
az postgres server firewall-rule create --resource-group $resourceGroupName --server-name $servername --start-ip-address $startip --end-ip-address $endip --name allow-all-azure-ip

# Create new database and user credentials
PGPASSWORD=$password psql -h $DBURL -U $adminlogin@$servername --file='db.sql' postgres

# Connect to new database with user credentials and insert inital values
PGPASSWORD='Interforaewg098!' psql -h $DBURL -U 'api_db_user'@$servername -d 'api_db' --file='db1.sql'