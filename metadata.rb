name             'appv'
maintainer       'Adam Mielke, (C) Regents of the University of Minnesota'
maintainer_email 'adam@umn.edu'
license          'Apache 2.0'
description      'Installs/Configures appv'
depends          'powershell', '>= 1.1.0' # We use Chef::Mixin::PowershellOut which debuted in powershell cookbook v1.1.0
depends          'windows'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'
