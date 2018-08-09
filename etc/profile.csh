# Do not source any files if already sourced
if ( ! $?FL_CSH_SOURCED ) then
  setenv FL_CSH_SOURCED true

  setenv cw_ROOT $FL_ROOT

  if ( -d "${cw_ROOT}"/etc/profile.d ) then
    set nonomatch
    foreach i ( "${cw_ROOT}"/etc/profile.d/*.csh )
      if ( -r "$i" ) then
        if ($?prompt) then
              source "$i"
        else
              source "$i" >& /dev/null
        endif
      endif
    end
    unset i nonomatch
  endif
endif

