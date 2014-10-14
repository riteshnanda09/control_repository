class profile::kpbase::l2_stage2 {

  contain 'kp_linux_base::vmwaretools'
  contain 'kp_linux_base::patch_validation'
  contain 'kp_linux_base::uam_030'

}
