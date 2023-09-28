## Objective & Intent
Partners can deploy DREAM Demos in their own Azure subscriptions and demonstrate them live to their customers. 
Partnering with Microsoft sellers, partners can deploy the Industry scenario DREAM demos into customer subscriptions. 
Customers can play, get hands-on experience navigating through the demo environment in their own subscription and show it to their own stakeholders.

## Contents

<!-- TOC -->

- [Requirements](#requirements)
- [Before Starting](#before-starting)
  - [Task 1: Power BI Workspace and Lakehouse creation](Task1-Power-BI-Workspace-and-Lakehouse-creation.md)
  - [Task 2: Run the Cloud Shell to provision the demo resources](Task2-Run-the-Cloud-Shell-to-provision-the-demo-resources.md)
  - [Task 3: Creating a Shortcut in Lakehouse](Task3-Creating-a-Shortcut-in-Lakehouse.md)
  - [Task 4: Setting up the Warehouse](Task4-Setting-up-the-Warehouse.md)
  - [Task 5: Importing Notebooks](Task5-Importing-Notebooks.md)
  - [Task 6: Creating Internal Shortcut](Task6-Creating-Internal-Shortcut.md)
  - [Task 7: KQL DB and QuerySet creation](Task7-KQL-DB-and-QuerySet-creation.md)

- [Appendix](#appendix)
  - [Setting up the Lakehouse](#setting-up-the-lakehouse)
  - [Creating Pipelines and Dataflows](#creating-pipelines-and-dataflows)
  - [Creating a Resource Group](#creating-a-resource-group)

<!-- /TOC -->

## Requirements

* An Azure non-prod external account with the ability to create Fabric Workspace. If you don't have one, use link below to request for one.
https://mcapsservices.powerappsportals.com/SignIn?ReturnUrl=%2Fsupport%2Feslabs-newazuresubscription%2F%3FServiceId%3D78b2e66c-42f2-e811-a96a-000d3a30da4f
* A Power BI with Fabric License to host Power BI reports.
* Make sure your Power BI administrator can provide service principal access on your Power BI tenant.
* Make sure to register the following resource providers with your Azure Subscription:
   - Microsoft.Fabric
   - Microsoft.Databricks
   - Microsoft.EventHub
   - Microsoft.SQLSever
   - Microsoft.StorageAccount
   - Microsoft.AppService
* You must only execute one deployment at a time and wait for its completion.Running multiple deployments simultaneously is highly discouraged, as it can lead to deployment failures.
* Select a region where the desired Azure Services are available. If certain services are not available, deployment may fail. See [Azure Services Global Availability](https://azure.microsoft.com/en-us/global-infrastructure/services/?products=all) for understanding target service availability. (Consider the region availability for Synapse workspace, Iot Central and cognitive services while choosing a location)
* In this Accelerator, we have converted real-time reports into static reports for the users' ease but have covered the entire process to configure real-time dataset. Using those real-time dataset, you can create real-time reports.
* Make sure you use the same valid credentials to log into Azure and Power BI.
* Once the resources have been setup, ensure that your AD user and synapse workspace have “Storage Blob Data Owner” role assigned on storage account name starting with “storage”.
* Review the [License Agreement](https://github.com/microsoft/Azure-Analytics-and-AI-Engagement/blob/main/CDP-Retail/license.md) before proceeding.



