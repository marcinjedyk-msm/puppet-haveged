# = Class: haveged::config
#
# Manage the haveged configuration file
#
# == Parameters:
#
# [*buffer_size*]
#   The size of the collection buffer in KB.
#
# [*data_cache_size*]
#   The data cache size in KB.
#
# [*instruction_cache_size*]
#   The instruction cache size in KB.
#
# [*write_wakeup_threshold*]
#   The haveged daemon generates more data if the number of entropy bits
#   falls below this value.
#
# == Requires:
#
# Augeas bindings for Puppet. Puppetlabs stdlib module.
#
# == Sample Usage:
#
#   class { 'haveged::config': }
#
#
class haveged::config (
  $buffer_size            = undef,
  $data_cache_size        = undef,
  $instruction_cache_size = undef,
  $write_wakeup_threshold = undef,
) inherits haveged::params {

  # Validate numeric parameters
  if ($buffer_size != undef) {
    validate_re($buffer_size, '^[0-9]+$')
  }
  if ($data_cache_size != undef) {
    validate_re($data_cache_size, '^[0-9]+$')
  }
  if ($instruction_cache_size != undef) {
    validate_re($instruction_cache_size, '^[0-9]+$')
  }
  if ($write_wakeup_threshold != undef) {
    validate_re($write_wakeup_threshold, '^[0-9]+$')
  }

  $opts_hash = {
    '-b' => $buffer_size,
    '-d' => $data_cache_size,
    '-i' => $instruction_cache_size,
    '-w' => $write_wakeup_threshold,
  }

  # Remove all entries where the value is 'undef'
  $opts_ok = delete_undef_values($opts_hash)

  # Concat key and value into array elements
  $opts_strings = join_keys_to_values($opts_ok, ' ')

  # Join array elements into one string
  $opts = join($opts_strings, ' ')

  # Update configuration
  file_line { 'haveged-daemon_args':
    ensure => 'present',
    match  => "^${::haveged::params::daemon_options_args}",
    line   => "${::haveged::params::daemon_options_args}=\"${opts}\"",
    path   => $::haveged::params::daemon_options_file,
  }
}
