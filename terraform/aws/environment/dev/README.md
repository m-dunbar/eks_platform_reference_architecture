# aws/environment/dev

Each of the included directories contain discrete, resource-specific Terraform.  These individual directories will also create and enforce compartmentalized tfstate segmentation by resource type.  This helps limit the potential blast radius of any associated `terraform apply` operations.

## Order of Operations

The numeric prefixes indicate the appropriate order in which specific terraform sets should be applied, to correctly address specific order dependencies between resource types.  Applying resource sets out of order, may (and in some cases absolutely will) result in `terraform apply` failures due to unresolved implicit or explicit dependencies.

Please review the READMEs for each section for further information.

## Additional Note

While any of the terraform contained herein may be manually applied, a Makefile has been included at the top level of the repo that will correctly process layers of the terraform stack, allowing progressive deployment, and automatic handling of key bootstrap resource types to establish S3-based backends, and state-locking to allow multiple engineers to all work on IaC segments without fear of accidental planning or application collision.

## Further reading

Please see Hashicorp's [Terraform documentation on S3 Backend State Storage, State Locking and lockfiles](https://developer.hashicorp.com/terraform/language/backend/s3) and for further information if any of this is unclear.

---

© 2025 Matthew Dunbar  
(See LICENSE for details.)
