# eks-terraform-with-addons
This is repository containts the Terraform configuration files to create an EKS cluster with addons.

I was actually using EKSCTL to provision an EKS clsuter previously. EKSCTL is a great tool but after provisioning the cluster I had to manually install several components like AWS LB Controller, ArgoCD, Metric Server and so on. So I decided to have something which will install all the addons of my choice along with the EKS cluster itself.

And here I have got a Terraform module called `eks_blueprints` and `eks_blueprints_addons`

This modules are quite simple to use and I tried to make it more simpler by adding a `variable.tf` file. 

Only after modifying the `variable.tf` file you can create an EKS cluster with your required configurations.

To install the desired addons you just need to mention it using `enable_<addon-name> = "true"` keyword in `addons.tf` file.

To see how many different addons can be installed using the `eks_blueprints_addons` module, refer to this [Link](https://github.com/aws-ia/terraform-aws-eks-blueprints-addons)

Finally to run this project edit the `variable.tf` file according to your desired state and also edit the `addons.tf` file for the specific addons and then run the terraform workflow. 

    terraform init
    terraform plan
    terraform apply

Right now `AWS LB Controller`, `Metric Server`, `Kube Prometheus Stack`, `Cert Manager`, and `ArgoCD` will be installed if you run this project without modifying the `addons.tf` file