# Platform Subscription

The Platform Subscription holds the most important services that are needed to run the Azure environment. This Subscription does not follow the default Subscription template so that changes in this subscription can be controled seperately. 

>>Only System Engineers should have access and any changes should go through change control. 

### Workspace

The workspace for this Terraform file is "Platform" 

To create this workspace in an environment it does not exist run:
```terraform 
terraform workspace new Platform
```

To move into this workspace run:
```terraform 
terraform workspace select Platform
```