# Azure Data Pipeline Components

**Data pipelines** are made up of several components. These components make up the data flows inside the pipeline and connections to data sources, and what data is extracted from the sources.

Other components define how to join data from different sources and some components dictate how data is transformed and aggregated.

Organizations have been accumulating vast amounts of structured and unstructured data throughout their processes to analyze and optimize the process with data analytics. This helps meet various objectives such as cost savings, generating more revenues, developing new products, and improving customer satisfaction.

As organizations migrate more data workloads to Cloud platforms such as **Azure**, the need for automated and petabyte-scale data movement and transformation is crucial for faster decision-making with the data. The right answer for this challenge is to leverage **Azure Data Factory** or **Azure Synapse Pipelines**. Both provide cloud-based code-free ETL (or ELT) as a service to orchestrate the data movement between 100s of data sources at petabyte scale.

<img src="/pictures/enterprise-bi-adf.png" title="enterprise bi adf"  width="400">

Pipeline in Azure Data Factory or Synapse are logical grouping of various activities such as data movement, data transformation and control flow. The Activities inside the Pipelines are actions that we perform on the data. For example:

- Copy data activity is used to load data from on-prem SQL server to Azure Data Lake
- Dataflow activity to extract data from Data Lake, transform and load into Synapse
- Control Flow activity to iteratively perform the copy data activities or data flow activities

relationship between pipelines, activities and datasets:

<img src="/pictures/activities_datasets.png" title="activities datasets"  width="400">

A sample pipeline:

<img src="/pictures/sample_pipeline.png" title="sample pipeline"  width="400">

In this project, we'll use these components to build data pipelines. Here are the steps to reproduce the project


## Step 1 : Create Azure resources

Let's create the Azure resources necessary to build data pipelines.

We'll need **Contributor**, **Data Factory Contributor** and **Storage Blob Contributor** **roles** on the Resource Group, all within the same Azure region.

1. Create **Azure SQL DB**. 
- Select Sample database under Additional settings. 
- Use Query Editor in the Azure Portal to make sure the sample database is created

2. Create **Synapse Analytics Workspace** and a **Dedicated pool**. Then create run tables.sql in order to create the SalesOrderHeader and Customer tables.

3. Create an **Azure Data Lake Gen 2 storage account**, 1 container, and 1 directory called Staging. This Staging folder will be used while creating the pipelines.

4. Create a **Data Factory V2** resource in the Azure Portal.


## Step 1 : Create Azure resources

A **Linked Service** is a pipeline component that contains the connection information needed to connect to a data source. For example in order to connect to a SQL Server database, you will need the server name, a user name and password. The Linked Service is the first building block in the process, so it has to be created before creating any other pipeline components.

<img src="/pictures/linked_services.png" title="linked services"  width="400">

ADF and Synapse provide connectors to 100 plus data sources under the following categories:

- Azure : Azure Blob Storage, Azure Search, Azure Synapse, Azure SQL DB, Cosmos DB etc.
- External Databases : Amazon Redshift, Google Big Query, SQL Server on-prem, Oracle, SAP etc.
- File : Amazon S3, Google Cloud Storage, FTP etc.
- Generic Protocol : ODBC, OData, REST, Sharepoint Online List etc.
- NoSQL : MongodB, Cassandra, Couchbase
- Services and Apps : Dynamics 365, Concur, AWS Web Service, Salesforce, Snowflake etc.


## Step 2 : Creating Linked Services

Let's log into **Azure Data Factory** to create **Linked Services** to the Azure resources we created previously.

Create linked services for each of the following:

- Azure SQL Database, the source database
- Synapse Analytics Workspace, the destination Data Warehouse
- Azure Data Lake Gen 2 storage account , the source folder staging files


## Step 3 : Create Datasets

While the **Linked Service** gives the ability to connect to the data source, **Datasets** allow to create a view of data source objects such as database tables and files on Data Lake. We need the datasets for every source object to extract the data and every target object to store the data.

Let's create the Datasets in Azure Data Factory for the following data sources. Run synapse.sql

- SalesOrderHeader, Customer database tables on the SQL Database
- SalesOrderHeader, Customer database tables on Synapse Dedicated Pool 


## Step 4 : Create Integration Runtimes

The **Integration Runtime** (IR) is the compute leveraged to perform all the data integration activities in ADF or Synapse Pipelines. These activities include:

- **Data Flow**: Execute a Data Flow in the compute environment.
- **Data movement**: Copy data across data stores in a public or private networks
- **Activity dispatch**: Dispatch and monitor transformation activities running on external platforms such as SQL Server, Azure Databricks etc.
- **SSIS package execution**: Execute legacy SQL Server Integration Services (SSIS) packages.

You are allowed to create three different types of Integration types :

- **Azure IR** : Perform data flows, data movement between cloud data stores. It can also be used to dispatch activities to external compute such as Databricks, .NET activity, SQL Server Stored Procedure etc. that are in public network or using private network link. Azure IR is fully managed, serverless compute.

- **Self-hosted IR** (SHIR) : SHIR is used to perform data movement between a cloud data stores and a data store in private network. It can also be used to dispatch activities to external computes on-premises or Azure Virtual Network. These computes include **HDInsight Hive**, SQL Server Stored Procedure activity etc.

- **Azure-SSIS IR** : This is used to lift and shift the existing SSIS packages to execute in Azure.

Integration Runtime Location:

It is important to learn how the location of the IR operates. When you create an IR in a region, it stores the metadata in that region and triggers the pipelines in that region. The pipelines can access data stores from other regions for data movement because we create linked services to those data stores.

Now create them :

1. Login to ADF and verify that there is already an existing Integration Runtime called "AutoResolveIntegrationRuntime" under Manage-> Integration Runtimes
2. Create a new Integration Runtime for your ADF within in the same region as your Resource Group.