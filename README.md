# terraform-aws-lambda-powerdown

AWS Lambda function to automatically start/stop EC2 instances in AWS according to timestamps specified within the EC2 instance tags.

NB: Requires Terraform v0.12.

## Configuration

The function polls at one minute past the hour, every hour, Monday-Friday, for qualifying instances.

| powerDownEnabled | True  |   |   |   |
|------------------|-------|---|---|---|
| StartSchedule    | 09:00 |   |   |   |
| StopSchedule     | 17:30 |   |   |   |

## Example

EC2 instance is in a _stopped_ state and has a StartSchedule tag of 09:00 (UTC). A poll of instances is made at 10:01 (BST) and the instance is added to the start list: 

```
09:01:13  START RequestId: c2af0d92-46a1-4513-a140-21ccb15e5395 Version: $LATEST
09:01:14  [ 09:01 ] Instance i-07e055ff314026f2f has been added to START list
09:01:14  [ 09:01 ] No instances to stop in the list
09:01:14. [{'StartingInstances': [{'CurrentState': {'Code': 0, 'Name': 'pending'}, 'InstanceId': 'i-07e055ff314026f2f', 'PreviousState': {'Code': 80, 'Name': 'stopped'}}], 'ResponseMetadata': {'RequestId': '0b6fda3d-048f-4901-92be-082c87f1da16', 'HTTPStatusCode': 200, 'HTTPHeaders': {'content-type': 'text/xml;charset=UTF-8', 'content-length': '579', 'date': 'Wed, 16 Oct 2019 09:01:14 GMT', 'server': 'AmazonEC2'}, 'RetryAttempts': 0}}]
09:01:14. END RequestId: c2af0d92-46a1-4513-a140-21ccb15e5395
```
 
EC2 instance is in a _running_ state and has a StopSchedule tag of 09:50 (UTC). A poll of instances is made at 11:01 (BST) and the instance is added to the stop list:

```
10:01:14  START RequestId: 670c8000-3ab1-4cdc-9711-56e4c0c37d2d Version: $LATEST
10:01:14  [ 10:01 ] Instance i-07e055ff314026f2f has been added to STOP list
[{'StoppingInstances': [{'CurrentState': {'Code': 64, 'Name': 'stopping'}, 'InstanceId': 'i-07e055ff314026f2f', 'PreviousState': {'Code': 16, 'Name': 'running'}}], 'ResponseMetadata': {'RequestId': 'c0d3eb28-1e20-44ee-9c0b-667bb16e7678', 'HTTPStatusCode': 200, 'HTTPHeaders': {'content-type': 'text/xml;charset=UTF-8', 'content-length': '579', 'date': 'Wed, 16 Oct 2019 10:01:14 GMT', 'server': 'AmazonEC2'}, 'RetryAttempts': 0}}]
10:01:14  [ 10:01 ] No instances to start in the list
10:01:14  END RequestId: 670c8000-3ab1-4cdc-9711-56e4c0c37d2d
```

## Deployment

```
cd terraform
```

Initialise the modules.

```
terraform init
```

Check for changes / errors.

```
terraform plan
```

Execute the deployment.

```
terraform apply
```
