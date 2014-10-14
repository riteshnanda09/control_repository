class profile::os 

{
	case $::operatingsystem {
		redhat: { 
	  	          include osfamily::yumrepo
       
			}

		windows: {
			}

}
}	
