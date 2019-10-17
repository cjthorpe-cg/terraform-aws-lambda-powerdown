import boto3
import time

# Defining boto3 the connection
ec2 = boto3.resource('ec2')

def timeInRange(startRange, endRange, currentRange):
    if startRange <= endRange:
        return startRange <= currentRange <= endRange
    else:
        return startRange <= currentRange or currentRange <= endRange

def lambda_handler(event, context):
    
    currentTime = time.strftime("%H:%M")

    filters = [{
            'Name': 'tag:powerDownEnabled',
            'Values': ['True']
        }
    ]

    instances = ec2.instances.filter(Filters=filters)

    stopInstancesList = []
    startInstancesList = []

    for instance in instances:
            
        for tag in instance.tags:

            if tag['Key'] == 'StopSchedule':

                stopTime = tag['Value']
                pass

            if tag['Key'] == 'StartSchedule':

                startTime = tag['Value']
                pass

            pass

        instanceState = instance.state['Name']

        if timeInRange(startRange=startTime, endRange=stopTime, currentRange=currentTime):

            if (instanceState == "running") or (instanceState == "pending"):
                print("[", currentTime, "]", "Instance", instance.id, "already running, it won't be added to START list")
            else:
                startInstancesList.append(instance.id)
                print("[", currentTime, "]", "Instance", instance.id, "has been added to START list")
                
                pass

        elif timeInRange(startRange=startTime, endRange=stopTime, currentRange=currentTime) == False:

            if (instanceState == "stopped") or (instanceState == "stopping"):
                print("[", currentTime, "]", "Instance", instance.id, "already stopped, it won't be added to STOP list")
            else:
                stopInstancesList.append(instance.id)
                print("[", currentTime, "]", "Instance", instance.id, "has been added to STOP list")
                
                pass

        pass

    if len(stopInstancesList) > 0:
        stop = ec2.instances.filter(InstanceIds=stopInstancesList).stop()
        print(stop)
    else:
        print("[", currentTime, "]", "No instances to stop in the list")

    if len(startInstancesList) > 0:
        start = ec2.instances.filter(InstanceIds=startInstancesList).start()
        print(start)
    else:
        print("[", currentTime, "]", "No instances to start in the list")
