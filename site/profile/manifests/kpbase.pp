class profile::kpbase ( 
  $abcid = undef,
  $sr    = undef,
  $nuid  = undef,
  $wo    = undef,
) {

  case $::operatingsystem {
    redhat: {

      contain 'osfamily::yumrepo'
      contain 'profile::kpbase::l2_stage1'
      contain 'kp_linux_base::yum_update'
      contain 'profile::kpbase::l2_stage2'

      Class['osfamily::yumrepo']          ->
      Class['profile::kpbase::l2_stage1'] ->
      Class['kp_linux_base::yum_update']  ->
      Class['profile::kpbase::l2_stage2'] 

    }
    windows: { }

  }
}
