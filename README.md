# golden-image

## Tutorial

- [Getting Started with AWS | Packer - HashiCorp Learn](https://learn.hashicorp.com/collections/packer/aws-get-started)
- https://learn.hashicorp.com/tutorials/packer/aws-get-started-build-image?in=packer/aws-get-started
  - [Amazon AMI \- Builders \| Packer by HashiCorp](https://www.packer.io/plugins/builders/amazon)
  - [Ubuntu Amazon EC2 AMI Finder](https://cloud-images.ubuntu.com/locator/ec2/)

## Operations in CLI

```shell
$ export AWS_PROFILE=serverless ;\
  export AWS_DEFAULT_REGION="$(aws    configure --profile $AWS_PROFILE get region)" ;\
  export AWS_ACCESS_KEY_ID="$(aws     configure --profile $AWS_PROFILE get aws_access_key_id)" ;\
  export AWS_SECRET_ACCESS_KEY="$(aws configure --profile $AWS_PROFILE get aws_secret_access_key)" ;\
  echo $AWS_DEFAULT_REGION $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY

$ packer build .
learn-packer.amazon-ebs.ubuntu: output will be in this color.

==> learn-packer.amazon-ebs.ubuntu: Prevalidating any provided VPC information
==> learn-packer.amazon-ebs.ubuntu: Prevalidating AMI Name: learn-packer-linux-aws
    learn-packer.amazon-ebs.ubuntu: Found Image ID: ami-0b64a13ca42f69187
==> learn-packer.amazon-ebs.ubuntu: Creating temporary keypair: packer_63307f47-593a-7db1-e234-859b0a2cda7c
==> learn-packer.amazon-ebs.ubuntu: Creating temporary security group for this instance: packer_63307f48-c006-e09b-040d-a9dbe0e17a2b
==> learn-packer.amazon-ebs.ubuntu: Authorizing access to port 22 from [0.0.0.0/0] in the temporary security groups...
==> learn-packer.amazon-ebs.ubuntu: Launching a source AWS instance...
    learn-packer.amazon-ebs.ubuntu: Instance ID: i-0bd5bab14fad869ef
==> learn-packer.amazon-ebs.ubuntu: Waiting for instance (i-0bd5bab14fad869ef) to become ready...
==> learn-packer.amazon-ebs.ubuntu: Using SSH communicator to connect: 18.181.249.74
==> learn-packer.amazon-ebs.ubuntu: Waiting for SSH to become available...
==> learn-packer.amazon-ebs.ubuntu: Connected to SSH!
==> learn-packer.amazon-ebs.ubuntu: Stopping the source instance...
    learn-packer.amazon-ebs.ubuntu: Stopping instance
==> learn-packer.amazon-ebs.ubuntu: Waiting for the instance to stop...
==> learn-packer.amazon-ebs.ubuntu: Creating AMI learn-packer-linux-aws from instance i-0bd5bab14fad869ef
    learn-packer.amazon-ebs.ubuntu: AMI: ami-0576e64bfbb71fb78
==> learn-packer.amazon-ebs.ubuntu: Waiting for AMI to become ready...
==> learn-packer.amazon-ebs.ubuntu: Skipping Enable AMI deprecation...
==> learn-packer.amazon-ebs.ubuntu: Terminating the source AWS instance...
==> learn-packer.amazon-ebs.ubuntu: Cleaning up any extra volumes...
==> learn-packer.amazon-ebs.ubuntu: No volumes to clean up, skipping
==> learn-packer.amazon-ebs.ubuntu: Deleting temporary security group...
==> learn-packer.amazon-ebs.ubuntu: Deleting temporary keypair...
Build 'learn-packer.amazon-ebs.ubuntu' finished after 3 minutes 732 milliseconds.

==> Wait completed after 3 minutes 734 milliseconds

==> Builds finished. The artifacts of successful builds are:
--> learn-packer.amazon-ebs.ubuntu: AMIs were created:
ap-northeast-1: ami-0576e64bfbb71fb78
```

## Provision - Shell provisioner

[Provision \| Packer \- HashiCorp Learn](https://learn.hashicorp.com/tutorials/packer/aws-get-started-provision?in=packer/aws-get-started)

- [Shell \- Provisioners \| Packer by HashiCorp](https://www.packer.io/docs/provisioners/shell)
