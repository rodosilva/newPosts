+++
date = '2025-10-12T14:51:24-05:00'
title = 'AWS CDK'
+++

## LINKS
- **AWS CDK Official:** [cdk docs](https://docs.aws.amazon.com/cdk/api/v2/docs/aws-construct-library.html)
- **Teacher Repository:** [cdk alexhddev](https://github.com/alexhddev/cdkpro)

## PRE REQUISITES
- `NodeJS + npm`
- AWS CDK - As global `npm` dependency 
- A text editor: `VS Code`
- `AWS CLI`
- Optional: `Python + PIP`
- Optional: `VSCode AWS toolkit extension`

### Installing NodeJS
Ver la documentación [Oficial](https://nodejs.org/es/download)

```bash
# Descarga e instala nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# en lugar de reiniciar la shell
\. "$HOME/.nvm/nvm.sh"

# Descarga e instala Node.js:
nvm install 22

# Verify the Node.js version:
node -v # Should print "v22.20.0".

# Verifica versión de npm:
npm -v # Debería mostrar "10.9.3".
```

### Installing CDK

```bash
sudo npm i -g aws-cdk
cdk --version
```

### IAM User
- New `IAM User` as Administrator
- Create an access Key

```bash
# Configure and Authenticate
aws configure
# Testing connection
aws s3 ls
```

## CDK AND CLOUDFORMATION INTRO

### AWS CloudFormation
- Service behind `CDK`
- Infrastructure as Code
- Templates `JSON / YAML`
- **Stack:** Collection of AWS resources managed as a single Unit
- **Stack Operations:** Create, update, delete
- **Functions:** get, ref, import... (Intrinsic)

`CloudFormation Template ---------> Stack`

### CDK Intro
![](Pasted%20image%2020251012161728.png)

Initialize in an empty directory
```bash
cdk init app --language python
```

For `Python` we can start creating our virtual environment
```bash
python3 -m venv .venv
# Then Activate that venv
source .venv/bin/activate
# Install requirements
pip install -r requirements.txt
```

Finally the synthesis step
```bash
cdk synth
```

### CDK Environment
- Required step for deployment: Bootstrap
`CDK Toolkit ----> IAM role for CDK`
`CDK Toolkit ---> S3 Bucket`

```bash
# Create the resources on AWS
cdk bootstrap [Account Number]/[Region]
# Deploy
cdk deploy
```

### CDK Code
- How does `CDK` knows where to look for `CDK`Code: `cdk.json`
- `cdk.out`: Stores the output for the `CloudFormation Template`

**CDK Stacks:**
Abstraction over `CloudFormation Stacks`
Extend the Stack class (object)

```python
class PyStarterStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)
```

- Stack properties:
	- Scope (app)
	- id
	- Optional properties

**CDK Constructs:**
- Abstraction over AWS resources
- Mos AWS services have their own constructs
- Properties:
	- Scope (stack)
	- id
	- Required/optional properties

**Levels of Constructs:**
- `L1`: Low level constructs - `cfn (CloudFormation)` resources. We must configure all required properties (For new services that are still not migrated)
- `L2`: AWS resources with a higher-level. `CDK` provides additional functionality like defaults, boiler plate and type safety for many parameters (Used most of the time)
- `L3`: Patterns. Combine multiple types of resources and help with common tasks in AWS. Example `LambdaRestApi` (Matter of preference)

![](Pasted%20image%2020251014183814.png)

### CDK Commands 

| Command                            | Description                                                                                                                                                                                |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `cdk init`                         | Initialize on an empty directory based on the language selected                                                                                                                            |
| `cdk bootstrap`                    | Create the resources on AWS                                                                                                                                                                |
| `cdk synth`                        | Create the `CloudFormation` template                                                                                                                                                       |
| `cdk deploy` \| `cdk deploy --all` | Deploy to AWS                                                                                                                                                                              |
| `cdk list`                         | Lists of our stacks (The ones that are on `app.py`)                                                                                                                                        |
| `cdk diff`                         | Shows the difference between locally and remotely on AWS. It uses<br>`CloudFormation DescribeStacks API`                                                                                   |
| `cdk doctor`                       | Shows problems with versions or implementation                                                                                                                                             |
| `cdk destroy`                      | Destroys the Stack as `CloudFormation` Delete does.<br>Special Note: If we `cdk destroy` with the `RemovalPolicy.DESTROY` `CDK` will create a custom Resource `Lambda`to complete the task |

## CDK INTERMEDIATE

### CDK IDs
- **Construct IDs:** Ourselves
```python
bucket = s3.Bucket(self, "PyBucket",...)
```
- **Logical IDs:** Construct ID + Suffix from CDK
```python
"Resources": {
  "PyBucket5C1531F2": {
    "Type": "AWS::S3::Bucket",
    "Properties": {
    }
  }
}
```
- **Physical ID:** Resource name. Used for reference inside other services (`ARN`)
`pystarterstack-pybucket5c1531f2-1rjjdg.....`

**How `CloudFormation` tracks resources:**
- By the Logical ID
- When Logical ID changes:
	- Old resource is removed
	- Creates a new one
- Potential problems:
	- Accidental deletion of `stateful resources (S3, DynamoDB)`
	- Resource already exists error

### CloudFormation Intrinsic Functions
Key to infrastructure as code
[Class Fn](https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.Fn.html)
And can be found on the file `PyStarterStack.template.json`

**Example:** `arn:aws:cloudformation:us-west-2:123456789012:stack/mystack-mynestedstack-sggfrhxhum7w/f449b250-b969-11e0-a185-5081d0136786`

```python
from aws_cdk import (
  Fn #CloudFromation Intrinsic functions
)

# Create a Private Method receive self and return string using Intrinsic functions
    def __initialize_suffix(self):
        short_stack_id = Fn.select(2, Fn.split('/', self.stack_id))
        suffix = Fn.select(4, Fn.split('-', short_stack_id))
        return suffix
```

**_Note:_** When using `self` we mean that it is this same `stack`
### Handling Multiple Stacks
- Due to complexity
- Some resources may be sensitive
- Some can take a long time to deploy
- Solution: Cross stack references, shared resources

**Recommendations:**
- Separate stacks for resources with state
- Separate stacks for IAM roles, policies, secrets
- Separate stacks for resource with complex initialization (VPCs, DNS)
- AWS Recommendation: Organize stacks by life cycle and ownership

**Cross-stack references:**
- CF intrinsic function: `Fn:ImportValue`
![](Pasted%20image%2020251014210350.png)

## SERVERLESS REST API

**Pre Requisites:**
- We need a rest client: `REST Client` from `VS Code` (Extensions)

### AWS Lambda and CDK
There are 3 levels of difficulty we can face:
![](Pasted%20image%2020251019101308.png)

- `aws-cdk-lib.aws_lambda` module: Generic: Function
	- `CDK` and lambda code can be written in different languages
	- Lambda runtime contain `AWS SDK`. No need to **bundle**
	- **Other dependencies**: Building required. `CDK` uses `Docker`
- **TypeScript:** `NodeJsFunction`
	- Requires `esbuild` packages. If not present it uses `Docker`
- **Python:** `aws_lambda_python_alpha` - If other dependencies are required
	- Still experimental
- **Other languages:** `Code.fromAsset`

### AWS Lambda Architecture: Multiple, Monolithic
**Multiple**
![](Pasted%20image%2020251019103118.png)

**Monolithic**
![](Pasted%20image%2020251019103051.png)

### The AWS SDK
- Interacts with AWS
	- Console: Using UI
	- CLI: Using commands `aws s3 ls`
	- Code: Using AWS SDKs `JavaScript, Python, etc`
		- Code can be run from EC2 instances
		- Lambda
		- Other AWS services
		- Our computer:
			- `JavaScript:` `aws-sdk-js-v3`
			- `Python:` `boto3`

### The AWS SDK - DynamoDB
- Write queries for `DynamoDB` (putltem, getltem)
- Run queries from AWS lambda
- Lambda needs to have access to the table
	- table name
	- IAM role for different operations
- Required:
	- `DynamoDB client` - Outside the Lambda body
- Use client to make request

```python
# Use it outside the Handler
table_name = os.environ.get("TABLE_NAME")
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(table_name)
```

Documentation: [aws dynamodb](https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.aws_dynamodb.TableV2.html)
We need to install:
```bash
pip install boto3
```

### TESTING REST CLIENT
We can use that extension:
```
# requests.http
# We get the url from the Deploy result during Lambda creation

@url = https://covr3k2a3h.execute-api.eu-west-1.amazonaws.com/prod

GET {{url}}/empl?id=kjasdnchfg

POST {{url}}/empl
content-type: application/json

{
  "name": "John",
  "possition": "engineer"
}
#Output: It will return the ID of the Item
```