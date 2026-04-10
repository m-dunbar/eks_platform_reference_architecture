# aws/environment/dev

Each of the included directories contain discrete, resource-specific Terraform.  These individual directories will also create and enforce compartmentalized tfstate segmenation by resource type.  This helps limit the potential blast radius of any associated `terraform apply` operations.

The numeric prefixes indicate the appropriate order in which specific terraform sets should be applied, to correctly address specific order dependencies between resource types.  Applying resource sets out of order, may (and in some cases absolutely will) result in `terraform apply` failures due to unresolved implicit or explicit dependencies.

Please review the READMEs for each section for further information.

---

© 2025 Matthew Dunbar  
(See LICENSE for details.)
