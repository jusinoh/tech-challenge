# Technical Challenge TEKsystems

## Part 1: Container Security Implementation

### 1. Docker Security Best Practices

- Never run the container as root, and instead create a user. 
    - This prevents the container from escalalting its permissions which can lead to exploiting a vulnerability within the containers hosts, if there is a data mount on the host the container now can access that data. 

- Do not allow container access to the Docker daemon
    - The Docker daemon is owned by root, so allowing access to this can open up the environment to misuse from any containers, from modifying the environment to having access to all the resources within the evironment. Specifically tcp should not be enabled as this opens up unauthorized access and un-encrypted traffic to and from the daemon. info level logging should be enabled as well. 

- Limit resource access to containers
    - Avoid allowing unlimited acccess to memory and cpu access to ensure that min and max memory and cpu are clearly defined to ensure that the containers recieve what's necessary to stand up and necessary to operate without allocating all the resources of the environment. 

```
services:
  my_service:
    build: .
    image: my_image
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: '512M'
        reservations:
          cpus: '0.25'
          memory: '256M'
```

- Use Docker Secrets or other secrets management tool
    - Sensitive pieces of data or variables that should not be hardcoded into the config files, instead use another secrets managements tool to pass these values at runtime.

- Supply Chain Concerns
    - Use a lightweight image such as alpine and build off of this for the microservices, develop SBOM for each microservice and use them to perform SCA scans to identify the web of vulnerabilities that open up due to these dependencies or container scanning tools, store images in a registry with strictly enforced access controls (ECS) and supports tagging to ensure the correct container version is being used during pipelines. In Dockerfiles, dependencies should also point to specific versions for tools being used as opposed to just pulling the latest version, as this helps teams manage change control within their environment as it pertains to dependencies. 

### 2. K8s Security Configuration:

- Enforce strong authentication controls
    - Any access to the K8s cluster should be supported by MFA. Ideally, using K8s via a CSP such as AWS enables teams to use CSP provided credentials to access. Therefore, if the developer is granted access to the CSP via an MFA like Okta, and they assume a role into the environment (typically this assume role has timeframes such as inactivity and timeout restrictions), these roles can be used to access the EKS cluster. 

- Use namespaces within your K8s cluster to seperate different microservices.
    - This allows you to create partitions within your cluster to ensure services are not logically hosted togther which can lead to other items such as volume claims for services sitting in the same namespace. 

- Ensure an effective workload logging measure is in place
    - This can help security teams identify and create custom alert logic to determine various items such as outbound connections being established, files being interacted with via a container not accounted for, mountinging unusual or unknown paths to a container, etc. Given the level of sensitivity of files or pods being interacted with these resources should be scaled to 0 immediately to prevent any breach of data or additional resources. 

### 3. IaaS Security Measures:

- Infrastructure as a Service provides teams with virtualized compute resources which has aspects of it that can be managed by the CSP themselves such as scalability, disaster and recovery, and updates/ patches. Although the CSP handles various items given their specific shared responsibility model, it's critical to ensure teams understand what they are ultimately responsible for and ensure secure config/ coding practices are documented and implemented on these resources that interact with the IaaS service. Some of these items include data governance/ access management, endpoints, application configurations, network controls, OS configurations and more. 
    - Data at rest and in transit should always be verfied and configured (as an example, when dealing with Azure Storage accounts, by default TLS is not used)
    - Items such as security groups (host-based firewall), NACLs, Flow Logs, should be reviewed (if applicable) and configured properly in these models. 
    - Monitoring and Logging should always be reviewed. Although most services make them available, it is up to teams to configure and centralize these logs into buckets or other services/ tools to make the most of these logs. (i.e. WAF rules will block based on what's being identified given the set of rules applied, however, traffic and all other logs can be reviewed for malicious traffic that may be specific to your deployment or environment for malicious traffic)
    - As with anything else being deployed, access should be monitored for authentication/ authorization to ensure. For instance, in an EKS environment, each resource, nodes for instance, should point to other security groups for access, as opposed to IP addresses to avoid any sort of spoofing, as this validates where the traffic is originating from. 

## Part 2: CI/CD Pipeline Setup

### 1. Configuration Management with Terraform:

- [Terraform](https://github.com/jusinoh/tech-challenge/tree/main/terraform)

### 2. 