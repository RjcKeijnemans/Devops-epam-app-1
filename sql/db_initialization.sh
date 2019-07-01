az account set --subscription 94fbadf8-645b-426b-8455-4de8b5a74bb5

# Set resourcegroup and location
resourceGroupName=myResourceGroup-Flask
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

# Create a resource group
az group create --name $resourceGroupName --location $location

# Create a logical server in the resource group
az postgres server create --name $servername --resource-group $resourceGroupName --location $location --admin-user $adminlogin --admin-password $password --sku-name B_Gen5_1

# Configure a firewall rule for the server
az postgres server firewall-rule create --resource-group $resourceGroupName --server-name $servername --start-ip-address $startip --end-ip-address $endip --name allow-all-azure-ip

# Create database and user credentials
PGPASSWORD=$password psql -h $DBURL -U $adminlogin@$servername --file='db.sql' postgres