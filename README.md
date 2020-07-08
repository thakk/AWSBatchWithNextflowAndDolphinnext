AWS batch usage example pipeline


## Initial configuration

Initial DolphinNext configuration must be done before any AWS Batch pipeline is used.

### AWS configuration

Create IAM user with permissions to run AWS batch and access S3 storage. Add following policies to user:

    - AmazonEC2FullAccess
    - AmazonS3FullAccess
    - AWSBatchFullAccess

Be aware that these policies may be overly permissive.

### AWS S3 bucket setup

Create appropriate bucket for appropriate region. Be aware that bucket should be in same region as computation.

### AWS Batch setup

First create Compute environment. Critical settings are:

    - Compute environment type: managed
    - EC2 key pair
    - Provisioning model: On-Demand or Spot
    - Allowed instance types . 
    - Minimum vCPUs: 0
    - Enable user-specified Ami ID: ami-0936592854e308547 . This AMI has been prepared to allow Docker in NF-DN-AWS combo.

Then create job queue and connect it to compute environment.

### SSH key configuration in DolphinNext

Create separate keys in "SSH Keys" and "Amazon Keys"- tabs under Profiles. 

### Profile configuration in DolphinNext

Create new Run Environment:

    - Type: Amazon Web Services
    - Match appropriate SSH and Amazon keys
    - Instance Type: t2.micro . Instance is used to launch AWS Batch jobs and it does not need to be very powerful.
    - Image Id: ami-0ef0e5b5eb79d3e27 . This AMI has been preconfigured for Nextflow-AWSBatch use.
    - Default Working Directory: /tmp . Temporary files will be created here
    - Default Bucket Location for Publishing: s3://nf-icgc/publish . Or something similar
    - Run command: export NXF_WORK=s3://nf-icgc/work
    
## Pipeline configuration

These settings will be used for each unique pipeline run.

    - Work Directory: /tmp/
    - Run Environment: your previously configured Amazon environment
    - InputFile: For example from https source
    - Under AWS Batch settings:
        - accessKey: This can be found or created from AWS console->IAM->Users->Security credentials
        - secretKey: as above
        - region: us-east-1 . Also known as N.Virginia. This is used in ICGC data access pipelines
        - queue: Previously in AWS Batch step configured Batch Queue name
        - outdir: S3 target directory for pipeline results
        
## Running pipeline

    - Launch AWS instance: Push "Amazon Web Services" -button 
        - Nodes: 1
        - Use Autoscale: off
        - Auto Shutdown: on
        - Press "Activate Cluster"

Launching AWS instance will take some minutes.

Once AWS instance is running and pipeline run configuration is complete "Run"- button will turn to green and pipeline is ready to run.