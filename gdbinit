set auto-load safe-path /

define plist
  set var $n = $arg0
  while $n != 0
    print *$n
    set var $n = $n->next
  end
end
