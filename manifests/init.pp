class webmin(
  $webmin_port = '10000',
  $usermin_port = '20000',
  $proxy = 'absent',
  $csf = false,
  $ensure = 'latest',
  ) {
  if ( $osfamily == 'redhat' ) {
    yumrepo { 'webmin':
      mirrorlist => 'http://download.webmin.com/download/yum/mirrorlist',
      enabled    => '1',
      proxy      => $proxy,
      gpgcheck   => '1',
      gpgkey     => 'http://www.webmin.com/jcameron-key.asc',
      descr      => 'Webmin Distribution',
    }
    $pkgs = [
      'usermin',
      'webmin',
    ]
    package { $pkgs:
      ensure  => $ensure,
      require => Yumrepo['webmin'],
    }
    ensure_packages(['perl-Net-SSLeay'])
    augeas { 'webmin_miniserv':
      context => "/files/etc/webmin/miniserv.conf",
      changes => [
        "set ssl 1",
        "set port $webmin_port",
      ],
      notify  => Service['webmin'],
      require => Package['webmin'],
    }
    service { 'webmin':
      ensure    => running,
      enable    => true,
      subscribe => Package[$pkgs],
    }
    if ( $csf == true ) {
      File {
        require => Package['webmin'],
        notify  => Service['webmin'],
      }
      file { '/usr/libexec/webmin/csf': 
        ensure => directory,
        owner  => '0',
        group  => 'bin',
        mode   => '0755',
      }
      file { '/usr/libexec/webmin/csf/csfimages':
        ensure => link,
        target => '/usr/local/csf/lib/webmin/csf/images',
      }
      file { '/usr/libexec/webmin/csf/index.cgi':
        ensure => link,
        target => '/usr/local/csf/lib/webmin/csf/index.cgi',
      }
      file { '/usr/libexec/webmin/csf/module.info':
        ensure => link,
        target => '/usr/local/csf/lib/webmin/csf/module.info',
      }
      webmin::acl { 'firewall':
        action => delete,
      }
      webmin::acl { 'csf':
        action => add,
      }
    } else {}
  } else {}
}
