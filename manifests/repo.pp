class webmin::repo (
  $repo         = $webmin::repo,
  $proxy        = $webmin::proxy,
  ) inherits webmin {
  if ( $repo == 'webmin.com' ) and ( $osfamily == 'RedHat' ) {
    yumrepo { 'webmin':
      mirrorlist => 'http://download.webmin.com/download/yum/mirrorlist',
      enabled    => '1',
      proxy      => $proxy,
      gpgcheck   => '1',
      gpgkey     => 'http://www.webmin.com/jcameron-key.asc',
      descr      => 'Webmin Distribution',
    }
  } elsif ( $repo == 'webmin.com' ) and ( $osfamily == 'Debian' ) {
    #apt::key { 'webmin':
    #  key        => '1719003ACE3E5A41E2DE70DFD97A3AE911F63C51',
    #  key_source => 'http://www.webmin.com/jcameron-key.asc',
    #} ->
    apt::source { 'webmin_mirror':
      location    => 'http://webmin.mirror.somersettechsolutions.co.uk/repository',
      release     => 'sarge',
      repos       => 'contrib',
      key         => {
        'id'      => '1719003ACE3E5A41E2DE70DFD97A3AE911F63C51',
        'source'  => 'http://www.webmin.com/jcameron-key.asc',
      },
     include      => { 'src' => false },
    } 
    apt::source { 'webmin_main':
      location    => 'http://download.webmin.com/download/repository',
      release     => 'sarge',
      repos       => 'contrib',
      key         => {
        'id'      => '1719003ACE3E5A41E2DE70DFD97A3AE911F63C51',
        'source'  => 'http://www.webmin.com/jcameron-key.asc',
      },
      include      => { 'src' => false },
    }
  } else {}
}
