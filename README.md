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

Relationship between pipelines, activities and datasets:

<img src="/pictures/activities_datasets.png" title="activities datasets"  width="800">

A sample pipeline:

<img src="/pictures/sample_pipeline.png" title="sample pipeline"  width="400">

In this project, we'll use these components to build data pipelines. Here are the steps to reproduce the project :



## Step 1 : Create Azure resources

Let's create the Azure resources necessary to build data pipelines.

We'll need **Contributor**, **Data Factory Contributor** and **Storage Blob Contributor** **roles** on the Resource Group, all within the same Azure region.

1. Create **Azure SQL DB**. 
- Select Sample database under Additional settings. 
- Use Query Editor in the Azure Portal to make sure the sample database is created

<img src="/pictures/sql_database1.png" title="sql database"  width="600">
<img src="/pictures/sql_server.png" title="sql server"  width="600">
<img src="/pictures/sql_configure.png" title="sql configure"  width="600">
<img src="/pictures/sql_database2.png" title="sql database"  width="600">
<img src="/pictures/sql_database3.png" title="sql database"  width="600">

2. Create **Synapse Analytics Workspace**. 

<img src="/pictures/synapse1.png" title="synapse"  width="600">
<img src="/pictures/synapse2.png" title="synapse"  width="600">

Inside **Synapse Workspace**, create a **Dedicated SQL Pool**. (**Manage** tab, then **SQL pools**)

<img src="/pictures/dedicated_pool.png" title="dedicated pool"  width="600">

Then, inside the dedicated pool just created, run *tables.sql* in order to create the *SalesOrderHeader* and *Customer* tables. (**Develop** tab, then create a **SQL script** and paste in *tables.sql*)

**CAUTION** : make sure you choose the right dedicated pool, not the built in one!!

<img src="/pictures/run_script.png" title="run script"  width="600">

You should now see the created tables in the Data tab :

<img src="/pictures/created_tables.png" title="created tables"  width="300">

3. Create a **Data Factory V2** resource in the Azure Portal.

<img src="/pictures/data_factory1.png" title="data factory"  width="600">

You should be able to reach your Data Factory Workspace :

<img src="/pictures/data_factory_ws.png" title="data factory workspace"  width="600">

4. Create an **Azure Data Lake Gen 2 storage account**, 1 container, and 1 directory called Staging. This Staging folder will be used while creating the pipelines.

<img src="/pictures/storage_account1.png" title="storage account"  width="600">

In the Advanced tab, make sure you select *Enable hierarchical namespace* in order to make it a **Gen2** type :

<img src="/pictures/storage_account2.png" title="storage account"  width="600">

In your just created storage account **Storage browser**, create a container that will be used for staging :

<img src="/pictures/staging_container.png" title="staging container"  width="600">

In your just created container, create a directory that will be used for staging :

<img src="/pictures/staging_directory.png" title="staging directory"  width="600">



## Step 2 : Creating Linked Services

A **Linked Service** is a pipeline component that contains the connection information needed to connect to a data source. For example in order to connect to a SQL Server database, you will need the server name, a user name and password. The Linked Service is the first building block in the process, so it has to be created before creating any other pipeline components.

<img src="/pictures/linked_services.png" title="linked services"  width="700">

ADF and Synapse provide connectors to 100 plus data sources under the following categories:

- Azure : Azure Blob Storage, Azure Search, Azure Synapse, Azure SQL DB, Cosmos DB etc.
- External Databases : Amazon Redshift, Google Big Query, SQL Server on-prem, Oracle, SAP etc.
- File : Amazon S3, Google Cloud Storage, FTP etc.
- Generic Protocol : ODBC, OData, REST, Sharepoint Online List etc.
- NoSQL : MongodB, Cassandra, Couchbase
- Services and Apps : Dynamics 365, Concur, AWS Web Service, Salesforce, Snowflake etc.

Now log into **Azure Data Factory** to create **Linked Services** to the Azure resources we created previously.

1. Azure SQL Database, the source database. Name : *ls_sqldb_sales*

<img src="/pictures/linked_services_sql1.png" title="linked services SQL Database"  width="600">
<img src="/pictures/linked_services_sql2.png" title="linked services SQL Database"  width="600">

In case the connection fails, go into the networking section of your SQL database server and add a firewall rule to allow your IP address. Don't forget to select *"Allow Azure services and resources to access this server"* :

<img src="/pictures/linked_services_sql_firewall.png" title="sql firewall linked services"  width="600">

2. Azure Data Lake Gen 2 storage account , the source folder staging files. Name : *ls_*

<img src="/pictures/linked_services_gen2_1.png" title="linked services gen2"  width="600">
<img src="/pictures/linked_services_gen2_2.png" title="linked services gen2"  width="600">

3. Synapse Analytics Workspace, the destination Data Warehouse. Name : *ls_synapse*

<img src="/pictures/linked_services_synapse1.png" title="linked services synapse"  width="600">
<img src="/pictures/linked_services_synapse2.png" title="linked services synapse"  width="600">

In case the connection fails, go into the networking section in your synapse workspace and add a firewall rule to allow your IP address. Don't forget to select *"Allow Azure synapse link for..."* :

<img src="/pictures/synapse_server_firewall_rule.png" title="synapse server firewall rule"  width="600">



## Step 3 : Create Datasets

While the **Linked Service** gives the ability to connect to the data source, **Datasets** allow to create a view of data source objects such as database tables and files on Data Lake. We need the datasets for every source object to extract the data and every target object to store the data.

Now create the Datasets in **Azure Data Factory** for the following data sources. Select the *Author* tab, then *Datasets*. Run synapse.sql

1. *SalesOrderHeader* and *Customer* database tables on the **SQL Database**. Names : *ds_sqldb_salesorderheader* and *ds_sqldb_customer*
<img src="/pictures/datasets_sql1.png" title="datasets"  width="600">
<img src="/pictures/datasets_sql2.png" title="datasets"  width="600">
<img src="/pictures/datasets_sql3.png" title="datasets"  width="600">

2. *SalesOrderHeader* and *Customer* database tables on **Synapse Dedicated Pool**. Names : *ds_synapse_salesorderheader* and *ds_synapse_customer*

<img src="/pictures/datasets_synapse1.png" title="datasets"  width="600">
<img src="/pictures/datasets_synapse2.png" title="datasets"  width="600">

3. Publish all four datasets

<img src="/pictures/datasets_publish.png" title="datasets publish"  width="600">



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

1. Login to **Azure Data Factory** and verify that there is already an existing Integration Runtime called "AutoResolveIntegrationRuntime" under **Manage** -> **Integration Runtimes**

<img src="/pictures/integration_runtime1.png" title="integration runtime"  width="600">

2. Create a new **Integration Runtime** for your ADF within in the same region as your Resource Group. Name : *IRFranceCentral*

<img src="/pictures/integration_runtime2.png" title="integration runtime"  width="600">
<img src="/pictures/integration_runtime3.png" title="integration runtime"  width="600">



## Step 5 : Mapping Dataflows

Now we will create **Data Flows** in **Azure Data Factory** to perform data transformations using the no-code User Interface.

1. Create Data Flow to extract data from **SalesOrderHeader** table from SQL DB into corresponding table in **Synapse**. Name : *sourcetablesalesorderheader*

<img src="/pictures/dataflow_salestableorderheader1.png" title="dataflow salestableorderheader"  width="800">
<img src="/pictures/dataflow_salestableorderheader2.png" title="dataflow salestableorderheader"  width="800">

Now initiate a debug session and set the **Debug Settings** to 10 rows :
<img src="/pictures/dataflow_debugsettings.png" title="dataflow debug settings"  width="600">

This allows you to do a data preview :
<img src="/pictures/dataflow_data_preview.png" title="dataflow data preview"  width="600">

Now select **Sink** by clicking on the plus sign :
<img src="/pictures/dataflow_sink.png" title="dataflow sink"  width="600">
<img src="/pictures/dataflow_sink2.png" title="dataflow sink"  width="600">

Make sure the mappings are correct :
<img src="/pictures/dataflow_mappings.png" title="dataflow mappings"  width="600">

Give a name to this data flow and publish it:
<img src="/pictures/dataflow_publish.png" title="dataflow publish"  width="800">

2. Create Data Flow to extract data from *Customer* table in SQL DB into corresponding table in Synapse.

<img src="/pictures/dataflow_customer.png" title="dataflow customer"  width="800">

Now select **Sink** by clicking on the plus sign :
<img src="/pictures/dataflow_sink3.png" title="dataflow sink"  width="600">

Make sure the mappings are correct :
<img src="/pictures/dataflow_mappings_customer.png" title="dataflow mappings customer"  width="600">

Give a name to this data flow and publish it:
<img src="/pictures/dataflow_publish_customer.png" title="dataflow publish customer"  width="600">

3. Verify that all the data is successfully loaded into Synapse tables SalesOrderHeader, Customer tables.

4. Create a join between SalesOrderHeader and customer tables to display information about the customer.


## Step 6 : Transform and Aggregate Data with Data Flows

Now that we have the **Sales Order data** in the **Synapse** table, we will now aggregate Sales by the Customer and store in an Aggregated table.

1. Create **SalesAggregate table** in Synapse with the following script:
```
CREATE TABLE SalesAggregate( CustomerID int NOT NULL, TotalSales  float )
```

CAUTION : make sure you are in the right SQL pool!!

<img src="/pictures/create_aggregate.png" title="create aggregate"  width="600">

2. Create **Dataflow** to extract *SalesOrderHeader* data from SQL DB, aggregate and then load onto *SalesAggregate* table in Synapse

- In **Data Factory**, create a dataset for the synapse sales aggregate table. Name : *ds_synapse_sales_aggregate_table*

<img src="/pictures/dataset_synapse.png" title="dataset synapse"  width="600">
<img src="/pictures/dataset_synapse2.png" title="dataset synapse"  width="600">

- Then, still in **Data Factory**, create a dataflow for the sales aggregate table :

<img src="/pictures/dataflow_salesaggregate.png" title="dataflow salesaggregate"  width="600">

- Then, add a filter :

<img src="/pictures/dataflow_filter.png" title="dataflow filter"  width="600">

- Then, select expression builder :

<img src="/pictures/dataflow_expression_builder.png" title="dataflow expression builder"  width="600">

- Then, write a filter :

<img src="/pictures/dataflow_expression_builder2.png" title="dataflow expression builder"  width="600">

- Then, add a derived column :

<img src="/pictures/dataflow_derived_column.png" title="dataflow derived column"  width="600">
<img src="/pictures/dataflow_derived_column2.png" title="dataflow derived column"  width="600">
<img src="/pictures/dataflow_derived_column3.png" title="dataflow derived column"  width="600">

- Then, add a sink :

<img src="/pictures/dataflow_sink_synapse_sales_aggregate.png" title="dataflow sink"  width="600">

- Then publish. 

- Then create a new pipeline to test the dataflow. Drag a **Data flow** activity (inside **Move & transform**), select **dataflow aggregate sales** in settings, select the linked service, select the staging directory
<img src="/pictures/pipeline.png" title="pipeline"  width="800">

- In the end click **Validate** and **Publish**.
<img src="/pictures/pipeline2.png" title="pipeline"  width="600">

- Then, trigger the pipeline and go to **Azure Synapse** to run the following query : 

```
SELECT TOP 100 * FROM SalesAggregate
```

- And see the result :

<img src="/pictures/pipeline_result.png" title="pipeline"  width="600">



## Step 7 : Creating Pipelines


1. Create a Pipeline and add *SalesOrderHeader* Dataflow to it. Name : *Data flow salesorderheader to synapse*

<img src="/pictures/salesorderheader_to_synapse.png" title="pipeline salesorderheader to synapse"  width="600">


2. Create a Pipeline and add *Customer* Dataflow to it.

<img src="/pictures/customer_to_synapse.png" title="pipeline customer to synapse"  width="600">


3. Create a Pipeline and add *Aggregate* Dataflow to it.

<img src="/pictures/aggregate_to_synapse.png" title="pipeline aggregate to synapse"  width="600">


4. Validate and publish the pipelines



## Step 7 : Debug, Trigger, and Monitor Pipelines

1. Select SalesOrderHeader Pipeline and debug it and monitor the progress

2. Select Customer Pipeline and debug it and monitor the progress

3. Select Aggregate Pipeline and debug it and monitor the progress

4. Now Execute each Pipelines by clicking in Add Trigger and Trigger Now