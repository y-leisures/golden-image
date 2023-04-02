packer_init:
	packer init .

packer_build:
	packer build .

packer_build_db:
	packer build -only=single-db.amazon-ebs.ubuntu-basic .

list_ami:
	aws ec2 describe-images --owner self | jq ".Images[].ImageId"

deregister_ami:
	aws ec2 deregister-image --image-id `aws ec2 describe-images --owner self | jq -r ".Images[].ImageId"`
