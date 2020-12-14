#!/bin/bash

PACKER=$(which packer)
TF=$(which terraform)
out_plan=out_plan
packer_out_file=/tmp/$$_packer_out.log
terraform_out_file=/tmp/$$_terraform_out.log
terraform_elbs_file=/tmp/$$_terraform_output

## Create an AMI using Packer and Ansible
cd packer 

$PACKER build template.json >> $packer_out_file

## Start a new Infrastructure using terraform if the image was created successfully
if [ $? -eq 0 ]
then
  echo "Creating infra with Terraform"
  cd ../terraform;
  $TF init && $TF plan --out $out_plan && $TF apply "$out_plan" >> $terraform_out_file;
else 
  echo "Packer image was not built successfully, please verify "
fi

if [ $? -eq 0 ] 
then
  $TF output > $terraform_elbs_file

  ## Validate connection to ELB using curl

  cd ..

  count_ok=0
  total_elb=$(cat $terraform_elbs_file | grep -v elb_dns_names | grep elb | tr -d '",^ ' | wc -l)
	
  # Wait some time for DNS propagation
  sleep 30

  for i in $(cat $terraform_elbs_file | grep -v elb_dns_names | grep elb | tr -d '",^ '); 
  do
    echo -e "***Testing => $i"
    curl -I http://$i | grep '200 OK' && let count_ok+=1
  done

  if [ $count_ok -eq $total_elb ] 
  then
    echo "All ELB are working correctly"
  elif [count_ok -gt 0]
  then
    echo "At least one ELB is working correctly"
  else
    echo "None of ELB is working correctly"
  fi
else
  echo "Something got wrong with terraform execution. Please verify the $terraform_out_file file."	
fi
