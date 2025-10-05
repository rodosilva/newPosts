+++
date = '2025-10-04T09:44:00-05:00'
title = 'GCP Cloud Digital Leader'
+++

## INTRODUCTION

### Benefit
- Infrastructure and application modernization in cloud
- Innovating with data in google Cloud
- Understanding google cloud security and operations to maintain the existing standards

### GCP Global Infrastructure
- Regions and Zones
- Can be picked by using the `Google Region Picker Tool` considering carbon footprint, price and latency. See [here](https://cloud.withgoogle.com/region-picker/)

## ACCOUNT
- Google Cloud: [console cloud](https://console.cloud.google.com/)

### Hierarchy 
- **Organization** - Company
- **Folders** - Departments, teams, productos
- **Projects** - Dev Project, Test Project, Prod Project
- **Resources** - Compute Engine Instances, App Engine Services, Cloud Storage Buckets

### Billing
- GCP allows us to see granular details of our GCP usage
- Billing alert

## GCP COMPUTE
![](Pasted%20image%2020251004104154.png)

![](Pasted%20image%2020251004104339.png)

- **Compute Engine:** VM Instances, Instance templates, Machine images.
- **Persistent Disk:** Network storage devices
- **VPC Firewall Rules:** Allow or deny connections to or from your virtual machine.

### Scaling Compute with Instance Group and Load Balancers

#### Instance Group
![](Pasted%20image%2020251004111042.png)

Is a collection of virtual machine instances.
- Managed Instance Group (MIGs): It let you operate apps on multiple idetical VMs (Auto scaling, auto healing, auto updating).
- Un-managed Instance Groups: It let you load balance across a fleet of VMs that you manage yourself.

Desirable:
- High availability
- Scalability
- Automated updates

#### Create an Instance Group
`Compute Engine` - `Instance Group` - `Instance Templates`

#### Load Balancers
![](Pasted%20image%2020251004113215.png)

**Health Checks**
Check our instance groups

**HTTPS Load Balancers (Layer 7)**
- Front-End configuration
- Back-End configuration (Here we set the instances group)
- Routing rules

## DATABASES
Support good data access.
Multiple users can read and modify the data at the same time
Databases are searchable and sortable.
Can be used to get business insights

- **Why GCP Database:**
	- Licenses and maintenance
	- Scalability, Disaster recover

- **Types:**
	- Cloud SQL: MySQL, PostgreSQL, SQL Server
	- Cloud Spanner: High capacity. Oracle or DynamoDB
	- Alloy DB for PostgreSQL
	- Cloud Bigtable: NoSQL database

- **SQL and NoSQL:** 
![](Pasted%20image%2020251004121702.png)

![](Pasted%20image%2020251004121920.png)

- Connect to Database Using `CLoud Shell`: `gcloud sql connect main-db --user=root --quiet`
- Need to enable API

## OBJECT STORAGE
Computer data storage architecture designed to handle large amounts of unstructured data.
Storage pool (Google Drive)
- Cloud Storage is the object storage option in GCP
- Any kind of data
- Turbo Replication: Replicate 100% of your data between regions in 15 mins or less
- Durability 99.999999999%

**Use case:**
- Rich media storage and delivery
- Big data analytics
- IoT
- Backup and archiving

**Create bucket:**
- Globally unique
- Enforce public access prevention (default)

**Different Storage Classes:**
![](Pasted%20image%2020251004141041.png)

## BUILDING APIs
- API: GET, PUT, POST

**Apigee in GCP**
- With `Apigee hybrid` you have the power to choose where to host your APIs. (On-premises, Google Cloud or Hybrid)
- AI-powered API monitoring
- Expand and move to micro service architecture
- Developer-friendly tools to build and deploy APIs

![](Pasted%20image%2020251004142553.png)

## GOOGLE CLOUD SOLUTION FOR MACHINE LEARNING AND AI

**4Vs of Big Data:** 
- Volume: Amount of data
- Velocity: Speed new data
- Variety: Unstructured, semi-structured and structured
- Veracity: Trustworthiness of data. Accurate and high-quality

**4 Steps of Handling Big Data in GCP**
- Collection of Data
- Processing the Data
- Analytics on Data
- AI and Machine Learning

**Use Case for Big Data:**
- Ingest: 
	- `Cloud Pub/sub`: Stream data in real-time. Ingest events for streaming into `Big Query`, `data lakes` or operational databases.
- Storage: 
	- `Cloud Storage` (Object Storage) Can act as a Data warehouse. Connect further to `Big Query`, `DataProc`
- Analytics:
	- `BigQuery`: Big Data feature. Can read the data directly from `Cloud Storage`
	- `Cloud Dataproc`: Can process and clean the Data. Fully managed and highly scalable service for running `Apache Spark`. Used for data lake modernization
- AI and Machine Learning: 
	- `Cloud VertexAI`: Build and run AI models. Use GPU instance for Deep learning machine learning models. End to End machine learning model deployment. Options to use `Tensorflow`, `Scikit ML Libraries`

![](Pasted%20image%2020251004144546.png)

### Pup/Sub
- `Topic`: Ingest data. Temporal storage for the streamed information
- `Subscription`: Reads from `Topic` and extract the required information
- Data retention: 7 Days (default)

### BigQuery
- Create `DataSet`: Collection of things
- IS able to understand the `Squema` of a `CSV file` and creates a `SQUEMA/TABLE` on the Google Cloud UI.
- Charged for the data scanned.
- `BIEngine`: Reduce `BigQuery` cost. Since certain tables will be queried a lot, `BIEngine` catches certain tables. SO whe someone queries that same table, it will be queried from `BIEngine`

## CONTAINER ORCHESTRATION
**Why containers are required:**
- Streamlines the development life cycle by allowing developers to work in standardized environment
- Shipping code to clients is easy

**Virtualization:**
- Docker
- Container - Image

### Google Kubernetes Service (GKE)
Open-source container orchestration system
- Automating
- Software deployment
- Scaling
- Management
- Easy integration with Load Balancers and other services to expose our application APIs

**Modes:**
- Autopilot
- Standard: You want to control the behavior 
![](Pasted%20image%2020251004160856.png)

### CloudRun
We only have a container image. We want to quickly test this without going to the `GKE` setup.
- Serverless
- Languages: Go, Python, Java, Node.js, .NET and Ruby
- Pay  per use
- Only pay when your code is running.
- Cloud Run integrations - Load balancing, logging 
- Scalable solution to be chose to test and deploy a simple containerized application.
- **Concurrency**: Each `cloud-run` container can receive default `80` requests at the same time. You can increase this to a maximum of 1000
![](Pasted%20image%2020251004161640.png)

## SECURITY IN GCP
- Detect, investigate and respond to threats faster
- Protect business-critical apps from fraud and web attacks
- Digital sovereignty
- Provide secure access to systems, data and resources

- **Data Replication:** Data replication and Disaster recovery
- **Singe Sign On:** Integrate with the existing single sign-on system (Multi factor authentication)
- **IAM:** Use `IAM` to provide the least required access
- **Cloud Armor:** Enable Cloud Armor protection
- **Thread Detection:** Setup rules to alert on mis-configuration

**Shared Respectability Model**
- Security Of the Cloud
	- Physical security of Data centers
	- Global network
	- Cyber Security of data centers
	- Upgrade and patch accordingly
- Security inside the Cloud
	- Data security inside the cloud
	- App configuration according to best practice
	- Taking proactive measures in solving security threats

## GCP ARCHITECTURE

### Connection On-Premises to GCP
![](Pasted%20image%2020251004164050.png)

### Internet of Things - Sensor Stream ingest and Processing
![](Pasted%20image%2020251004164735.png)

### Big Data - Log Processing
![](Pasted%20image%2020251004165048.png)

## CERTIFICATION EXAM
![](Pasted%20image%2020251004165410.png)













